import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

class ChatInputWidget extends StatefulWidget {
  final void Function(HamsterAction action, String message) onSend;

  const ChatInputWidget({super.key, required this.onSend});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final action = HamsterChatMatcher.match(text);
    widget.onSend(action, text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(
                hintText: '모찌야, 말 걸어봐요...',
                hintStyle: TextStyle(color: Color(0xFF9B7B6A)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              style: const TextStyle(color: Color(0xFF4A3728), fontSize: 15),
            ),
          ),
          GestureDetector(
            onTap: _send,
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFF8C69),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
