import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/MedicinePage/medicine_dashboard.dart';

class EditBabyProfilePage extends StatefulWidget {
  final bool useToCreate;

  const EditBabyProfilePage({
    super.key,
    required this.useToCreate,
  });

  @override
  State<EditBabyProfilePage> createState() => _EditBabyProfilePageState();
}

class _EditBabyProfilePageState extends State<EditBabyProfilePage> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController heightValueController = TextEditingController();
  final TextEditingController weightValueController = TextEditingController();

  String gender = "Trai";
  String? selectedAge;
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "kg";

  final List<String> ages = List.generate(12, (i) => "${i + 1} tháng");
  final List<String> heightUnits = ["cm"];
  final List<String> weightUnits = ["kg"];

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
          "Bé yêu",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/images/nutrient.png"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Bata Bean",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Họ và Tên
            _buildInput("Họ", "Nhập họ", lastNameController),
            const SizedBox(height: 16),
            _buildInput("Tên", "Nhập tên", firstNameController),
            const SizedBox(height: 16),

            // Giới tính
            _buildLabel("Giới tính"),
            Row(
              children: [
                Expanded(child: _buildGenderCard("Trai", "👦", Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildGenderCard("Gái", "👧", Colors.pink)),
              ],
            ),
            const SizedBox(height: 16),

            // Độ tuổi
            _buildLabel("Độ tuổi"),
            _buildDropdown(
              value: selectedAge,
              hint: "Chọn độ tuổi",
              items: ages,
              onChanged: (val) => setState(() => selectedAge = val),
            ),
            const SizedBox(height: 16),

            // Chiều cao
            _buildLabel("Chiều cao"),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: heightValueController,
                    hint: "Nhập chiều cao",
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildDropdown(
                    value: selectedHeightUnit,
                    items: heightUnits,
                    onChanged:
                        (val) =>
                            setState(() => selectedHeightUnit = val ?? "cm"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cân nặng
            _buildLabel("Cân nặng"),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: weightValueController,
                    hint: "Nhập cân nặng",
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildDropdown(
                    value: selectedWeightUnit,
                    items: weightUnits,
                    onChanged:
                        (val) =>
                            setState(() => selectedWeightUnit = val ?? "kg"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Save button
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
                onPressed: () {
                  debugPrint("Họ: ${lastNameController.text}");
                  debugPrint("Tên: ${firstNameController.text}");
                  debugPrint("Giới tính: $gender");
                  debugPrint("Tuổi: $selectedAge");
                  debugPrint(
                    "Chiều cao: ${heightValueController.text} $selectedHeightUnit",
                  );
                  debugPrint(
                    "Cân nặng: ${weightValueController.text} $selectedWeightUnit",
                  );
                },
                child: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        _buildTextField(controller: controller, hint: hint),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? hint,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      hint: hint != null ? Text(hint) : null,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildGenderCard(String value, String emoji, Color activeColor) {
    final bool isSelected = gender == value;
    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            "$emoji $value",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? activeColor : AppColors.primary_button,
            ),
          ),
        ),
      ),
    );
  }
}
