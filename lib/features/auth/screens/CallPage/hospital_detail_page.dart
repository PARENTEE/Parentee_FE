import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/models/hospital.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalDetailPage extends StatelessWidget {
  final Hospital hospital;
  const HospitalDetailPage({super.key, required this.hospital});

  Future<void> _call(BuildContext context, String phone) async {
    final Uri callUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không mở được ứng dụng gọi điện")),
      );
    }
  }

  /// Hàm load ảnh: hỗ trợ cả asset và network
  Widget _buildHospitalImage(String url) {
    if (url.startsWith("http")) {
      return Image.network(
        url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                Container(height: 220, color: Colors.grey.shade300),
      );
    } else {
      return Image.asset(
        url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hospital.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Hình ảnh bệnh viện
            ClipRRect(child: _buildHospitalImage(hospital.imageUrl)),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Giới thiệu
                  Text(
                    hospital.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  /// Box cảnh báo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange.shade50,
                      boxShadow: const [],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Trong trường hợp khẩn cấp, hãy liên hệ ngay số điện thoại bệnh viện để được hỗ trợ.",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Thông tin chi tiết
                  const Text(
                    "Thông tin bệnh viện:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: Text(hospital.address),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: Text(hospital.phone),
                      trailing: ElevatedButton.icon(
                        onPressed: () => _call(context, hospital.phone),
                        icon: const Icon(Icons.call),
                        label: const Text("Gọi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
