export const DEFAULT_OCR_PROVIDER = "mineru";

export const OCR_PROVIDER_DEFINITIONS = [
  {
    id: "mineru",
    label: "MinerU 云端",
    description: "需网络，复杂扫描件正式翻译。",
    tokenField: "mineru_token",
    runtimeConfigKey: "mineruToken",
    tokenLabel: "MinerU Token",
    tokenPlaceholder: "MinerU Token",
    validationButtonLabel: "检测 MinerU",
    validationIdleMessage: "未检测",
    validationMissingMessage: "请先填写 MinerU Token。",
    validationUnavailableMessage: "",
    docsUrl: "https://mineru.net/apiManage/docs?openApplyModal=true",
    docsLabel: "获取 Token",
    supportsValidation: true,
  },
  {
    id: "paddle",
    label: "PaddleOCR",
    description: "需香港节点，中文版面最佳。",
    tokenField: "paddle_token",
    runtimeConfigKey: "paddleToken",
    tokenLabel: "Paddle Access Token",
    tokenPlaceholder: "Paddle Access Token",
    validationButtonLabel: "检测 Paddle",
    validationIdleMessage: "未检测",
    validationMissingMessage: "请先填写 Paddle Access Token。",
    validationUnavailableMessage: "",
    docsUrl: "https://aistudio.baidu.com/account/accessToken",
    docsLabel: "获取 Token",
    supportsValidation: true,
  },
];

export const TRANSLATION_PROVIDER_DEFINITION = {
  id: "deepseek",
  label: "DeepSeek",
  keyLabel: "DeepSeek Key",
  keyPlaceholder: "DeepSeek API Key",
  description: "翻译模型。",
  docsUrl: "https://platform.deepseek.com/api_keys",
  docsLabel: "获取 Key",
  validationButtonLabel: "检测 DeepSeek",
  validationIdleMessage: "未检测",
  validationMissingMessage: "请先填写 DeepSeek Key。",
  validationSuccessMessage: "DeepSeek 接口连接成功。",
  validationNetworkMessage: "DeepSeek 接口检测失败，请检查网络或浏览器跨域限制。",
  validationUnauthorizedMessage: "DeepSeek Key 无效或已过期。",
};

export function normalizeOcrProvider(value) {
  const provider = `${value || ""}`.trim().toLowerCase();
  return OCR_PROVIDER_DEFINITIONS.some((item) => item.id === provider) ? provider : DEFAULT_OCR_PROVIDER;
}

export function getOcrProviderDefinition(provider) {
  return OCR_PROVIDER_DEFINITIONS.find((item) => item.id === normalizeOcrProvider(provider)) || OCR_PROVIDER_DEFINITIONS[0];
}
