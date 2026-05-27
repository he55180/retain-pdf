#set text(font: "Source Han Sans HW", size: 11.4pt)
#import "@preview/cmarker:0.1.8"
#import "@preview/mitex:0.2.6": mitex
#show math.equation.where(block: false): set math.frac(style: "horizontal")
#let pdftr_fit_size(lo, hi, eps, fits) = {
  if hi - lo <= eps {
    lo
  } else {
    let mid = lo + (hi - lo) / 2
    if fits(mid) {
      pdftr_fit_size(mid, hi, eps, fits)
    } else {
      pdftr_fit_size(lo, mid, eps, fits)
    }
  }
}
#let pdftr_fit_single_line_markdown(markdown, max_size: 10pt, min_size: 9pt, fit_width: none, fit_height: none, weight: "regular", eps: 0.08pt) = {
  layout(size => {
    let allowed-width = if fit_width == none { size.width } else { calc.min(size.width, fit_width) }
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size) = box(inset: 0pt, clip: false)[#{
      set text(size: text_size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size) = {
      let measured = measure(render(text_size))
      measured.width <= allowed-width and measured.height <= allowed-height
    }
    let chosen-size = if fits(max_size) {
      max_size
    } else {
      pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt))
    }
    box(width: allowed-width, height: allowed-height, inset: 0pt, clip: false)[#{
      set text(size: chosen-size, weight: weight)
      set par(leading: 1em)
      cmarker.render(markdown, math: mitex)
    }]
  })
}
#let pdftr_fit_markdown(markdown, max_size: 10pt, min_size: 9pt, max_leading: 0.66em, min_leading: 0.54em, fit_height: none, eps: 0.08pt) = {
  layout(size => {
    let allowed-height = if fit_height == none { size.height } else { calc.min(size.height, fit_height) }
    let render(text_size, leading) = block(width: size.width)[#{
      set text(size: text_size)
      set par(leading: leading)
      cmarker.render(markdown, math: mitex)
    }]
    let fits(text_size, leading) = measure(width: size.width, render(text_size, leading)).height <= allowed-height
    if fits(max_size, max_leading) {
      render(max_size, max_leading)
    } else {
      let chosen-size = pdftr_fit_size(min_size, max_size, eps, size_pt => fits(size_pt, min_leading))
      render(chosen-size, min_leading)
    }
  })
}
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 1, width: 595.3200073242188pt))
#let rp0_item_p001_b001_0_md = "合同号：TZ-TPA-/424013-CW-DIR"
#let rp0_item_p001_b001_0_body = block(width: 194.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b001_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 203.0pt, dy: 100.0pt, rp0_item_p001_b001_0_body)
}
#let rp0_item_p001_b002_1_md = "修复达累斯萨拉姆港滚装码头及1-7号泊位混凝土损伤工程"
#let rp0_item_p001_b002_1_body = block(width: 455.0pt, height: 12.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b002_1_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 12.0pt) }]
#context {
  place(top + left, dx: 72.0pt, dy: 112.0pt, rp0_item_p001_b002_1_body)
}
#let rp0_item_p001_b004_2_md = "参考文献："
#let rp0_item_p001_b004_2_body = block(width: 59.0pt, height: 11.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b004_2_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 11.0pt) }]
#context {
  place(top + left, dx: 60.0pt, dy: 174.0pt, rp0_item_p001_b004_2_body)
}
#let rp0_item_p001_b012_3_md = "1. 会议开始"
#let rp0_item_p001_b012_3_body = block(width: 123.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b012_3_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.0pt, dy: 415.0pt, rp0_item_p001_b012_3_body)
}
#let rp0_item_p001_b013_4_md = "2. 承包商开工准备情况"
#let rp0_item_p001_b013_4_body = block(width: 226.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b013_4_md, max_size: 13.72pt, min_size: 11.52pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.0pt, dy: 446.176pt, rp0_item_p001_b013_4_body)
}
#let rp0_item_p001_b014_5_md = "3. 合同事宜"
#let rp0_item_p001_b014_5_body = block(width: 112.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b014_5_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 76.0pt, dy: 461.176pt, rp0_item_p001_b014_5_body)
}
#let rp0_item_p001_b015_6_md = "1. 施工方案"
#let rp0_item_p001_b015_6_body = block(width: 170.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b015_6_md, max_size: 13.72pt, min_size: 11.52pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 101.0pt, dy: 473.176pt, rp0_item_p001_b015_6_body)
}
#let rp0_item_p001_b016_7_md = "2. 劳工、材料与设备"
#let rp0_item_p001_b016_7_body = block(width: 205.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b016_7_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 486.176pt, rp0_item_p001_b016_7_body)
}
#let rp0_item_p001_b017_8_md = "3. 项目经理设施"
#let rp0_item_p001_b017_8_body = block(width: 83.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b017_8_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 517.352pt, rp0_item_p001_b017_8_body)
}
#let rp0_item_p001_b018_9_md = "4. 日报、周报与月报"
#let rp0_item_p001_b018_9_body = block(width: 186.0pt, height: 12.999999999999886pt)[#{ pdftr_fit_markdown(rp0_item_p001_b018_9_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.999999999999886pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 529.352pt, rp0_item_p001_b018_9_body)
}
#let rp0_item_p001_b021_10_md = "1. 新缺陷"
#let rp0_item_p001_b021_10_body = block(width: 82.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b021_10_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 101.0pt, dy: 554.3519999999999pt, rp0_item_p001_b021_10_body)
}
#let rp0_item_p001_b022_11_md = "2. 弃土区"
#let rp0_item_p001_b022_11_body = block(width: 91.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b022_11_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 567.3519999999999pt, rp0_item_p001_b022_11_body)
}
#let rp0_item_p001_b023_12_md = "3. 急救设施"
#let rp0_item_p001_b023_12_body = block(width: 107.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b023_12_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 598.5279999999999pt, rp0_item_p001_b023_12_body)
}
#let rp0_item_p001_b024_13_md = "4. 维修与办公空间"
#let rp0_item_p001_b024_13_body = block(width: 171.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b024_13_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 610.5279999999999pt, rp0_item_p001_b024_13_body)
}
#let rp0_item_p001_b025_14_md = "5. 预制构件与存储区"
#let rp0_item_p001_b025_14_body = block(width: 212.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b025_14_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 623.5279999999999pt, rp0_item_p001_b025_14_body)
}
#let rp0_item_p001_b026_15_md = "6. 集装箱堆场照明"
#let rp0_item_p001_b026_15_body = block(width: 215.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b026_15_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 653.704pt, rp0_item_p001_b026_15_body)
}
#let rp0_item_p001_b027_16_md = "7. 承包商开票"
#let rp0_item_p001_b027_16_body = block(width: 126.0pt, height: 12.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b027_16_md, max_size: 14.2pt, min_size: 12.0pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 12.0pt) }]
#context {
  place(top + left, dx: 100.0pt, dy: 667.704pt, rp0_item_p001_b027_16_body)
}
#let rp0_item_p001_b030_17_md = "驻地工程师——RE（IL - Eng. José Rodrigues）宣布会议开始，并对与会成员表示欢迎。会议由驻地工程师代表工程师主持。"
#let rp0_item_p001_b030_17_body = block(width: 459.0pt, height: 26.0pt)[#{ pdftr_fit_markdown(rp0_item_p001_b030_17_md, max_size: 11.7pt, min_size: 10.9pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 26.0pt) }]
#context {
  place(top + left, dx: 80.0pt, dy: 734.704pt, rp0_item_p001_b030_17_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 2, width: 595.3200073242188pt))
