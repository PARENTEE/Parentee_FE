import 'package:flutter/material.dart';
import 'add_food.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({super.key});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  Map<String, dynamic>? foodData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Theo Dõi Dinh Dưỡng",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (foodData == null) ...[
              const Text("Chưa có dữ liệu"),
              const SizedBox(height: 20),
            ] else ...[
              // tên món
              Text(
                foodData!["food"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // ảnh minh họa (có thể thay đổi tùy món)
              Image.asset("assets/images/food.png", width: 200, height: 200),
              const SizedBox(height: 20),

              // calo (tạm fix cứng 1B, hoặc bạn có thể thêm input calo ở AddFoodPage)
              Text("Lượng calo: 1B", style: const TextStyle(fontSize: 16)),

              // số lượng
              Text(
                "Số lượng: ${foodData!["quantity"]}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              // note
              if (foodData!["note"] != null && foodData!["note"].isNotEmpty)
                Text(
                  foodData!["note"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              const Spacer(),
            ],

            // Button thêm món
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFoodPage(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      foodData = result;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE57373),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  foodData == null ? "Thêm thức ăn" : "Thêm món khác",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
