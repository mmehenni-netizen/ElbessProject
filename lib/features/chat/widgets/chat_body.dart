import 'dart:async';
import 'package:elbess/features/chat/widgets/product_suggestions.dart';
import 'package:flutter/material.dart';

import 'chat_models.dart';
import 'mock_ai.dart';
import 'product_context_card.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';
import 'quick_actions.dart';
import 'input_bar.dart';
import 'message_text.dart';

// ─── Chat Body Widget ─────────────────────────────────────────────────────────
class ChatBody extends StatefulWidget {
  final String productName;
  final String? productImage;
  final String? productPrice;

  const ChatBody({
    super.key,
    required this.productName,
    this.productImage,
    this.productPrice,
  });

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AnimationController _pulseController;

  // Quick-action chips
  final List<String> _quickActions = [
    '✨ Show similar styles',
    '👗 Complete the outfit',
    '📏 Help with sizing',
    '💸 Check pricing',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _sendInitialGreeting();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _sendInitialGreeting() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      // Context card (product bubble)
      setState(() {
        _messages.add(ChatMessage(
          id: 'context',
          role: MessageRole.assistant,
          text: '__product_context__',
        ));
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _messages.add(ChatMessage(
            id: 'greeting',
            role: MessageRole.assistant,
            text:
                'Hey there! 👋 I noticed you\'re interested in the **${widget.productName}**.\n\nI\'m your personal style assistant — I can suggest similar products, help you build an outfit, or answer any questions. What would you like to explore?',
          ));
        });
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;
    _controller.clear();

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      text: text.trim(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });
    _scrollToBottom();

    // Simulate AI typing delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    final response = MockAI.respond(text, widget.productName);
    setState(() {
      _messages.add(response);
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isLoading && index == _messages.length) {
                return TypingIndicator(animation: _pulseController);
              }
              final msg = _messages[index];
              if (msg.text == '__product_context__') {
                return ProductContextCard(
                  productName: widget.productName,
                  productPrice: widget.productPrice,
                );
              }
              return MessageBubble(msg: msg);
            },
          ),
        ),

        // Quick action chips
        if (!_isLoading) QuickActions(actions: _quickActions, onTap: _sendMessage),

        // Input bar
        InputBar(controller: _controller, onSend: _sendMessage),
      ],
    );
  }

  // ── Product Context Card (top of chat) ──────────────────────────────────────

  Widget _buildProductContextCard() {
    return ProductContextCard(productName: widget.productName, productPrice: widget.productPrice);
  }

  // ── Message Bubble ──────────────────────────────────────────────────────────

  Widget _buildMessageBubble(ChatMessage msg) {
    return MessageBubble(msg: msg);
  }

  Widget _buildMessageText(String text, bool isUser) {
    return MessageText(text: text, isUser: isUser);
  }

  // ── Product Suggestion Cards ─────────────────────────────────────────────────

  Widget _buildProductSuggestions(List<ProductCard> products) {
    return ProductSuggestions(products: products);
  }

  Widget _buildProductChip(ProductCard product) {
    return const SizedBox.shrink();
  }

  // ── Typing Indicator ─────────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return TypingIndicator(animation: _pulseController);
  }

  // ── Quick Action Chips ───────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    return QuickActions(actions: _quickActions, onTap: _sendMessage);
  }

  // ── Input Bar ────────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return InputBar(controller: _controller, onSend: _sendMessage);
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}