import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart'; // dùng màu chính của app

class AddSolidFoodPage extends StatefulWidget {
  final String childId;
  const AddSolidFoodPage({super.key, required this.childId});

  @override
  State<AddSolidFoodPage> createState() => _AddSolidFoodPageState();
}

class _AddSolidFoodPageState extends State<AddSolidFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _image;
  DateTime _selectedDateTime = DateTime.now();

  String _selectedUnit = "g";
  final List<String> _units = ["g", "ml", "tbsp", "tsp", "pieces"];

  final Map<String, int> unitMap = {
    "g": 0,
    "ml": 1,
    "tbsp": 2,
    "tsp": 3,
    "pieces": 4,
  };

  final List<String> _presets = [
    "Chuối nghiền",
    "Bơ nghiền",
    "Bột gạo",
    "Khoai lang nghiền",
    "Bí đỏ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ăn dặm",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: const Text("Lưu", style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Tên món ăn"),
              _buildTextField(
                controller: _foodController,
                hint: "Nhập tên món ăn (vd: Chuối, Táo nghiền)",
              ),
              const SizedBox(height: 16),

              _buildLabel("Số lượng & đơn vị"),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _amountController,
                      hint: "Nhập số lượng",
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildDropdown(
                      value: _selectedUnit,
                      items: _units,
                      onChanged: (val) =>
                          setState(() => _selectedUnit = val ?? "g"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildLabel("Thời gian"),
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat.yMMMd().add_jm().format(_selectedDateTime)),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel("Ghi chú"),
              _buildTextField(
                controller: _noteController,
                hint: "Nhập ghi chú (tuỳ chọn)",
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              _buildLabel("Gợi ý nhanh"),
              Wrap(
                spacing: 8,
                children: _presets.map((p) {
                  return ActionChip(
                    label: Text(p),
                    onPressed: () => setState(() {
                      _foodController.text = p;
                    }),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle:
                    const TextStyle(color: Colors.black87, fontSize: 13),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_button,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveEntry,
                  child: const Text("Lưu món ăn", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickDateTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      // Giữ nguyên ngày hôm nay, chỉ thay giờ phút
      final now = DateTime.now();
      _selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }



  void _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    // Lấy dữ liệu từ form
    final name = _foodController.text.trim();
    final quantity = double.tryParse(_amountController.text) ?? 0;
    final int unitValue = unitMap[_selectedUnit] ?? 0;
    final notes = _noteController.text.trim();

    // Gửi request
    final requestBody = {
      "childId": widget.childId,
      "ateAt": _selectedDateTime.toUtc().toIso8601String(),
      "name": name,
      "quantity": quantity,
      "unit": unitValue,
      "notes": notes,
    };

    debugPrint("📤 Sending: $requestBody");

    final response = await ChildService.createSolidFood(context, requestBody);

    if (response.success) {
      Navigator.pop(context);
      PopUpToastService.showSuccessToast(context, "Cho bé ăn thành công");
    } else {
      PopUpToastService.showErrorToast(context, "Cho bé ăn không thành công");
    }
  }
}
