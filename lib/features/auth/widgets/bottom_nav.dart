import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (index == 3) {
      // SOS chỉ mở dialer, không chuyển trang
      final Uri callUri = Uri(scheme: 'tel', path: '113');

      if (await canLaunchUrl(callUri)) {
        await launchUrl(
          callUri,
          mode: LaunchMode.externalApplication, // mở dialer thật
        );
      } else {
        throw 'Không mở được ứng dụng gọi điện';
      }
      return; // đảm bảo không chạy Navigator nữa
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
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám phá"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Em bé"),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: "Khẩn cấp"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Thông tin",
          ),
        ],
      ),
    );
  }
}
