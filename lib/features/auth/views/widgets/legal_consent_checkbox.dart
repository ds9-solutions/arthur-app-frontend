import 'package:arthur/core/tokens/tokens.dart';
import 'package:flutter/material.dart';

/// Caixa de aceite: maioridade + Termos de Uso + Política de Privacidade
/// (RN01, RN07).
///
/// Os documentos ainda não foram publicados (C1-6): os nomes aparecem
/// destacados, mas sem link até existirem as URLs.
class LegalConsentCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LegalConsentCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final base = context.typography.caption.copyWith(color: context.colors.text.base);
    final highlight = base.copyWith(
      color: context.colors.primary,
      fontWeight: TypographyTokens.semibold,
    );

    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(context.borderRadius.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: value, onChanged: (checked) => onChanged(checked ?? false)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: context.spacing.small + context.spacing.extraSmall),
                child: Text.rich(
                  TextSpan(
                    style: base,
                    children: [
                      const TextSpan(text: 'Tenho 18 anos ou mais e li e aceito os '),
                      TextSpan(text: 'Termos de Uso', style: highlight),
                      const TextSpan(text: ' e a '),
                      TextSpan(text: 'Política de Privacidade', style: highlight),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
