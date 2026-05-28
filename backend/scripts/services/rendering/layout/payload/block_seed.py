from __future__ import annotations

from statistics import median

from services.document_schema.semantics import is_caption_like_block
from services.rendering.layout.font_fit import BODY_LEADING_FLOOR_MIN
from services.rendering.layout.font_fit import BODY_LEADING_MAX
from services.rendering.layout.font_fit import BODY_LEADING_MIN
from services.rendering.layout.font_fit import BODY_LEADING_SIZE_ADJUST
from services.rendering.layout.font_fit import NON_BODY_LEADING_FLOOR_MIN
from services.rendering.layout.font_fit import NON_BODY_LEADING_MAX
from services.rendering.layout.font_fit import NON_BODY_LEADING_MIN
from services.rendering.layout.font_fit import NON_BODY_LEADING_SIZE_ADJUST
from services.rendering.layout.font_fit import cover_bbox as resolve_cover_bbox
from services.rendering.layout.font_fit import estimate_font_size_pt
from services.rendering.layout.font_fit import estimate_leading_em
from services.rendering.layout.font_fit import is_body_text_candidate
from services.rendering.layout.font_fit import normalize_leading_em_for_font_size
from services.rendering.layout.font_fit import page_baseline_font_size
from services.rendering.layout.font_fit import percentile_value
from services.rendering.layout.font_fit import resolve_font_weight
from services.rendering.layout.payload.body_context import page_box_area_ratio as compute_page_box_area_ratio
from services.rendering.layout.payload.capacity import estimated_render_height_pt
from services.rendering.layout.payload.metrics import fit_translated_block_metrics
from services.rendering.layout.payload.shared import COMPACT_SCALE
from services.rendering.layout.payload.shared import HEAVY_COMPACT_RATIO
from services.rendering.layout.payload.shared import get_render_formula_map
from services.rendering.layout.payload.shared import get_render_protected_text
from services.rendering.layout.payload.shared import is_flag_like_plain_text_block
from services.rendering.layout.payload.shared import translation_density_ratio
from services.rendering.layout.typography.geometry import inner_bbox
from services.rendering.layout.typography.measurement import bbox_height
from services.rendering.layout.typography.measurement import bbox_width
from services.rendering.layout.typography.measurement import source_visual_line_count
from services.translation.item_reader import item_block_kind


BODY_PAGE_FONT_ANCHOR_PERCENTILE = 0.46
BODY_PAGE_FONT_FLOOR_DELTA_PT = 0.38
SMALL_PAGE_BOX_RATIO = 0.06
ULTRA_SMALL_PAGE_BOX_RATIO = 0.04
WIDE_ASPECT_BODY_RATIO = 3.6
WIDE_ASPECT_BODY_FONT_BOOST_PT = 0.28
WIDE_ASPECT_BODY_LEADING_TARGET = 0.64
WIDE_ASPECT_BODY_LEADING_STEP = 0.02
WIDE_ASPECT_BODY_MIN_SLACK_PT = 2.8

def _is_caption_like(item: dict) -> bool:
    return is_caption_like_block(item)


def _relax_wide_aspect_body_leading(
    inner: list[float],
    translated_text: str,
    formula_map: list[dict],
    font_size_pt: float,
    leading_em: float,
) -> float:
    if len(inner) != 4:
        return leading_em
    available_height_pt = max(8.0, inner[3] - inner[1])
    candidate = leading_em
    while candidate + WIDE_ASPECT_BODY_LEADING_STEP <= WIDE_ASPECT_BODY_LEADING_TARGET:
        next_leading = round(candidate + WIDE_ASPECT_BODY_LEADING_STEP, 2)
        next_height = estimated_render_height_pt(inner, translated_text, formula_map, font_size_pt, next_leading)
        if next_height > available_height_pt - WIDE_ASPECT_BODY_MIN_SLACK_PT:
            break
        candidate = next_leading
    return candidate


