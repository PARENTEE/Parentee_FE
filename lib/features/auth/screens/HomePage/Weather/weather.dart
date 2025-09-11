import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/Weather/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _service = WeatherService();
  Map<String, dynamic>? _weather;
  bool _loading = true;
  String city = "Hanoi";

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final data = await _service.fetchWeather(city);
      setState(() {
        _weather = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  /// Lấy file Lottie dựa vào condition
  Widget _getWeatherLottie(String condition) {
    switch (condition) {
      case "Clear":
        return Lottie.asset(
          "assets/lottie/sunny.json",
          width: 140,
          height: 140,
        );
      case "Clouds":
        return Lottie.asset(
          "assets/lottie/cloudy.json",
          width: 140,
          height: 140,
        );
      case "Rain":
        return Lottie.asset("assets/lottie/rain.json", width: 140, height: 140);
      case "Thunderstorm":
        return Lottie.asset(
          "assets/lottie/thunderstorm.json",
          width: 140,
          height: 140,
        );
      default:
        return Lottie.asset(
          "assets/lottie/cloudy.json",
          width: 140,
          height: 140,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thời tiết"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _weather == null
              ? const Center(child: Text("Không tải được dữ liệu"))
              : RefreshIndicator(
                onRefresh: _loadWeather,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _weather!["city"],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87, // đậm hơn để nhìn rõ
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Main weather card
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getWeatherLottie(_weather!["condition"]),
                            const SizedBox(height: 12),
                            Text(
                              "${_weather!["temp"]}°C",
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _weather!["description"],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                    Text("Cao nhất: ${_weather!["tempMax"]}°"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.blue,
                                    ),
                                    Text("Thấp nhất: ${_weather!["tempMin"]}°"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Weather details (2 cột)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/rain.json",
                          title: "Độ ẩm",
                          value: "${_weather!["humidity"]}%",
                        ),
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/cloudy.json",
                          title: "Chỉ số AQI",
                          value: "${_weather!["aqi"]}",
                        ),
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/sunny.json",
                          title: "Lời khuyên",
                          value: _weather!["advice"],
                          big: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tomorrow forecast (fake)
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: ListTile(
                        leading: Lottie.asset(
                          "assets/lottie/cloudy.json",
                          width: 50,
                          height: 50,
                        ),
                        title: const Text(
                          "Dự báo ngày mai",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text("36° / 27°"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class _WeatherInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? lottiePath;
  final bool big;

  const _WeatherInfoCard({
    required this.title,
    required this.value,
    this.lottiePath,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          big ? double.infinity : (MediaQuery.of(context).size.width / 2 - 24),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lottiePath != null)
            Lottie.asset(lottiePath!, width: 36, height: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
