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
- Nếu thiếu childName → hỏi lại người dùng.
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
                  "date": Schema(SchemaType.string,
                      description: "Ngày dạng yyyy-MM-dd hoặc 'today'"),
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
          // Nếu là function_call
// Nếu có functionCalls
        if (chunk.functionCalls != null) {
          for (final call in chunk.functionCalls!) {
            print("⚙ AI yêu cầu gọi function: ${call.name}");

            if (call.name == "get_child_status") {
              final childName = call.args["childName"]?.toString() ?? "";
              final date = call.args["date"]?.toString() ?? "";

              // 🚀 Gọi API backend thật
              final response = await ChildService.getChildStatus(
                childName: childName,
                date: date,
              );

              // 🔁 Gửi kết quả lại cho AI
              final followup = await chat.sendMessage(
                Content.functionResponse(
                  "get_child_status",
                  response.data, // JSON Map
                ),
              );

              if (followup.text != null) {
                yield followup.text!;
              }
            }

            // 👉 Tự thêm các function khác nếu có
          }

          // Tiếp tục vòng stream
          continue;
        }

        // Nếu là text thường → stream ra UI
        final text = chunk.text;
        if (text != null && text.trim().isNotEmpty) {
          yield text;
        }
      }
    } catch (e, s) {
      print("STREAM ERROR: $e\n$s");
      yield "[Lỗi: không thể lấy phản hồi từ AI]";
    }
  }

  static void reset() {
    _chat = null;
  }
}
