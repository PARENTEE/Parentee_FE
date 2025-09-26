import 'package:flutter/material.dart';

class EditBabyProfilePage extends StatefulWidget {
  const EditBabyProfilePage({super.key});

  @override
  State<EditBabyProfilePage> createState() => _EditBabyProfilePageState();
}

class _EditBabyProfilePageState extends State<EditBabyProfilePage> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController heightValueController = TextEditingController();
  final TextEditingController weightValueController = TextEditingController();

  String gender = "Trai"; // mặc định
  String? selectedAge;
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "kg";

  final List<String> ages = List.generate(20, (i) => "${i + 1} tuổi");
  final List<String> heightUnits = ["cm", "inch"];
  final List<String> weightUnits = ["kg", "lbs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar + nút đổi ảnh
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/images/nutrient.png"),
            ),
            const SizedBox(height: 12),
            const Text(
              "Bata Bean",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Đổi ảnh đại diện",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Họ và tên
            _buildInput("Họ", "Nhập họ", lastNameController),
            const SizedBox(height: 14),
            _buildInput("Tên", "Nhập tên", firstNameController),
            const SizedBox(height: 14),

            // Giới tính
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Giới tính",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => gender = "Trai"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            gender == "Trai"
                                ? Colors.blue.shade100
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              gender == "Trai"
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: const Center(child: Text("👦 Trai")),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => gender = "Gái"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            gender == "Gái"
                                ? Colors.pink.shade100
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              gender == "Gái"
                                  ? Colors.pink
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: const Center(child: Text("👧 Gái")),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Độ tuổi
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Độ tuổi",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedAge,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              hint: const Text("Chọn độ tuổi"),
              items:
                  ages.map((age) {
                    return DropdownMenuItem(value: age, child: Text(age));
                  }).toList(),
              onChanged: (value) => setState(() => selectedAge = value),
            ),

            const SizedBox(height: 14),

            // Chiều cao
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chiều cao",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: heightValueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Nhập chiều cao",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedHeightUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    items:
                        heightUnits.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() => selectedHeightUnit = value!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Cân nặng
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Cân nặng",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: weightValueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Nhập cân nặng",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedWeightUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    items:
                        weightUnits.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() => selectedWeightUnit = value!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
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
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
