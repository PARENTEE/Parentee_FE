class SleepEntry {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final String? startMood;
  final String? endMood;
  final String? sleepPosition;
  final String? howItHappened;

  SleepEntry({
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.startMood,
    this.endMood,
    this.sleepPosition,
    this.howItHappened,
  });
}
