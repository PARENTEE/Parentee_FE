import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class DiaperChangePage extends StatefulWidget {
  final String childId;

  const DiaperChangePage({super.key, required this.childId});

  @override
  State<DiaperChangePage> createState() => _DiaperChangePageState();
}

class _DiaperChangePageState extends State<DiaperChangePage> {
  DateTime? changedTime = DateTime.now();
  int selectedType = 0;
  double quantity = 1;
  String? selectedColor;
  int selectedConsistency = 0;
  final notesController = TextEditingController();

  final types = ["Khô", "Tiểu", "Phân", "Cả hai"];

  final colors = [
    Colors.yellow,
    Colors.brown,
    Colors.black,
    Colors.green,
    Colors.red,
  ];

  final consistencies = [
    {"label": "Cứng", "icon": Icons.circle},
    {"label": "Lỏng", "icon": Icons.blur_circular},
    {"label": "Nước", "icon": Icons.water_drop},
    {"label": "Nhầy", "icon": Icons.waves},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thay tã"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Start time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Thời gian thay:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selected != null) {
                      setState(() {
                        changedTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          selected.hour,
                          selected.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    changedTime != null
                        ? "Today, ${changedTime!.hour.toString().padLeft(2, '0')}:${changedTime!.minute.toString().padLeft(2, '0')}"
                        : "Set time",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Loại tã
            const Text(
              "Thay cho vì tã:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(types.length, (index) {
                final isSelected = selectedType == index;
                final type = types[index];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? AppColors.primary_button : Colors.grey.shade200,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => setState(() => selectedType = index),
                      child: Text(type),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Quantity
            const Text(
              "Lượng thải:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Slider(
              value: quantity,
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (v) => setState(() => quantity = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("Ít"), Text("Thường"), Text("Nhiều")],
            ),

            const SizedBox(height: 24),

            // Color
            const Text(
              "Màu:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  colors.map((c) {
                    return GestureDetector(
                      onTap:
                          () => setState(
                            () => selectedColor = c.value.toString(),
                          ),
                      child: CircleAvatar(
                        backgroundColor: c,
                        radius: 20,
                        child:
                            selectedColor == c.value.toString()
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Consistency
            const Text(
              "Chất lượng:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(consistencies.length, (index) {
                final c = consistencies[index];
                final isSelected = selectedConsistency == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedConsistency = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            isSelected ? Colors.green : Colors.grey.shade200,
                        child: Icon(
                          c["icon"] as IconData,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c["label"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.green : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Notes
            const Text(
              "Notes:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: "Thêm notes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Save button
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_button,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: saveDiaperChange,
              child: const Text(
                "Lưu lại",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveDiaperChange() async {
    final response = await ChildService.createDiaperChangeRecord(context, {
      "childId": widget.childId,
      "changedAt": changedTime?.toUtc().toIso8601String(),
      "type": selectedType,
      "diaperQuantity": quantity.toInt(),
      "color": selectedColor,
      "diaperWaste": selectedConsistency,
      "notes": notesController.text,
    });

    // SUCCESS
    if(response.success){
      PopUpToastService.showSuccessToast(context, "Thêm thay tã thành công");
      Navigator.pop(context);
    }
    // FAILED
    else {
      PopUpToastService.showErrorToast(context, "Thêm thay tã không thành công");
    }
  }
}
