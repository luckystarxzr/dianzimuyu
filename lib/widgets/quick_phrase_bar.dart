import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickPhraseBar extends StatelessWidget {
  final List<String> phrases;
  final void Function(String phrase) onTap;

  const QuickPhraseBar({
    super.key,
    required this.phrases,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: phrases.map((p) {
        return GestureDetector(
          onTap: () => onTap(p),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.gold.withAlpha(12),
              border: Border.all(color: AppTheme.gold.withAlpha(35)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              p,
              style: AppTheme.phraseStyle,
            ),
          ),
        );
      }).toList(),
    );
  }
}
