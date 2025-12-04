import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  static late GenerativeModel _model;
  static ChatSession? _chat;

  static const String systemPrompt = """
Bạn là một trợ lý AI nói tiếng Việt, thân thiện, dễ hiểu, luôn hỗ trợ cha mẹ có con từ 0–12 tháng tuổi.

YÊU CẦU:
- Giọng nói nhẹ nhàng, tích cực, không phán xét.
- Giải thích đơn giản, dễ hiểu, phù hợp với cả bố và mẹ.
- Chỉ đưa lời khuyên CHUNG, không được chẩn đoán bệnh.
- Khi có vấn đề nghiêm trọng, hãy khuyên cha mẹ liên hệ bác sĩ.
- Luôn ưu tiên an toàn cho trẻ sơ sinh.
""";

  static void init() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  static ChatSession _ensureChat() {
    if (_chat == null) {
      _chat = _model.startChat(
        history: [
          Content.text(systemPrompt),
        ],
      );
    }
    return _chat!;
  }

  /// 🚀 STREAMING TRẢ LỜI
  static Stream<String> chatStream(String message) async* {
    final chat = _ensureChat();

    try {
      final stream = chat.sendMessageStream(
        Content.text(message),
      );

      await for (final chunk in stream) {
        final text = chunk.text;
        if (text != null && text.trim().isNotEmpty) {
          yield text; // gửi chunk ra UI
        }
      }
    } catch (e, s) {
      print("STREAMING ERROR: $e\n$s");
      yield "[Lỗi: không thể stream tin nhắn]";
    }
  }

  static void resetConversation() {
    _chat = null;
  }
}
