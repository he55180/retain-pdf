from __future__ import annotations

from services.translation.llm.shared.control_context import RetrievalEvidence
from services.translation.llm.shared.control_context import TranslationControlContext
from services.translation.llm.shared.control_context import build_translation_control_context
from services.translation.llm.shared.control_context import resolve_engine_profile
from services.translation.policy import TranslationPolicyConfig
from services.translation.terms import AbbreviationEntry
from services.translation.terms import GlossaryEntry
from services.translation.terms import normalize_glossary_entries

# Translation direction mapping from short code to (source_lang, target_lang, target_language_name)
_TDIR_MAP: dict[str, tuple[str, str, str]] = {
    "en2zh": ("en", "zh-CN", "简体中文"),       # 简体中文
    "zh2en": ("zh", "en", "English"),
    "en2sw": ("en", "sw", "Kiswahili"),
    "sw2zh": ("sw", "zh-CN", "简体中文"),       # 简体中文
}

_TDIR_MARKER = "__TDIR__:"


def _parse_target_lang_from_custom_rules(custom_rules_text: str) -> tuple[str, str, str, str]:
    """Extract translation direction marker from custom_rules_text.

    Returns (cleaned_rules_text, source_lang, target_lang, target_language_name).
    """
    text = (custom_rules_text or "").strip()
    source_lang, target_lang, target_language_name = "auto", "zh-CN", "简体中文"
    if text.startswith(_TDIR_MARKER):
        end = text.find("|")
        code = text[len(_TDIR_MARKER):end] if end > 0 else text[len(_TDIR_MARKER):]
        code = code.strip()
        if code in _TDIR_MAP:
            source_lang, target_lang, target_language_name = _TDIR_MAP[code]
        text = text[end + 1:].strip() if end > 0 else ""
    return text, source_lang, target_lang, target_language_name


def build_translation_context(
    *,
    mode: str = "fast",
    source_lang: str = "auto",
    target_lang: str = "zh-CN",
    target_language_name: str = "简体中文",
    domain_guidance: str = "",
    rule_guidance: str = "",
    extra_guidance: str = "",
    request_label: str = "",
    glossary_entries: list[GlossaryEntry] | None = None,
    abbreviation_entries: list[AbbreviationEntry] | None = None,
    retrieval_entries: list[RetrievalEvidence] | None = None,
    model: str = "",
    base_url: str = "",
) -> TranslationControlContext:
    return build_translation_control_context(
        mode=mode,
        source_lang=source_lang,
        target_lang=target_lang,
        target_language_name=target_language_name,
        domain_guidance=domain_guidance,
        rule_guidance=rule_guidance,
        extra_guidance=extra_guidance,
        request_label=request_label,
        glossary_entries=glossary_entries,
        abbreviation_entries=abbreviation_entries,
        retrieval_entries=retrieval_entries,
        engine_profile=resolve_engine_profile(model=model, base_url=base_url),
    )


def build_translation_context_from_policy(
    policy_config: TranslationPolicyConfig,
    *,
    request_label: str = "",
    extra_guidance: str = "",
    glossary_entries: list[GlossaryEntry] | None = None,
    abbreviation_entries: list[AbbreviationEntry] | None = None,
    retrieval_entries: list[RetrievalEvidence] | None = None,
    model: str = "",
    base_url: str = "",
) -> TranslationControlContext:
    # Parse __TDIR__: direction marker from extra_guidance (passed via custom_rules_text)
    cleaned_extra, source_lang, target_lang, target_language_name = _parse_target_lang_from_custom_rules(extra_guidance)
    extra_guidance_parts: list[str] = []
    if cleaned_extra.strip():
        extra_guidance_parts.append(cleaned_extra.strip())
    if str(getattr(policy_config, "math_mode", "placeholder") or "placeholder").strip() == "direct_typst":
        extra_guidance_parts.append(
            "Math output mode: direct_typst.\n"
            "When the source contains formulas, output the final translated text directly with inline math preserved "
            "using `$...$` spans when needed.\n"
            "Do not emit placeholder tokens, JSON shells, labels, or explanations."
        )
    return build_translation_context(
        mode=policy_config.mode,
        source_lang=source_lang,
        target_lang=target_lang,
        target_language_name=target_language_name,
        domain_guidance=(policy_config.domain_context.get("translation_guidance") or "").strip(),
        rule_guidance=policy_config.rule_guidance,
        extra_guidance="\n\n".join(extra_guidance_parts).strip(),
        request_label=request_label,
        glossary_entries=normalize_glossary_entries(glossary_entries),
        abbreviation_entries=abbreviation_entries,
        retrieval_entries=retrieval_entries,
        model=model,
        base_url=base_url,
    )


__all__ = [
    "build_translation_context",
    "build_translation_context_from_policy",
    "RetrievalEvidence",
    "TranslationControlContext",
]
