import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/CallPage/hospital_detail_page.dart';

import '../../models/hospital.dart';

class HospitalListPage extends StatelessWidget {
  final List<Hospital> hospitals;
  const HospitalListPage({super.key, required this.hospitals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách bệnh viện"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          final hospital = hospitals[index];
          return ListTile(
            title: Text(hospital.name),
            subtitle: Text(hospital.address),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HospitalDetailPage(hospital: hospitals[0]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
