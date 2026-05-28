import 'dart:math';

import 'package:elbess/features/chat/widgets/chat_models.dart';
import 'package:elbess/features/chat/widgets/mock_ai.dart';
import 'package:elbess/features/home/data/home_repo.dart';
import 'package:elbess/features/home/data/product_model.dart';
import 'package:elbess/services/api_key_provider.dart';
import 'package:elbess/services/generative_ai_service.dart';

class ChatRepo {
  ChatRepo({GenerativeAIService? service, HomeRepo? homeRepo})
      : _service = service,
        _homeRepo = homeRepo ?? HomeRepo();

  final GenerativeAIService? _service;
  final HomeRepo _homeRepo;

  GenerativeAIService? _resolveService() {
    if (_service != null) {
      return _service;
    }

    try {
      return GenerativeAIService(ApiKeyProvider.requireFromDartDefine());
    } catch (_) {
      return null;
    }
  }

  Future<ChatMessage> replyForProduct({
    required String productName,
    required String userMessage,
  }) async {
    final trimmedProductName = productName.trim().isEmpty ? 'this product' : productName.trim();
    final trimmedUserMessage = userMessage.trim();

    final service = _resolveService();
    if (service == null) {
      return MockAI.respond(trimmedUserMessage, trimmedProductName);
    }

    final prompt = _buildPrompt(
      productName: trimmedProductName,
      userMessage: trimmedUserMessage,
    );

    try {
      final text = await service.generateText(
        prompt,
        temperature: 0.25,
        maxOutputTokens: 320,
      );

      final matches = await _findMatchingProducts(
        productName: trimmedProductName,
        userMessage: trimmedUserMessage,
        aiText: text,
      );

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        type: matches.isNotEmpty ? MessageType.productSuggestion : MessageType.text,
        text: text.trim().isEmpty
            ? 'I can help with $trimmedProductName. Ask me about fit, styling, pricing, or similar items.'
            : text.trim(),
        products: matches.isNotEmpty ? matches : null,
      );
    } catch (_) {
      return _fallbackResponse(trimmedUserMessage, trimmedProductName);
    }
  }

  ChatMessage _fallbackResponse(String userMessage, String productName) {
    final response = MockAI.respond(userMessage, productName);

    return response;
  }

  String _buildPrompt({
    required String productName,
    required String userMessage,
  }) {
    return '''
You are a helpful product assistant for an e-commerce app.

Product focus: $productName

User question: $userMessage

Rules:
- Answer only as a shopping assistant for this product.
- Keep the answer concise, friendly, and useful.
- If the user asks for style, fit, price, size, or similar products, tailor the answer to $productName.
- If the user asks what to wear or how to style it, mention outfit ideas and the kinds of products that match best.
- Do not mention that you are an AI model.
- If you are unsure about a detail, say you can help based on the product information available.
''';
  }

  Future<List<ProductCard>> _findMatchingProducts({
    required String productName,
    required String userMessage,
    required String aiText,
  }) async {
    final products = await _homeRepo.getProducts();
    if (products.isEmpty) {
      return <ProductCard>[];
    }

    final intentKeywords = _extractIntentKeywords(userMessage);
    final aiKeywords = _extractStyleKeywords(aiText);
    final productKeywords = _extractKeywords(productName);
    final keywords = <String>{...intentKeywords, ...aiKeywords, ...productKeywords};
    final scoredProducts = <_ScoredProduct>[];

    for (final product in products) {
      final score = _scoreProduct(
        product,
        keywords,
        productName,
        userMessage,
        aiText,
      );
      if (score <= 0) {
        continue;
      }

      scoredProducts.add(_ScoredProduct(product: product, score: score));
    }

    scoredProducts.sort((a, b) => b.score.compareTo(a.score));

    final filtered = scoredProducts.where((item) => item.score >= 6).take(3).toList();

    if (filtered.isEmpty) {
      return <ProductCard>[];
    }

    return filtered
        .asMap()
        .entries
        .map((entry) => _toProductCard(
              entry.value.product,
              rank: entry.key,
              productName: productName,
              userMessage: userMessage,
              aiText: aiText,
            ))
        .toList();
  }

  int _scoreProduct(
    ProductModel product,
    Set<String> keywords,
    String productName,
    String userMessage,
    String aiText,
  ) {
    final productText = _normalizeText([
      product.name,
      product.description,
      product.category,
      product.gender,
      product.store?.name ?? '',
    ].join(' '));

    var score = 0;

    for (final keyword in keywords) {
      if (productText.contains(keyword)) {
        score += 3;
      }
    }

    final productWords = _extractKeywords(productText);
    final overlap = keywords.intersection(productWords).length;
    score += overlap * 2;

    final lowerMessage = userMessage.toLowerCase();
    final lowerAi = aiText.toLowerCase();
    final lowerProductName = productName.toLowerCase();

    if (lowerMessage.contains('wear') || lowerMessage.contains('outfit') || lowerMessage.contains('style')) {
      if (_looksLikeStyleMatch(productText, aiText)) {
        score += 4;
      }
    }

    if (lowerProductName.isNotEmpty && productText.contains(_normalizeText(lowerProductName))) {
      score += 2;
    }

    if (lowerAi.contains(product.name.toLowerCase())) {
      score += 4;
    }

    if (_extractKeywords(aiText).isNotEmpty && _extractKeywords(aiText).intersection(productWords).isNotEmpty) {
      score += 3;
    }

    return score;
  }

  ProductCard _toProductCard(
    ProductModel product, {
    required int rank,
    required String productName,
    required String userMessage,
    required String aiText,
  }) {
    final tag = rank == 0
        ? 'Best Match'
        : rank == 1
            ? 'Style Pick'
            : 'Good Match';

    return ProductCard(
      name: product.name,
      price: '\$${product.price.toStringAsFixed(2)}',
      tag: tag,
      icon: _iconForProduct(product),
      color: _colorForProduct(product, rank),
    );
  }

  IconData _iconForProduct(ProductModel product) {
    final text = _normalizeText('${product.name} ${product.category} ${product.description}');

    if (text.contains('shoe') || text.contains('sneaker') || text.contains('boot')) {
      return Icons.directions_walk_rounded;
    }
    if (text.contains('dress') || text.contains('skirt')) {
      return Icons.ward_rounded;
    }
    if (text.contains('jacket') || text.contains('coat') || text.contains('hoodie')) {
      return Icons.checkroom_rounded;
    }
    if (text.contains('pants') || text.contains('trouser') || text.contains('jean')) {
      return Icons.style_rounded;
    }
    return Icons.shopping_bag_rounded;
  }

  Color _colorForProduct(ProductModel product, int rank) {
    if (rank == 0) {
      return const Color(0xFF7C3AED);
    }

    final text = _normalizeText('${product.name} ${product.category} ${product.description}');
    if (text.contains('shoe') || text.contains('sneaker')) {
      return const Color(0xFFF59E0B);
    }
    if (text.contains('dress') || text.contains('skirt')) {
      return const Color(0xFFEC4899);
    }
    if (text.contains('pants') || text.contains('jean')) {
      return const Color(0xFF10B981);
    }

    final palette = <Color>[
      const Color(0xFF2563EB),
      const Color(0xFF7C3AED),
      const Color(0xFFEF4444),
      const Color(0xFF14B8A6),
    ];

    return palette[rank % palette.length];
  }

  String _normalizeText(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]+'), ' ');
  }

  bool _looksLikeStyleMatch(String productText, String aiText) {
    final aiHints = _extractStyleKeywords(aiText);

    if (aiHints.isEmpty) {
      return false;
    }

    final styleBuckets = <String, List<String>>{
      'tops': ['shirt', 'tee', 'top', 'blouse', 'hoodie', 'sweatshirt', 'jacket', 'coat'],
      'bottoms': ['pants', 'trouser', 'jean', 'short', 'skirt', 'legging'],
      'shoes': ['shoe', 'sneaker', 'boot', 'loafer', 'sandal'],
      'dresses': ['dress', 'gown'],
      'accessories': ['bag', 'belt', 'cap', 'hat', 'watch', 'scarf'],
    };

    for (final entry in styleBuckets.entries) {
      final bucketHit = entry.value.any(productText.contains);
      if (!bucketHit) {
        continue;
      }

      if (aiHints.contains(entry.key) || aiHints.any((hint) => entry.value.any((word) => word.contains(hint) || hint.contains(word)))) {
        return true;
      }
    }

    return false;
  }

  Set<String> _extractIntentKeywords(String value) {
    final keywords = _extractKeywords(value);
    final intentWords = <String>{
      'wear',
      'outfit',
      'style',
      'pair',
      'match',
      'combine',
      'similar',
      'size',
      'fit',
      'price',
      'cheap',
      'formal',
      'casual',
      'streetwear',
      'office',
      'party',
      'summer',
      'winter',
      'sport',
    };

    return keywords.intersection(intentWords);
  }

  Set<String> _extractStyleKeywords(String value) {
    final normalized = _normalizeText(value);
    final keywords = _extractKeywords(normalized);

    final mapping = <String, Set<String>>{
      'tops': {'shirt', 'tee', 'top', 'blouse', 'hoodie', 'sweatshirt', 'jacket', 'coat'},
      'bottoms': {'pants', 'trouser', 'jean', 'short', 'skirt', 'legging'},
      'shoes': {'shoe', 'sneaker', 'boot', 'loafer', 'sandal'},
      'dresses': {'dress', 'gown'},
      'accessories': {'bag', 'belt', 'cap', 'hat', 'watch', 'scarf'},
      'formal': {'formal', 'office', 'business', 'smart'},
      'casual': {'casual', 'daily', 'everyday'},
      'sport': {'sport', 'gym', 'active', 'athletic'},
    };

    final hints = <String>{};
    for (final entry in mapping.entries) {
      if (keywords.intersection(entry.value).isNotEmpty) {
        hints.add(entry.key);
      }
    }

    return hints;
  }

  Set<String> _extractKeywords(String value) {
    final normalized = _normalizeText(value);
    final stopWords = <String>{
      'the',
      'and',
      'for',
      'with',
      'what',
      'wear',
      'think',
      'can',
      'you',
      'about',
      'this',
      'that',
      'like',
      'show',
      'want',
      'from',
      'product',
      'items',
      'item',
      'app',
      'style',
      'outfit',
      'best',
      'match',
      'pair',
      'help',
      'please',
    };

    return normalized
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toSet();
  }
}

class _ScoredProduct {
  _ScoredProduct({required this.product, required this.score});

  final ProductModel product;
  final int score;
}
