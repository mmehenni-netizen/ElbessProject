import 'chat_models.dart';
import 'package:flutter/material.dart';

class MockAI {
  static final List<ProductCard> _baggyJeansRelated = [
    const ProductCard(
      name: 'Oversized Cargo Pants',
      price: '\$58.99',
      tag: 'Best Match',
      icon: Icons.style_rounded,
      color: Color(0xFF7C3AED),
    ),
    const ProductCard(
      name: 'Wide Leg Trousers',
      price: '\$49.99',
      tag: 'Trending',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFEF4444),
    ),
    const ProductCard(
      name: 'Relaxed Fit Chinos',
      price: '\$44.99',
      tag: 'New Arrival',
      icon: Icons.fiber_new_rounded,
      color: Color(0xFF10B981),
    ),
  ];

  static final List<ProductCard> _styleRelated = [
    const ProductCard(
      name: 'Graphic Oversized Tee',
      price: '\$29.99',
      tag: 'Pairs Well',
      icon: Icons.checkroom_rounded,
      color: Color(0xFF2563EB),
    ),
    const ProductCard(
      name: 'Chunky Sneakers',
      price: '\$89.99',
      tag: 'Complete Look',
      icon: Icons.directions_walk_rounded,
      color: Color(0xFFF59E0B),
    ),
  ];

  static ChatMessage respond(String userMessage, String productName) {
    final lower = userMessage.toLowerCase();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (lower.contains('similar') ||
        lower.contains('like') ||
        lower.contains('other') ||
        lower.contains('more')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        type: MessageType.productSuggestion,
        text: 'Here are some styles similar to $productName that you might love 👇',
        products: _baggyJeansRelated,
      );
    }

    if (lower.contains('style') ||
        lower.contains('wear') ||
        lower.contains('outfit') ||
        lower.contains('pair')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        type: MessageType.productSuggestion,
        text: 'Great choice! To complete your look with $productName, I suggest these items 🔥',
        products: _styleRelated,
      );
    }

    if (lower.contains('price') ||
        lower.contains('cost') ||
        lower.contains('cheap') ||
        lower.contains('discount')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        text:
            'The $productName is currently priced at \$39.99. We also have a 15% discount for members! 🎉 Want me to show you more items in a similar price range?',
      );
    }

    if (lower.contains('size') || lower.contains('fit')) {
      return ChatMessage(
        id: id,
        role: MessageRole.assistant,
        text:
            'The $productName runs true to size with a relaxed, streetwear-inspired fit. We recommend sizing down if you prefer a slightly slimmer silhouette. Available in XS–XXL. Want me to find your perfect fit? 📏',
      );
    }

    return ChatMessage(
      id: id,
      role: MessageRole.assistant,
      text:
          'Great question about $productName! I can help you find similar styles, outfit suggestions, sizing info, or pricing details. What would you like to know? ✨',
    );
  }
}
