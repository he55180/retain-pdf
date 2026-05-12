# RetainPDF · CHEC 东非坦桑尼亚水工项目群定制版

> 基于 [wxyhgk/retain-pdf](https://github.com/wxyhgk/retain-pdf) 二次开发  
> 中国港湾工程有限责任公司 · 东非坦桑尼亚水工项目群

---

## 📌 关于本版本

本版本为 CHEC 东非坦桑尼亚水工项目群内部定制版，针对非洲现场网络环境进行了专项优化：

- ✅ **默认使用 MinerU OCR**，完全绕过百度 PaddleOCR 强制验证
- ✅ **无需百度账号**，非洲网络环境稳定可用
- ✅ **DeepSeek 翻译**，费用极低，翻译质量高
- ✅ **格式还原输出**，保留原文排版结构
- ✅ **一键安装**，同事直接下载 `.exe` 双击安装即可使用

---

## 🚀 快速开始（同事使用指南）

### 第一步：下载安装包

前往 [Releases 页面](https://github.com/he55180/retain-pdf/releases) 下载最新版本：

```
RetainPDF-Windows-vX.X.X-Setup.exe
```

双击安装，按提示完成即可。

### 第二步：首次配置

安装后首次启动会弹出配置界面，填入以下凭证：

| 凭证 | 获取方式 |
|---|---|
| **MinerU Token** | 登录 [mineru.net](https://mineru.net) → API 管理 → 创建 Token |
| **DeepSeek API Key** | 登录 [platform.deepseek.com](https://platform.deepseek.com) → API Keys |

填写完成后点击 **保存并启动**。

### 第三步：翻译 PDF

1. 点击上传 PDF 文件（支持扫描件）
2. 选择目标语言（中文）
3. 等待翻译完成，下载输出文件

---

## 💡 设计思路

原版存在一个已知 Bug：即使选择了 MinerU 作为 OCR 服务商，界面仍强制要求填写 PaddleOCR Token 才能保存配置。这导致在非洲项目现场（无法稳定访问百度国内服务器）完全无法正常使用。

本版本的改动思路：

- **默认使用 MinerU**，非洲网络环境开箱即用
- **保留 PaddleOCR 作为备选**，可在设置中随时切换
- **取消强制验证**，选 MinerU 时直接跳过 Token 检查，选 PaddleOCR 时才验证
- 回国或百度可访问时，切换回 PaddleOCR 可获得更好的中文版面还原效果

**两全其美：非洲现场能用 + 国内效果更好。**

---

## 🔧 与原版的主要改动

| 文件 | 改动内容 |
|---|---|
| `desktop/main.js` | 默认 OCR 服务商从 `paddle` 改为 `mineru` |
| `desktop/scripts/prepare-app.mjs` | 构建注入默认值改为 `mineru` |
| `frontend/.../credentials/browser.js` | MinerU 模式跳过 OCR Token 强制验证 |

---

## 📋 推荐翻译提示词（工程合同专用）

在软件翻译设置中使用以下提示词，锁定 CHEC 项目专业术语：

```
你是专业的工程合同翻译专家，请将以下英文内容翻译成简体中文。
要求：
1. 以下术语固定翻译，不得意译：
   - Environmental Impact Assessment → 环境影响评估（EIA）
   - Environmental Management Plan → 环境管理计划（EMP）
   - Contractor → 承包方
   - Employer → 业主方
   - Force Majeure → 不可抗力
   - Tanzania Shillings (TZS) → 坦桑尼亚先令
2. 保留原文中的合同编号、人名、地名不翻译
3. 保留原文排版结构，包括编号、缩进
4. 法律条款翻译力求准确，不得随意简化
```

---

## 📊 使用策略建议

根据实际测试，建议按文件类型选择 OCR 服务商：

| 文件类型 | 推荐 OCR | 是否需要 VPN | 说明 |
|---|---|---|---|
| 日常英文合同、技术报告 | **MinerU** | ❌ 不需要 | 开箱即用，速度快，英文效果好 |
| 复杂扫描件、证件、许可证 | **PaddleOCR** | ✅ 需要香港节点 | 版面还原更强，支持斯瓦希里语识别 |
| EIA 报告、多栏排版文件 | **PaddleOCR** | ✅ 需要香港节点 | 中文排版还原效果更佳 |

**切换方法：**
1. 开启 VPN，连接香港节点
2. 打开软件设置 → OCR 服务商 → 切换为 **PaddleOCR**
3. 填入百度 AI Studio Token（[aistudio.baidu.com](https://aistudio.baidu.com) 注册获取）
4. 翻译完成后可关闭 VPN

---

## ⚠️ 注意事项

- MinerU Token 有效期 **90 天**，到期后需登录 mineru.net 重新创建
- 非洲网络环境下每页 OCR 约需 **30～60 秒**，请耐心等待
- 本软件仅供 CHEC 内部使用，请勿对外分发

---

## 📄 开源协议

本项目基于原项目 MIT 协议进行二次开发，同样遵循 MIT 开源协议。  
原项目地址：[wxyhgk/retain-pdf](https://github.com/wxyhgk/retain-pdf)
