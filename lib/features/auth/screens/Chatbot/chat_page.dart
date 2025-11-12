import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/child_service.dart';
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

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Thêm tin nhắn của user
    setState(() {
      _messages.insert(0, {"from": "user", "text": text});
    });
    _controller.clear();

    // Thêm tin nhắn loading của bot
    setState(() {
      _messages.insert(0, {"from": "bot", "text": "loading"});
    });

    int loadingIndex = 0; // chỉ số của tin nhắn loading

    // Gọi API
    var response = await ChildService.chatAnswer(text);

    if (response.success) {
      setState(() {
        _messages[loadingIndex]["text"] = response.data;
      });
    } else {
      setState(() {
        _messages.removeAt(loadingIndex);
      });
      PopUpToastService.showErrorToast(context, "Dịch vụ AI hiện đang bận.");
    }
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
              reverse: true,
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
                      color: isUser
                          ? AppColors.primary_button
                          : AppColors.chatMessage,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: msg["text"] == "loading"
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary_button,
                      ),
                    )
                        : Text(
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
