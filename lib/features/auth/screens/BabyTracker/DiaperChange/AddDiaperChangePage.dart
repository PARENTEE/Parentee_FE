import 'package:flutter/material.dart';

class DiaperChangePage extends StatefulWidget {
  const DiaperChangePage({super.key});

  @override
  State<DiaperChangePage> createState() => _DiaperChangePageState();
}

class _DiaperChangePageState extends State<DiaperChangePage> {
  String selectedType = "Poo";
  DateTime? startTime = DateTime.now();
  double quantity = 1;
  String? selectedColor;
  String? selectedConsistency;
  final notesController = TextEditingController();

  final colors = [
    Colors.yellow,
    Colors.brown,
    Colors.black,
    Colors.green,
    Colors.red,
    Colors.grey,
  ];

  final consistencies = [
    {"label": "Solid", "icon": Icons.circle},
    {"label": "Loose", "icon": Icons.blur_circular},
    {"label": "Runny", "icon": Icons.water_drop},
    {"label": "Mucusy", "icon": Icons.waves},
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
            // Loại tã
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var type in ["Dry", "Pee", "Poo", "Both"])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedType == type
                              ? Colors.green
                              : Colors.grey.shade200,
                          foregroundColor: selectedType == type
                              ? Colors.white
                              : Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => setState(() => selectedType = type),
                        child: Text(type),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Start time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Start Time:",
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
                  child: Text(
                    startTime != null
                        ? "Today, ${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}"
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

            // Quantity
            const Text(
              "Quantity (optional)",
              style: TextStyle(fontWeight: FontWeight.w600),
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
              children: const [
                Text("Small"),
                Text("Medium"),
                Text("Large"),
              ],
            ),

            const SizedBox(height: 24),

            // Color
            const Text(
              "Color (optional)",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: colors.map((c) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = c.value.toString()),
                  child: CircleAvatar(
                    backgroundColor: c,
                    radius: 20,
                    child: selectedColor == c.value.toString()
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Consistency
            const Text(
              "Consistency (optional)",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: consistencies.map((c) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => selectedConsistency = c["label"] as String),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                        selectedConsistency == c["label"] ? Colors.green : Colors.grey.shade200,
                        child: Icon(
                          c["icon"] as IconData,
                          color: selectedConsistency == c["label"]
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(c["label"] as String,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Notes
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: "Add notes (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved diaper log ✅")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(32),
                ),
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
