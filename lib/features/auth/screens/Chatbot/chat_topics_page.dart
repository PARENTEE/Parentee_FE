import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'chat_page.dart';

class ChatTopicsPage extends StatefulWidget {
  const ChatTopicsPage({super.key});

  @override
  State<ChatTopicsPage> createState() => _ChatTopicsPageState();
}

class _ChatTopicsPageState extends State<ChatTopicsPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // căn giữa ngang
          children: [
            SizedBox(height: 20),

            Lottie.asset(
              "assets/lottie/chatbot_2.json",
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Chào mừng bạn đến với trợ lý AI của chúng tôi!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8), // khoảng cách giữa 2 dòng
                  Text(
                    "Hãy chọn chủ đề bên dưới để bắt đầu trò chuyện.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Danh sách topic
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => const ChatPage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          final tween = Tween(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeInOut));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Trò chuyện với Trợ lý AI"),
                ),
                const SizedBox(height: 12), // khoảng cách giữa 2 nút
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => const ChatPage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          final tween = Tween(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeInOut));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Trò chuyện với Chuyên gia AI"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
