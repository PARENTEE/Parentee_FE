import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/features/auth/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _service = WeatherService();
  Map<String, dynamic>? _weather;
  bool _loading = true;
  String city = "Thành phố Hồ Chí Minh";

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

  Widget _getWeatherLottie(String condition) {
    String path = "assets/lottie/cloudy.json";
    switch (condition) {
      case "Clear":
        path = "assets/lottie/sunny.json";
        break;
      case "Clouds":
        path = "assets/lottie/cloudy.json";
        break;
      case "Rain":
        path = "assets/lottie/rain.json";
        break;
      case "Thunderstorm":
        path = "assets/lottie/thunderstorm.json";
        break;
    }
    return Lottie.asset(path, width: 140, height: 140);
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
                    // City & Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _weather!["city"],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

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

                    // Weather details
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/rain.json",
                          title: "Độ ẩm",
                          value: "${_weather!["humidity"]}%",
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/cloudy.json",
                          title: "Chỉ số AQI",
                          value: "${_weather!["aqi"]}",
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _WeatherInfoCard(
                          lottiePath: "assets/lottie/sunny.json",
                          title: "Lời khuyên",
                          value: _weather!["advice"],
                          big: true,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
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
  final String lottiePath;
  final String title;
  final String value;
  final bool big;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const _WeatherInfoCard({
    super.key,
    required this.lottiePath,
    required this.title,
    required this.value,
    this.big = false,
    this.titleStyle,
    this.valueStyle,
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
          Lottie.asset(lottiePath, width: 40, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle ?? const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: valueStyle ?? const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
