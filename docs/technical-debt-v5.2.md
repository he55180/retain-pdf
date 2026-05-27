# 5.2 第二主线：后端契约技术债记录

本文档记录 API 文档与真实返回之间的不一致问题，留待 v6.0 统一处理。不做代码修改，仅记录。

来源：工程评价与后续执行计划 5.2 节「后端契约继续做硬」。

---

## 5.2.1 API 文档与真实返回不一致

对照文件：
- 文档：`doc/core/api/API_SPEC.md`（即 `backend/rust_api/API_SPEC.md`）
- 实际返回：`backend/rust_api/src/models/view/job_types.rs`、`job_builders.rs`、`common.rs`
- 前端消费：`frontend/src/js/job.js`、`status-detail-presentation.js`

### 1. `actions.rerun` 未在 API_SPEC 记录

Rust `JobActionsView`（`models/view/common.rs:55-64`）包含 `rerun` 动作，前端 `resolveJobActions()`（`job.js:175`）已消费，但 API_SPEC 第二节（Create Job）、第三节（Job Detail）、第五节（Artifacts）示例 JSON 均未展示 `rerun`。

```rust
// models/view/common.rs
pub struct JobActionsView {
    pub open_job: ActionLinkView,
    pub open_artifacts: ActionLinkView,
    pub cancel: ActionLinkView,
    pub rerun: ActionLinkView,       // ← 文档缺失
    pub download_pdf: ActionLinkView,
    pub open_markdown: ActionLinkView,
    pub open_markdown_raw: ActionLinkView,
    pub download_bundle: ActionLinkView,
}
```

### 2. `JobDetailView` 未记录字段

API_SPEC 第三节 Job Detail 示例 JSON 缺少以下 Rust 实际返回字段：

| 字段 | Rust 位置 | 文档状态 |
|------|----------|---------|
| `request_payload` | `job_types.rs:88` | endpoints.md 提到脱敏但 API_SPEC 未展示结构 |
| `trace_id` | `job_types.rs:89` | 未记录 |
| `provider_trace_id` | `job_types.rs:90` | 未记录 |
| `ocr_provider_diagnostics` | `job_types.rs:99` | 未记录 |
| `error` | `job_types.rs:102` | 未记录 |

### 3. `runtime` 结构未正式文档化

`doc/core/api/overview.md` 提及 `runtime.current_stage` / `runtime.stage_history`，但 `endpoints.md` 和 `API_SPEC.md` 均未给出 `JobRuntimeInfo` 的完整字段列表。

Rust 实际返回（`models/job/runtime.rs:16-29`）：

```rust
pub struct JobRuntimeInfo {
    pub current_stage: Option<String>,
    pub stage_started_at: Option<String>,
    pub last_stage_transition_at: Option<String>,
    pub terminal_reason: Option<String>,
    pub last_error_at: Option<String>,
    pub total_elapsed_ms: Option<i64>,
    pub active_stage_elapsed_ms: Option<i64>,
    pub retry_count: u32,
    pub last_retry_at: Option<String>,
    pub stage_history: Vec<JobStageTiming>,
    pub final_failure_category: Option<String>,
    pub final_failure_summary: Option<String>,
}
```

前端 `normalizeJobPayload()`（`job.js:58-128`）消费所有这些字段，但因文档缺失使用了大量防御性回退。

### 4. `JobStageTiming`（stage_history 条目）未记录

API_SPEC 未记录 `stage_history[]` 条目结构：

```rust
// models/job/runtime.rs
pub struct JobStageTiming {
    pub stage: String,
    pub detail: Option<String>,
    pub enter_at: String,
    pub exit_at: Option<String>,
    pub duration_ms: Option<i64>,
    pub terminal_status: Option<JobStatusKind>,
}
```

前端 `status-detail-presentation.js:268-286` 消费并渲染此结构，依赖 `enter_at`/`exit_at`/`duration_ms`/`terminal_status` 字段。

### 5. 前端累积兼容代码

`frontend/src/js/job.js` 的 `normalizeJobPayload()` 和 `resolveJobActions()` 存在大量多名称回退模式，说明字段名历史上经历过多次变化：

```javascript
// 多字段名变体回退
progress_current: numberOrNull(progress.current ?? unwrapped.progress_current)
stage_started_at: firstNonEmpty(runtime.stage_started_at)
pdf_ready: Boolean(artifacts.pdf_ready ?? artifacts.pdf?.ready)

// actions 从 artifacts.actions 回退
rerunEnabled: Boolean(actions.rerun?.enabled ?? artifactActions.rerun?.enabled)
```

这些兼容代码应在字段名统一收敛后清理。

### 6. `failure` 结构有未记录扩展字段

API_SPEC 记录了 `failure` 形式化字段，但 Rust `JobFailureInfo`（`models/job/failure.rs`）额外包含：

- `raw_diagnostic: JobRawDiagnostic` — 结构化异常诊断（exception_type, exception_message, traceback）
- `ai_diagnostic: JobAiDiagnostic` — AI 诊断结果（summary, root_cause, suggestion, confidence, observed_signals）

这些字段返回给前端但未在文档中体现。

### 7. `JobListItemView` 有未记录字段

Rust `JobListItemView`（`job_types.rs:174-186`）包含 `display_name` 字段，API_SPEC 第四节列表项示例未展示此字段。

---

## 5.2.2 其他待硬化项（简要列举）

以下来自 5.2 节剩余子目标，此处仅记录方向：

- **stage_history 稳定性**：当前 `stage_history` 由 Python worker 通过 `pipeline_events.jsonl` 写入，字段演进缺乏版本号标记
- **events 稳定性**：`event` 字段为兼容别名，新客户端应使用 `event_type`；迁移完成后可考虑废弃 `event`
- **artifacts 稳定性**：`ArtifactLinksView` 同时包含 `actions`（与顶层重复），可考虑去重
- **下载能力登记**：当前 artifact 资源路径通过 `artifact_resource_path()` 硬编码映射（`job_builders.rs:256-271`），尚未完全走数据库登记

---

## 处理计划

以上问题统一归入 v6.0 处理，当前 v5.x 不做修改。

优先级排序：
1. API_SPEC 文档与 Rust 代码对齐（5.2.1 第 1-7 项）
2. 前端兼容代码清理（5.2.1 第 5 项）
3. runtime/stage_history JSON Schema 化（5.2.2）
4. artifact 路径数据库登记（5.2.2）