def _collect_page_seed_metrics(
    translated_items: list[dict],
) -> tuple[
    float,
    float,
    float,
    float,
    float,
    dict[int, bool],
    dict[int, tuple[float, float]],
    float | None,
    float | None,
]:
    page_font_size, page_line_pitch, page_line_height, density_baseline = page_baseline_font_size(translated_items)
    text_widths = [bbox_width(item) for item in translated_items if item_block_kind(item) == "text" and not _is_caption_like(item)]
    page_text_width_med = median(text_widths) if text_widths else 0.0
    body_base_sizes: list[float] = []
    body_flags: dict[int, bool] = {}
    base_metrics: dict[int, tuple[float, float]] = {}

    for index, item in enumerate(translated_items):
        is_body = is_body_text_candidate(item, page_text_width_med)
        item_with_flag = {**item, "_is_body_text_candidate": is_body}
        body_flags[index] = is_body
        font_size_pt = estimate_font_size_pt(
            item_with_flag,
            page_font_size,
            page_line_pitch,
            page_line_height,
            density_baseline,
        )
        leading_em = estimate_leading_em(item_with_flag, page_line_pitch, font_size_pt)
        base_metrics[index] = (font_size_pt, leading_em)
        if is_body:
            body_base_sizes.append(font_size_pt)

    page_body_font_size_pt = round(percentile_value(body_base_sizes, BODY_PAGE_FONT_ANCHOR_PERCENTILE), 2) if body_base_sizes else None
    if page_body_font_size_pt is not None and page_font_size > 0:
        page_body_font_size_pt = round(max(page_body_font_size_pt, page_font_size - BODY_PAGE_FONT_FLOOR_DELTA_PT), 2)
    body_widths = [bbox_width(item) for index, item in enumerate(translated_items) if body_flags.get(index)]
    page_body_width_pt = median(body_widths) if body_widths else None
    return (
        page_font_size,
        page_line_pitch,
        page_line_height,
        density_baseline,
        page_text_width_med,
        body_flags,
        base_metrics,
        page_body_font_size_pt,
        page_body_width_pt,
    )


def adjust_three_column_tables(translated_items: list[dict], page_width: float) -> None:
    ACTION_KEYWORDS = {"CHEC", "IL", "TPA", "INFO", "信息", "全体", "ALL", "TPA/IL/CHEC"}
    tables = {}
    for item in translated_items:
        is_cell = (
            item.get("translate_reason") == "table_cell"
            or item.get("provenance", {}).get("raw_label") == "table_cell"
            or item.get("layout_role") == "table_cell"
            or item.get("block_type") == "table_cell"
        )
        parent_id = item.get("metadata", {}).get("parent_block_id")
        if is_cell and parent_id:
            tables.setdefault(parent_id, []).append(item)
            
    for parent_id, cells in tables.items():
        valid_cells = []
        for c in cells:
            bbox = c.get("bbox")
            if bbox and len(bbox) == 4:
                valid_cells.append((c, bbox))
        if not valid_cells:
            continue
            
        has_col_indices = all(c.get("metadata", {}).get("col_index") is not None for c, bbox in valid_cells)
        max_col_idx = max(c.get("metadata", {}).get("col_index", -1) for c, bbox in valid_cells) if valid_cells else -1
        
        columns = [[], [], []]
        if has_col_indices and max_col_idx == 2:
            for cell_info in valid_cells:
                c, bbox = cell_info
                col_idx = c["metadata"]["col_index"]
                if 0 <= col_idx < 3:
                    columns[col_idx].append(cell_info)
        else:
            valid_cells_sorted = sorted(valid_cells, key=lambda x: x[1][0])
            columns_cluster = []
            for cell_info in valid_cells_sorted:
                c, bbox = cell_info
                x0 = bbox[0]
                found = False
                for col in columns_cluster:
                    avg_x0 = sum(x[1][0] for x in col) / len(col)
                    if abs(x0 - avg_x0) < 20.0:
                        col.append(cell_info)
                        found = True
                        break
                if not found:
                    columns_cluster.append([cell_info])
            if len(columns_cluster) == 3:
                columns_cluster.sort(key=lambda col: sum(x[1][0] for x in col) / len(col))
                columns = columns_cluster
            else:
                columns = []
                
        if len(columns) == 3 and columns[0] and columns[1] and columns[2]:
            col2 = columns[2]
            col3_texts = []
            for c, bbox in col2:
                text = str(
                    c.get("translation", {}).get("translated_text")
                    or c.get("content", {}).get("text")
                    or ""
                ).strip()
                if text:
                    col3_texts.append(text)
            
            col3_max_len = max(len(t) for t in col3_texts) if col3_texts else 0
            col3_is_action = any(t in ACTION_KEYWORDS for t in col3_texts)
            
            if col3_max_len <= 12 and col3_is_action:
                min_width = 0.15 * page_width
                
                row_to_col1 = {}
                row_to_col2 = {}
                
                has_row_indices = all(c.get("metadata", {}).get("row_index") is not None for c, bbox in valid_cells)
                
                if has_row_indices:
                    for c, bbox in columns[1]:
                        row_to_col1[c["metadata"]["row_index"]] = (c, bbox)
                    for c, bbox in columns[2]:
                        row_to_col2[c["metadata"]["row_index"]] = (c, bbox)
                else:
                    for c2, bbox2 in columns[2]:
                        y_mid = (bbox2[1] + bbox2[3]) / 2.0
                        best_c1 = None
                        best_diff = 9999.0
                        for c1, bbox1 in columns[1]:
                            y_mid1 = (bbox1[1] + bbox1[3]) / 2.0
                            diff = abs(y_mid - y_mid1)
                            if diff < best_diff:
                                best_diff = diff
                                best_c1 = (c1, bbox1)
                        if best_c1 and best_diff < 15.0:
                            row_id = id(c2)
                            row_to_col1[row_id] = best_c1
                            row_to_col2[row_id] = (c2, bbox2)
                            
                for r_id, (c2, bbox2) in row_to_col2.items():
                    x0_2, y0_2, x1_2, y1_2 = bbox2
                    width2 = x1_2 - x0_2
                    if width2 < min_width:
                        delta = min_width - width2
                        
                        new_x0_2 = x1_2 - min_width
                        bbox2[0] = new_x0_2
                        if "geometry" in c2 and isinstance(c2["geometry"], dict) and "bbox" in c2["geometry"]:
                            c2["geometry"]["bbox"][0] = new_x0_2
                            
                        if r_id in row_to_col1:
                            c1, bbox1 = row_to_col1[r_id]
                            new_x1_1 = bbox1[2] - delta
                            bbox1[2] = new_x1_1
                            if "geometry" in c1 and isinstance(c1["geometry"], dict) and "bbox" in c1["geometry"]:
                                c1["geometry"]["bbox"][2] = new_x1_1


