import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "cdcfcca1a32846d2c4db528074248d04";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final weatherUrl = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi",
    );

    final weatherRes = await http.get(weatherUrl);
    if (weatherRes.statusCode != 200) {
      print("❌ Weather API error: ${weatherRes.statusCode}");
      print("Response: ${weatherRes.body}");
      throw Exception("Weather API error");
    }

    final weatherData = json.decode(weatherRes.body);

    final lat = weatherData["coord"]["lat"];
    final lon = weatherData["coord"]["lon"];

    // Lấy thêm Air Quality
    final airUrl = Uri.parse(
      "https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey",
    );
    final airRes = await http.get(airUrl);
    if (airRes.statusCode != 200) {
      print("❌ Air API error: ${airRes.statusCode}");
      print("Response: ${airRes.body}");
      throw Exception("Air API error");
    }

    final airData = json.decode(airRes.body);

    final aqi = airData["list"][0]["main"]["aqi"];

    return {
      "city": weatherData["name"],
      "temp": (weatherData["main"]["temp"] as num).toDouble(),
      "tempMin": (weatherData["main"]["temp_min"] as num).toDouble(),
      "tempMax": (weatherData["main"]["temp_max"] as num).toDouble(),
      "humidity": weatherData["main"]["humidity"],
      "condition": weatherData["weather"][0]["main"],
      "description": weatherData["weather"][0]["description"],
      "aqi": aqi,
      "advice": _getAdvice(
        (weatherData["main"]["temp"] as num).toDouble(),
        aqi,
      ),
    };
  }

  String _getAdvice(double temp, int aqi) {
    String advice = "";

    if (temp > 35) {
      advice += "Trời nóng, nhớ uống đủ nước. ";
    } else if (temp < 15) {
      advice += "Trời lạnh, hãy mặc ấm. ";
    } else {
      advice += "Thời tiết khá dễ chịu. ";
    }

    switch (aqi) {
      case 1:
        advice += "Chất lượng không khí tốt, có thể ra ngoài thoải mái.";
        break;
      case 2:
        advice += "Không khí chấp nhận được.";
        break;
      case 3:
        advice += "Không khí ô nhiễm nhẹ, hạn chế hoạt động mạnh ngoài trời.";
        break;
      case 4:
        advice += "Không khí xấu, người nhạy cảm nên đeo khẩu trang.";
        break;
      case 5:
        advice += "Không khí rất nguy hại, nên hạn chế ra ngoài.";
        break;
    }

    return advice;
  }
}
