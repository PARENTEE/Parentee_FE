import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/data/hospital_data.dart';
import 'package:parentee_fe/features/auth/models/child.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/baby_preview_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/baby_profile.dart';
import 'package:parentee_fe/features/auth/screens/CallPage/hospital_list_page.dart';
import 'package:parentee_fe/features/auth/screens/UserProfile/profile.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

import '../screens/SearchPage/search_page.dart';

class BottomNav extends StatefulWidget {
  final Widget child;
  const BottomNav({super.key, required this.child});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<String> _routes = ["/home", "/explore", "/baby", "/sos", "/info"];

  void _onTap(int index) async {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage()));
    }

    if (index == 2) {
      // 1. Get children in current family
      final response = await ChildService.getChildrenInCurrentFamily(context);

      if(response.success){
        final List<dynamic>? data = response.data;

        final List<Child> children = (data != null && data.isNotEmpty)
            ? data.map((e) => Child.fromJson(e)).toList()
            : [];

        // 2. If there are, navigate to Baby profile page
        if(!children.isEmpty){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BabyProfilePage(children: children),
            ),
          );
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BabyPreviewPage(),
            ),
          );
        }
      }
      else if(!response.success){
        print("ERROR: ${response.message}");
        PopUpToastService.showErrorToast(context, "Lấy thông tin các bé không thành công.");
      }
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HospitalListPage(hospitals: hospitals),
        ),
      );
      return;
    }
    if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary_button,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám phá"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Em bé"),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: "Khẩn cấp"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: "Thông tin",
          ),
        ],
      ),
    );
  }
}
