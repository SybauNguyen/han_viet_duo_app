import 'package:flutter/material.dart';

import '../data/question.dart';

const Color _sentenceGreen = Color(0xFF28664F);
const Color _sentenceOrange = Color(0xFFCC6B3D);

/// Hien thi tung chu trong cau; cham vao chu co the xem am Han-Viet va nghia.
class InteractiveSentence extends StatelessWidget {
  final List<SentenceToken> tokens;
  final String? selectedAnswer;

  const InteractiveSentence({
    super.key,
    required this.tokens,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 16,
      children: tokens.map((token) {
        if (token.isBlank) {
          return Container(
            constraints: const BoxConstraints(minWidth: 66),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _sentenceGreen, width: 2.5)),
            ),
            child: Text(
              selectedAnswer ?? '____',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                color: _sentenceGreen,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        }

        return Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 3),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDDE5DD)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          richMessage: TextSpan(children: [
            TextSpan(
              text: '${token.hanVietReading?.toUpperCase() ?? ''}\n',
              style: const TextStyle(color: _sentenceOrange, fontSize: 16, fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: token.meaning ?? '',
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ]),
          child: Text(
            token.text,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              decorationColor: Colors.grey,
              decorationThickness: 2,
            ),
          ),
        );
      }).toList(),
    );
  }
}
