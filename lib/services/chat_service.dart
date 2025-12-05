import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'child_service.dart';

class ChatService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  static late GenerativeModel _model;
  static ChatSession? _chat;

  static const String systemPrompt = """
Bạn là trợ lý AI thân thiện của Parentee. 
- Trả lời ngắn gọn, rõ ràng, cảm xúc nhẹ nhàng.
- Khi cần dữ liệu bé → gọi function get_child_status.
- Không được tự bịa dữ liệu về bé.
- Người dùng có thể gọi tên bé bằng dạng: "bé Nam", "bé An", 
  → Hãy hiểu đây là childName, không cần hỏi lại trừ khi câu mơ hồ.
- Nếu người dùng đã nói "bé <tên>" thì dùng tên đó khi gọi function get_child_status.
- Khi backend trả dữ liệu → phải tóm tắt + đưa lời khuyên thực tế.

Khi bạn cần dữ liệu thực tế của bé, bạn phải gọi function:
get_child_status(childName, date)
""";

  static void init() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      tools: [
        Tool(
          functionDeclarations: [
            FunctionDeclaration(
              "get_child_status",
              "Lấy dữ liệu tình trạng bé từ API app.",
              Schema(
                SchemaType.object,
                properties: {
                  "childName": Schema(SchemaType.string),
                  "date": Schema(
                    SchemaType.string,
                    description: "Ngày dạng yyyy-MM-dd hoặc 'today'",
                  ),
                },
                requiredProperties: ["childName"],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static ChatSession _ensureChat() {
    _chat ??= _model.startChat(
      history: [
        Content.text(systemPrompt),
      ],
    );
    return _chat!;
  }

  /// STREAMING CHAT + FUNCTION CALLING
  static Stream<String> chatStream(String message) async* {
    final chat = _ensureChat();

    try {
      final stream = chat.sendMessageStream(
        Content.text(message),
      );

      await for (final chunk in stream) {
        // 🧩 1. Function calling
        if (chunk.functionCalls != null && chunk.functionCalls!.isNotEmpty) {
          for (final call in chunk.functionCalls!) {
            print("⚙️ AI yêu cầu gọi function: ${call.name}");
            print("📌 args = ${call.args}");

            if (call.name == "get_child_status") {
              final childName = call.args["childName"]?.toString() ?? "";
              final date = call.args["date"]?.toString() ?? "";

              print("➡️ Gọi API child status với: name=$childName, date=$date");

              final response = await ChildService.getChildStatus(
                childName: childName,
                date: date,
              );

              print("✅ API trả về: ${response.data}");

              // Gửi function result về AI
              final followup = await chat.sendMessage(
                Content.functionResponse(
                  "get_child_status",
                  response.data, // JSON map
                ),
              );

              // followup có thể có text
              if (followup.text != null) {
                yield followup.text!;
              }
            }
          }

          // QUAN TRỌNG: bỏ qua phần text của chunk function
          continue;
        }

        // 🧩 2. Text chunk → gửi ra UI
        final text = chunk.text;
        if (text != null && text.trim().isNotEmpty) {
          yield text;
        }
      }
    } catch (e, s) {
      print("❌ STREAM ERROR: $e\n$s");
      yield "[Lỗi: không thể lấy phản hồi từ AI]";
    }
  }

  static void reset() {
    _chat = null;
  }
}
