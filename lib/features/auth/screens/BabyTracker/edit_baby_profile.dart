import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/baby_profile.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class EditBabyProfilePage extends StatefulWidget {
  final String childId;

  const EditBabyProfilePage({
    super.key,
    required this.childId,
  });

  @override
  State<EditBabyProfilePage> createState() => _EditBabyProfilePageState();
}

class _EditBabyProfilePageState extends State<EditBabyProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController heightValueController = TextEditingController();
  final TextEditingController weightValueController = TextEditingController();
  DateTime? selectedBirthDate;

  String gender = "Trai";
  String? selectedAge;
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "kg";

  final List<String> ages = List.generate(12, (i) => "${i + 1} tháng");
  final List<String> heightUnits = ["cm"];
  final List<String> weightUnits = ["kg"];

  @override
  void initState() {
    super.initState();

    if (widget.childId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadChildData();
      });
    }
  }

  Future<void> _loadChildData() async {
     final response = await ChildService.getChildById(context, widget.childId);

      final data = response.data;
      if (data != null) {
        setState(() {
          fullNameController.text = data["fullName"] ?? "";
          heightValueController.text = data["height"].toString();
          weightValueController.text = data["weight"].toString();
          selectedBirthDate = DateTime.tryParse(data["birthDate"] ?? "");
          gender = (data["gender"] == 0) ? "Trai" : "Gái";
        });
      }
      else PopUpToastService.showErrorToast(context, "Không tải được dữ liệu bé");

  }

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
            _buildInput("Họ và tên", "Nhập họ và tên", fullNameController),
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
            // _buildLabel("Độ tuổi"),
            // _buildDropdown(
            //   value: selectedAge,
            //   hint: "Chọn độ tuổi",
            //   items: ages,
            //   onChanged: (val) => setState(() => selectedAge = val),
            // ),
            // const SizedBox(height: 16),

            // Ngày sinh
            _buildLabel("Ngày sinh"),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  selectedBirthDate != null
                      ? "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}"
                      : "Chọn ngày sinh",
                  style: TextStyle(
                    color: selectedBirthDate != null ? Colors.black87 : Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
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
                  _saveChild();
                  debugPrint("Tên: ${fullNameController.text}");
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
      keyboardType: inputType == TextInputType.number
          ? const TextInputType.numberWithOptions(decimal: true)
          : inputType,
      inputFormatters: inputType == TextInputType.text
          ? [] // Nhận tất cả ký tự
          : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  void _saveChild() async {
    var data = {
      "fullName": fullNameController.text.trim(),
      "birthDate": selectedBirthDate?.toIso8601String().split('T').first,
      "gender": gender == "Trai" ? 0 : 1,
      "height": double.tryParse(heightValueController.text),
      "weight": double.tryParse(weightValueController.text),
      "notes": "string"
    };

    // Call API
    ApiResponse response = widget.childId.isEmpty ?
        await ChildService.createChild(context, data) :
        await ChildService.updateChild(context, widget.childId, data);

    if(response.success){
      PopUpToastService.showSuccessToast(context, "Tạo em bé thành công");

      if(widget.childId.isNotEmpty) Navigator.pop(context);
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BabyProfilePage(children: [])
          ),
        );
      }

    }
    else {
      PopUpToastService.showErrorToast(context, "Tạo em bé không thành công");
    }

  }
}
