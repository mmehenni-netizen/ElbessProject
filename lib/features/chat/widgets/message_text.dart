import 'package:flutter/material.dart';

class MessageText extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageText({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          color: isUser ? Colors.white : const Color(0xFF111827),
          fontSize: 14,
          fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.w400,
          height: 1.5,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }
}
