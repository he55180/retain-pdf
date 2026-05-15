# RetainPDF

**PDF 智能翻译工具 · 专为海外工程现场设计**  
**Intelligent PDF Translation · Built for Overseas Engineering Teams**

> 基于 [wxyhgk/retain-pdf](https://github.com/wxyhgk/retain-pdf) 二次开发  
> Forked from [wxyhgk/retain-pdf](https://github.com/wxyhgk/retain-pdf) with significant enhancements

---

## 相比原版的核心改进 / Key Improvements over Original

| 项目 | 原版 | 本版 v5.2.2 |
|------|------|------------|
| OCR 引擎 | PaddleOCR（强制绑定） | MinerU + PaddleOCR 双引擎自由切换 |
| 海外网络 | 中国大陆以外完全无法使用 | MinerU 模式全球可用，无需 VPN |
| 白底遮盖 | 硬编码关闭，英文原文透底 | 已修复，动态 outset 精确遮盖 |
| 信头/页脚 | 全部送翻译，版面混乱 | 智能区域过滤，仅翻译正文 |
| 翻译方向 | 单向（英译中） | 四方向：英↔中、英→斯瓦希里语、斯瓦希里语→中文 |
| 安装包体积 | 臃肿 | Windows 231MB / macOS 283MB |
| 适用场景 | 中国大陆 VPN 环境 | 全球可用，尤其适合东非工程现场 |

---

## 下载安装 / Download & Install

前往 [Releases 页面](https://github.com/he55180/retain-pdf/releases) 下载最新版本 v5.2.2：

```
Windows:  RetainPDF-Windows-5.2.2-Setup.exe   (231 MB)
macOS:    RetainPDF-Mac-5.2.2.dmg             (283 MB)
```

双击安装，按提示完成即可。无需安装 Python、Node.js 等任何依赖。

---

## 快速开始 / Quick Start

### 第一步：配置 API 凭证

安装后首次启动，进入 **设置 → API Settings**，填入以下凭证：

| 凭证 | 获取方式 | 必填 |
|------|---------|------|
| MinerU Token | 登录 [mineru.net](https://mineru.net) → API 管理 → 创建 Token | MinerU 模式必填 |
| DeepSeek API Key | 登录 [platform.deepseek.com](https://platform.deepseek.com) → API Keys | 必填 |
| PaddleOCR Token | 登录 [aistudio.baidu.com](https://aistudio.baidu.com) → 访问令牌 | PaddleOCR 模式必填 |

### 第二步：选择翻译方向

进入 **设置 → Task Options**，选择翻译方向：

- `EN → 中文 (Chinese)` — 英文文档翻译为中文（**默认，最常用**）
- `中文 → EN (English)` — 中文文档翻译为英文
- `EN → Kiswahili` — 英文翻译为斯瓦希里语
- `Kiswahili → 中文 (Chinese)` — 斯瓦希里语翻译为中文

### 第三步：翻译 PDF

1. 点击上传区，选择 PDF 文件（最大 100MB，建议单次不超过 10 页）
2. 点击 **全书翻译** 或 **分页翻译**
3. 等待完成，下载输出文件

---

## OCR 引擎选择策略 / OCR Engine Strategy

| 场景 | 推荐引擎 | 说明 |
|------|---------|------|
| 日常英文合同、技术报告 | **MinerU（默认）** | 开箱即用，速度快 |
| 高质量版面还原、中文文档 | **PaddleOCR** | 版面还原更佳，普通 PDF 直连可用 |
| 复杂扫描件 / 表格嵌入文件 | 两个引擎均有局限 | 建议分页上传或人工辅助处理 |

**切换方法：** 设置 → Task Options → OCR Engine

---

## 推荐翻译提示词 / Recommended Translation Prompts

### 工程合同（英译中）

```
你是专业的工程合同翻译专家，请将以下英文内容翻译成简体中文。
要求：
1. 以下术语固定翻译，不得意译：
   - Contractor → 承包方
   - Employer → 业主方
   - Force Majeure → 不可抗力
   - Environmental Impact Assessment → 环境影响评估（EIA）
   - Environmental Management Plan → 环境管理计划（EMP）
   - Tanzania Shillings (TZS) → 坦桑尼亚先令
2. 保留原文中的合同编号、人名、地名不翻译
3. 保留原文排版结构，包括编号、缩进
4. 法律条款翻译力求准确，不得随意简化
```

### 工程文件（中译英）

```
You are a professional engineering document translator.
Translate the following Chinese content into formal English.
Requirements:
1. Use standard engineering and contractual terminology
2. Preserve all document numbers, names, and locations
3. Maintain the original formatting structure including numbering and indentation
4. Ensure accuracy for technical and legal terms
```

---

## 已知限制 / Known Limitations

- **表格翻译**：PDF 内嵌复杂表格的翻译效果有限，表格结构可能无法完整还原，计划在后续版本优化
- **多页大文件**：建议单次翻译不超过 10 页；超大文件建议分批上传
- **证件类扫描件**：彩色背景、手写内容混排的证件（如许可证、资质证书）OCR 识别率较低，不建议使用本工具处理
- **MinerU 速度**：非洲网络环境下每页约需 30～60 秒，请耐心等待
- **MinerU Token 有效期**：90 天，到期后需登录 mineru.net 重新创建

---

## 技术架构 / Technical Stack

```
RetainPDF v5.2.2
├── Electron Shell          # 跨平台桌面应用
├── Rust API (Axum)         # 后端任务编排
├── Python Pipeline         # OCR / 翻译 / 渲染
│   ├── MinerU              # 云端 OCR（默认）
│   ├── PaddleOCR           # 百度云端 OCR（高质量模式）
│   ├── DeepSeek            # LLM 翻译引擎
│   └── Typst               # PDF 排版渲染
└── Vanilla JS + Tailwind   # 前端界面
```

---

## 版本历史 / Changelog

| 版本 | 主要改动 |
|------|---------|
| v5.2.2 | 修复中译英方向首页正文被误过滤问题 |
| v5.2.1 | 修复英译中第二页正文被误过滤；补全 macOS 构建；优化上传区 UI |
| v5.2.0 | 信头/页脚区域智能跳过翻译；签名区白底加厚；并发优化 |
| v5.1.2 | Cover rect 白底遮盖修复；outset 1.5pt 精确遮盖 |
| v5.1.0 | 回退至双云端引擎架构（PaddleOCR + MinerU），安装包瘦身至 231MB |
| v4.3.x | 集成 Docling 离线引擎（后因体积/性能问题回退） |
| v4.1.3 | 首个发布版：MinerU 双引擎支持，绕过百度强制验证 |

---

## 开源协议 / License

本项目基于原项目 MIT 协议进行二次开发，同样遵循 [MIT License](LICENSE)。  
This project is a fork of [wxyhgk/retain-pdf](https://github.com/wxyhgk/retain-pdf), released under the MIT License.
