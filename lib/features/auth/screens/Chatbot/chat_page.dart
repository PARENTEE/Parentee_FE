import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/chat_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

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
      "text": "Chào bạn, mình là trợ lý chăm sóc bé 0–12 tháng. Bé đang gặp vấn đề gì nhỉ?",
    },
  ];

  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  // ----------------------------
  // STREAMING SEND MESSAGE
  // ----------------------------
  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isStreaming) return;

    // Add user message
    setState(() {
      _messages.insert(0, {"from": "user", "text": text});
    });
    _controller.clear();

    // Reserve bot message (empty)
    setState(() {
      _messages.insert(0, {"from": "bot", "text": ""});
      _isStreaming = true;
    });

    final int botIndex = 0;
    final buffer = StringBuffer();

    ChatService.chatStream(text).listen(
          (chunk) {
        buffer.write(chunk);

        setState(() {
          _messages[botIndex]["text"] = buffer.toString().trim();
        });
      },
      onDone: () {
        setState(() {
          _isStreaming = false;
        });
      },
      onError: (err) {
        PopUpToastService.showErrorToast(
            context, "AI đang bận, vui lòng thử lại.");

        setState(() {
          _messages.removeAt(botIndex);
          _isStreaming = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trợ Lý Nuôi Dạy Bé"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // LIST MESSAGES
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                final isUser = msg["from"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary_button
                          : AppColors.chatMessage,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: msg["text"]!.isEmpty && !_isStreaming
                        ? const SizedBox.shrink()
                        : MarkdownBody(
                      data: msg["text"]!,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 15),
                        strong: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                        listBullet: TextStyle(
                            color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT AREA
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
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
          )
        ],
      ),
    );
  }
}