def build_block_payloads(
    translated_items: list[dict],
    *,
    page_width: float | None = None,
    page_height: float | None = None,
) -> tuple[list[dict], float]:
    if page_width and page_width > 0:
        adjust_three_column_tables(translated_items, page_width)

    (
        page_font_size,
        page_line_pitch,
        page_line_height,
        density_baseline,
        page_text_width_med,
        body_flags,
        base_metrics,
        page_body_font_size_pt,
        page_body_width_pt,
    ) = _collect_page_seed_metrics(translated_items)
    block_payloads: list[dict] = []

    for index, item in enumerate(translated_items):
        # 过滤被判定为failed_table_passthrough的废弃英文段落块，防止它们在页面上被重新渲染
        if item.get("policy", {}).get("translate_reason") == "failed_table_passthrough":
            continue
        translated_text = get_render_protected_text(item)
        bbox = item.get("bbox", [])
        if len(bbox) != 4 or not translated_text:
            continue

        use_raw_text_bbox = bool(item.get("_use_raw_text_bbox"))
        font_size_pt, leading_em = base_metrics[index]
        formula_map = get_render_formula_map(item)
        density_ratio = translation_density_ratio(item, translated_text)
        page_box_area_ratio = compute_page_box_area_ratio(bbox, page_width, page_height)
        dense_small_box = density_ratio >= 0.9 and 0 < page_box_area_ratio <= SMALL_PAGE_BOX_RATIO
        heavy_dense_small_box = density_ratio >= HEAVY_COMPACT_RATIO and 0 < page_box_area_ratio <= ULTRA_SMALL_PAGE_BOX_RATIO
        block_height = bbox_height(item)
        block_width = bbox_width(item)
        body_like_single_line = bool(body_flags.get(index, False))
        wide_aspect_body_text = bool(
            body_flags.get(index, False)
            and block_height > 0
            and (block_width / block_height) >= WIDE_ASPECT_BODY_RATIO
        )

        if body_flags.get(index) and page_body_font_size_pt is not None:
            down_band = 0.34 if heavy_dense_small_box else (0.2 if dense_small_box else 0.06)
            up_band = 0.18 if dense_small_box else 0.24
            font_size_pt = round(min(max(font_size_pt, page_body_font_size_pt - down_band), page_body_font_size_pt + up_band), 2)
            if wide_aspect_body_text:
                font_size_pt = round(min(page_body_font_size_pt + up_band, font_size_pt + WIDE_ASPECT_BODY_FONT_BOOST_PT), 2)

        item_inner_bbox = inner_bbox(item)

        if dense_small_box and not body_flags.get(index):
            font_size_pt = round(font_size_pt * COMPACT_SCALE, 2)
            leading_em = round(leading_em * COMPACT_SCALE, 2)

        font_size_pt, leading_em = fit_translated_block_metrics(
            {
                **item,
                "_render_inner_bbox": item_inner_bbox,
                "_is_body_text_candidate": body_like_single_line,
                "_page_box_area_ratio": page_box_area_ratio,
                "_dense_small_box": dense_small_box,
                "_heavy_dense_small_box": heavy_dense_small_box,
                "_wide_aspect_body_text": wide_aspect_body_text,
            },
            translated_text,
            formula_map,
            font_size_pt,
            leading_em,
            page_body_font_size_pt=page_body_font_size_pt if body_like_single_line else None,
        )

        if body_like_single_line:
            leading_em = normalize_leading_em_for_font_size(
                font_size_pt,
                leading_em,
                reference_font_size_pt=page_body_font_size_pt or page_font_size,
                min_leading_em=BODY_LEADING_MIN,
                max_leading_em=BODY_LEADING_MAX,
                strength=BODY_LEADING_SIZE_ADJUST,
                floor_min_leading_em=BODY_LEADING_FLOOR_MIN,
            )
        else:
            leading_em = normalize_leading_em_for_font_size(
                font_size_pt,
                leading_em,
                reference_font_size_pt=page_font_size,
                min_leading_em=NON_BODY_LEADING_MIN,
                max_leading_em=NON_BODY_LEADING_MAX,
                strength=NON_BODY_LEADING_SIZE_ADJUST,
                floor_min_leading_em=NON_BODY_LEADING_FLOOR_MIN,
            )

        if wide_aspect_body_text:
            leading_em = _relax_wide_aspect_body_leading(
                item_inner_bbox,
                translated_text,
                formula_map,
                font_size_pt,
                leading_em,
            )
        is_table_block = str(item_block_kind(item)).strip().lower() == "table"
        item_cover_bbox = resolve_cover_bbox(item)
        block_payloads.append(
            {
                "index": index,
                "item": item,
                "bbox": bbox,
                "cover_bbox": item_cover_bbox,
                "inner_bbox": list(bbox) if use_raw_text_bbox else item_inner_bbox,
                "translated_text": translated_text,
                "formula_map": formula_map,
                # P3: table blocks always use markdown render kind (not plain_line)
                # so that pdftr_fit_markdown engine can be activated via fit_to_box.
                "render_kind": "markdown" if is_table_block else (
                    "plain_line" if item.get("_force_plain_line") or is_flag_like_plain_text_block(item)
                    else "markdown"
                ),
                "font_size_pt": font_size_pt,
                "leading_em": leading_em,
                "font_weight": resolve_font_weight(item),
                "page_body_font_size_pt": page_body_font_size_pt if body_like_single_line else None,
                "is_body": body_like_single_line,
                "page_box_area_ratio": page_box_area_ratio,
                "dense_small_box": dense_small_box,
                "heavy_dense_small_box": heavy_dense_small_box,
                "wide_aspect_body_text": wide_aspect_body_text,
                # P3: table blocks and cells must always activate Typst binary fit (font auto-sizing).
                "prefer_typst_fit": True if (is_table_block or item.get("translate_reason") == "table_cell" or item.get("provenance", {}).get("raw_label") == "table_cell") else bool(body_flags.get(index, False) and dense_small_box),
                "adjacent_collision_risk": False,
                "adjacent_available_height_pt": None,
                "text_color": item.get("_render_text_color", (0, 0, 0)),
                "cover_fill": item.get("_render_cover_fill", (1, 1, 1)),
                # P3: mark table blocks for outer-border redraw in page_ops.
                "_is_table_block": is_table_block,
            }
        )

    # Bug-3: footer overlap adjustment with clamp protection and font compression
    if page_height and page_height > 0:
        footer_payloads = []
        body_payloads_list = []
        for p in block_payloads:
            item = p.get("item", {})
            is_footer = (
                item.get("layout_role") == "footer"
                or item.get("block_type") == "footer"
                or item.get("provenance", {}).get("raw_label") == "page_footer"
                or (p.get("bbox") and p["bbox"][1] > 0.9 * page_height)
            )
            if is_footer:
                footer_payloads.append(p)
            else:
                body_payloads_list.append(p)
                
        if body_payloads_list:
            # 在 y 轴向下坐标系中，body_bottom_y 是最大的 y 值
            body_bottom_y = max(p["bbox"][3] for p in body_payloads_list if p.get("bbox") and len(p["bbox"]) == 4)
            
            # 确定页脚的顶线
            if footer_payloads:
                # 真实页脚的顶线是其顶边的最小值(min(bbox[1]))
                footer_top_y = min(p["bbox"][1] for p in footer_payloads if p.get("bbox") and len(p["bbox"]) == 4)
            else:
                # 若无真实页脚块，使用虚拟页脚顶线 (距底85pt，契合地脚大留白规范)
                footer_top_y = page_height - 85.0
                
            overlap = body_bottom_y - footer_top_y
            
            if overlap > 0:
                has_shifted = False
                # 仅在有真实页脚且空间足够时尝试下移页脚
                if footer_payloads:
                    max_footer_bottom = max(p["bbox"][3] for p in footer_payloads if p.get("bbox") and len(p["bbox"]) == 4)
                    max_footer_shift = page_height - max_footer_bottom - 12.0  # 距底留12pt
                    if overlap <= max_footer_shift:
                        for f_p in footer_payloads:
                            for key in ["bbox", "inner_bbox", "cover_bbox"]:
                                if key in f_p and len(f_p[key]) == 4:
                                    f_p[key][1] += overlap
                                    f_p[key][3] += overlap
                        footer_top_y += overlap
                        has_shifted = True
                
                # 如果没有成功下移（因为空间不足或没有真实页脚块），则执行正文压缩
                if not has_shifted:
                    scale1 = 0.90  # 第一档压缩
                    for p in body_payloads_list:
                        p["font_size_pt"] = round(p["font_size_pt"] * scale1, 2)
                        p["leading_em"] = round(p["leading_em"] * scale1, 2)
                        if "bbox" in p and len(p["bbox"]) == 4:
                            p["bbox"][3] = p["bbox"][1] + (p["bbox"][3] - p["bbox"][1]) * scale1
                        if "inner_bbox" in p and len(p["inner_bbox"]) == 4:
                            p["inner_bbox"][3] = p["inner_bbox"][1] + (p["inner_bbox"][3] - p["inner_bbox"][1]) * scale1
                        if "cover_bbox" in p and len(p["cover_bbox"]) == 4:
                            p["cover_bbox"][3] = p["cover_bbox"][1] + (p["cover_bbox"][3] - p["cover_bbox"][1]) * scale1
                            
                    # 再次检查，仍不足则进行二档压缩
                    body_bottom_y_new = max(p["bbox"][3] for p in body_payloads_list if p.get("bbox") and len(p["bbox"]) == 4)
                    if body_bottom_y_new > footer_top_y:
                        scale2 = 0.85  # 第二档压缩
                        for p in body_payloads_list:
                            p["font_size_pt"] = round(p["font_size_pt"] * scale2, 2)
                            p["leading_em"] = round(p["leading_em"] * scale2, 2)
                            if "bbox" in p and len(p["bbox"]) == 4:
                                p["bbox"][3] = p["bbox"][1] + (p["bbox"][3] - p["bbox"][1]) * scale2
                            if "inner_bbox" in p and len(p["inner_bbox"]) == 4:
                                p["inner_bbox"][3] = p["inner_bbox"][1] + (p["inner_bbox"][3] - p["inner_bbox"][1]) * scale2
                            if "cover_bbox" in p and len(p["cover_bbox"]) == 4:
                                p["cover_bbox"][3] = p["cover_bbox"][1] + (p["cover_bbox"][3] - p["cover_bbox"][1]) * scale2

    return block_payloads, page_text_width_med

