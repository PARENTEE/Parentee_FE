import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class SleepTimer extends StatefulWidget {
  final Function(Duration) onStop;
  final Function()? onStart; // 👈 thêm callback onStart

  const SleepTimer({
    super.key,
    required this.onStop,
    this.onStart, // 👈 optional
  });

  @override
  State<SleepTimer> createState() => _SleepTimerState();
}

class _SleepTimerState extends State<SleepTimer>
    with SingleTickerProviderStateMixin {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _running = false;
  double _progress = 0.0;
  static const Duration _maxDuration = Duration(minutes: 30);

  void _start() {
    widget.onStart?.call(); // 👈 gọi callback khi bắt đầu
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
        _progress = _elapsed.inSeconds / _maxDuration.inSeconds;
        if (_progress >= 1) {
          _stop();
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    widget.onStop(_elapsed);
    setState(() => _running = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _progress = 0.0;
      _running = false;
    });
  }

  String _formatTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(_elapsed.inHours);
    final m = twoDigits(_elapsed.inMinutes.remainder(60));
    final s = twoDigits(_elapsed.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary_button,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "30 m",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(),
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.alarm, size: 18, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        "1:15 pm",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(22),
                  backgroundColor:
                      _running ? Colors.redAccent : AppColors.primary_button,
                ),
                onPressed: _running ? _stop : _start,
                child: Icon(
                  _running ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: _reset,
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
