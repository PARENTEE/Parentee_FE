import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, String>> _messages = [
    {
      "from": "bot",
      "text": "Chào bạn, rất vui được gặp bạn. Bạn gặp vấn đề gì với bé?",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto bật bàn phím
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, {"from": "user", "text": text}); // thêm tin nhắn mới
    });
    _controller.clear();

    // giả lập bot trả lời sau 1s
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(0, {
          "from": "bot",
          "text": "Mình sẽ hỗ trợ bạn với: $text",
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trợ Lý AI"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tin nhắn
          Expanded(
            child: ListView.builder(
              reverse: true, // 👉 tin nhắn trôi từ dưới lên
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["from"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isUser
                              ? AppColors.primary_button
                              : AppColors.chatMessage,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Ô nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: "Gửi tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFE7806F)),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
