import 'package:flutter/material.dart';

enum MessageType { text, productSuggestion }
enum MessageRole { user, assistant }

class ProductCard {
  final String name;
  final String price;
  final String tag;
  final IconData icon;
  final Color color;

  const ProductCard({
    required this.name,
    required this.price,
    required this.tag,
    required this.icon,
    required this.color,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final MessageRole role;
  final MessageType type;
  final List<ProductCard>? products;
  final DateTime timestamp;
  bool isTyping;

  ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    this.type = MessageType.text,
    this.products,
    DateTime? timestamp,
    this.isTyping = false,
  }) : timestamp = timestamp ?? DateTime.now();
}
