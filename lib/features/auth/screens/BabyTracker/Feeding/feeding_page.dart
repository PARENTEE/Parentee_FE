import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:parentee_fe/services/utils_service.dart';
import 'package:parentee_fe/services/child_service.dart';

class AddFeedingPage extends StatefulWidget {
  final String childId;
  const AddFeedingPage({super.key, required this.childId});

  @override
  State<AddFeedingPage> createState() => _AddFeedingPageState();
}

class _AddFeedingPageState extends State<AddFeedingPage>
    with SingleTickerProviderStateMixin {
  int selectedType = 0;
  int leftSeconds = 0;
  int rightSeconds = 0;
  bool leftRunning = false;
  bool rightRunning = false;
  Timer? leftTimer;
  Timer? rightTimer;
  DateTime startTime = DateTime.now();

  Duration _leftDuration = const Duration(minutes: 0, seconds: 0);
  Duration _rightDuration = const Duration(minutes: 0, seconds: 0);

  final _noteController = TextEditingController();
  late TabController _tabController;

  // --- Init ---
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // --- Timer logic ---
  void _toggleTimer(String side) {
    setState(() {
      if (side == 'left') {
        if (leftRunning) {
          leftTimer?.cancel();
        } else {
          leftTimer = Timer.periodic(const Duration(seconds: 1), (_) {
            setState(() => leftSeconds++);
          });
        }
        leftRunning = !leftRunning;
      } else if (side == 'right') {
        if (rightRunning) {
          rightTimer?.cancel();
        } else {
          rightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
            setState(() => rightSeconds++);
          });
        }
        rightRunning = !rightRunning;
      }
    });
  }

  void _stopAll() {
    leftTimer?.cancel();
    rightTimer?.cancel();
    setState(() {
      leftRunning = false;
      rightRunning = false;
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // --- Save ---
  void _saveFeeding() async {
    var data = {
      'childId': widget.childId,
      'method': selectedType, // ví dụ: 0, 1 hoặc "Breast", tùy enum backend bạn
      'startedAt': startTime?.toIso8601String(),
      'leftDuration': UtilsService.formatDuration(Duration(seconds: leftSeconds)), // "00:05:30"
      'rightDuration': UtilsService.formatDuration(Duration(seconds: rightSeconds)), // "00:04:15"
      'notes': _noteController.text,
    };

    if (_tabController.index == 1) {
      data = {
        'childId': widget.childId,
        'method': selectedType,
        'startedAt': startTime?.toIso8601String(),
        'leftDuration': UtilsService.formatDuration(_leftDuration),
        'rightDuration': UtilsService.formatDuration(_rightDuration),
        'notes': _noteController.text
      };
    }

    print(data); // kiểm tra trước khi gửi

    // show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Call API
    final response = await ChildService.createFeeding(data);

    // Remove loading
    Navigator.pop(context);

    if(response.success){
      PopUpToastService.showSuccessToast(context, "Cho con bú thành công");
      Navigator.pop(context);
    }
    else {
      PopUpToastService.showErrorToast(context, "Thêm vào không thành công");
    }

    // _stopAll();
    // setState(() {
    //   leftSeconds = 0;
    //   rightSeconds = 0;
    //   startTime = null;
    // });
  }

  @override
  void dispose() {
    leftTimer?.cancel();
    rightTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Cho bú"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- Feeding Type Selector ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cách cho bú:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                DropdownButton<int>(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Sữa mẹ')),
                    DropdownMenuItem(value: 1, child: Text('Chai')),
                    // DropdownMenuItem(value: 'Solids', child: Text('Solids')),
                  ],
                  onChanged: (v) => setState(() => selectedType = v!),
                ),
              ],
            ),

            // Chọn thời gian bắt đầu
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Thời gian bắt đầu:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final selected = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selected != null) {
                          setState(() {
                            startTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              selected.hour,
                              selected.minute,
                            );
                          });
                        }
                      },
                      child: const Text("Đặt thời gian"),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      startTime != null
                          ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}"
                          : "Chưa đặt",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: startTime != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Tab Switcher ---
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: double.infinity,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false, // 👈 bắt buộc để tab chiếm đều
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black87,
                  indicator: BoxDecoration(
                    color: AppColors.primary_button,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab, // 👈 quan trọng để chiếm full nửa tab
                  tabs: const [
                    Tab(text: "Nút"),
                    Tab(text: "Nhập tay"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- Tab Contents ---
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // --- TIMER MODE ---
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                formatTime(leftSeconds),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary_button,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                formatTime(rightSeconds),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary_button,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Buttons điều khiển
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSideButton("TRÁI", leftRunning, () => _toggleTimer('left')),
                          _buildSideButton("PHẢI", rightRunning, () => _toggleTimer('right')),
                        ],
                      ),
                    ],
                  ),

                  // --- MANUAL ENTRY MODE ---
                  _buildManualEntry(),
                ],
              ),
            ),

            // --- SAVE BUTTON ---
            ElevatedButton.icon(
              onPressed: _saveFeeding,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_button,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: const Text(
                "Lưu lại",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntry() {

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [

          GestureDetector(
            onTap: () => _pickDuration(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bú vú trái (phút:giây)",
                    style: TextStyle( fontSize: 15),
                  ),
                  Text(
                    "${_leftDuration.inMinutes.toString().padLeft(2, '0')}:${(_manualDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _pickDuration(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bú vú phải (phút:giây)",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "${_rightDuration.inMinutes.toString().padLeft(2, '0')}:${(_manualDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: "Notes",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton(String label, bool isRunning, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFC8B8), // hồng nhạt pastel
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isRunning ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Duration Picker
  Duration _manualDuration = const Duration(minutes: 0, seconds: 0);

  Future<void> _pickDuration(BuildContext context) async {
    int minutes = _manualDuration.inMinutes;
    int seconds = _manualDuration.inSeconds % 60;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Duration",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minutes picker
                      DropdownButton<int>(
                        value: minutes,
                        items: List.generate(
                          60,
                              (i) => DropdownMenuItem(
                            value: i,
                            child: Text("$i min"),
                          ),
                        ),
                        onChanged: (v) =>
                            setModalState(() => minutes = v ?? minutes),
                      ),
                      const SizedBox(width: 30),
                      // Seconds picker
                      DropdownButton<int>(
                        value: seconds,
                        items: List.generate(
                          60,
                              (i) => DropdownMenuItem(
                            value: i,
                            child: Text("$i sec"),
                          ),
                        ),
                        onChanged: (v) =>
                            setModalState(() => seconds = v ?? seconds),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _manualDuration = Duration(
                          minutes: minutes,
                          seconds: seconds,
                        );
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary_button,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Done", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