#let rp1_item_p002_b001_0_md = "合同号：TZ-TPA-/424013-CW-DIR"
#let rp1_item_p002_b001_0_body = block(width: 193.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp1_item_p002_b001_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 204.0pt, dy: 100.0pt, rp1_item_p002_b001_0_body)
}
#let rp1_item_p002_b002_1_md = "修复达累斯萨拉姆港滚装码头及1-7号泊位混凝土损伤工程"
#let rp1_item_p002_b002_1_body = block(width: 454.0pt, height: 12.0pt)[#{ pdftr_fit_markdown(rp1_item_p002_b002_1_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 12.0pt) }]
#context {
  place(top + left, dx: 73.0pt, dy: 112.0pt, rp1_item_p002_b002_1_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 3, width: 595.3200073242188pt))
#let rp2_item_p003_b001_0_md = "合同号：TZ-TPA-/424013-CW-DIR"
#let rp2_item_p003_b001_0_body = block(width: 193.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp2_item_p003_b001_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 204.0pt, dy: 100.0pt, rp2_item_p003_b001_0_body)
}
#let rp2_item_p003_b002_1_md = "修复达累斯萨拉姆港滚装码头及1-7号泊位混凝土损伤工程"
#let rp2_item_p003_b002_1_body = block(width: 454.0pt, height: 12.0pt)[#{ pdftr_fit_markdown(rp2_item_p003_b002_1_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 12.0pt) }]
#context {
  place(top + left, dx: 73.0pt, dy: 112.0pt, rp2_item_p003_b002_1_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 4, width: 595.3200073242188pt))
#let rp3_item_p004_b001_0_md = "合同号：TZ-TPA-/424013-CW-DIR"
#let rp3_item_p004_b001_0_body = block(width: 193.0pt, height: 8.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b001_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 8.0pt) }]
#context {
  place(top + left, dx: 204.0pt, dy: 100.0pt, rp3_item_p004_b001_0_body)
}
#let rp3_item_p004_b002_1_md = "修复达累斯萨拉姆港滚装码头及1-7号泊位混凝土损伤工程"
#let rp3_item_p004_b002_1_body = block(width: 454.0pt, height: 12.0pt)[#{ pdftr_fit_markdown(rp3_item_p004_b002_1_md, max_size: 11.73pt, min_size: 10.93pt, max_leading: 0.59em, min_leading: 0.51em, fit_height: 12.0pt) }]
#context {
  place(top + left, dx: 73.0pt, dy: 112.0pt, rp3_item_p004_b002_1_body)
}
#pagebreak()
#set page(width: 595.3200073242188pt, height: 841.9200439453125pt, margin: 0pt, fill: none)
#place(top + left, dx: 0pt, dy: 0pt, image("book-background-cleaned.pdf", page: 5, width: 595.3200073242188pt))
#let rp4_item_p005_b001_0_md = "合同号：TZ-TPA-/424013-CW-DIR"
#let rp4_item_p005_b001_0_body = block(width: 192.0pt, height: 11.0pt)[#{ pdftr_fit_markdown(rp4_item_p005_b001_0_md, max_size: 12.74pt, min_size: 10.54pt, max_leading: 0.28em, min_leading: 0.18em, fit_height: 11.0pt) }]
#context {
  place(top + left, dx: 204.0pt, dy: 100.0pt, rp4_item_p005_b001_0_body)
}
