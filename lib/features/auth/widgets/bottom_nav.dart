import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Widget child;
  const BottomNav({super.key, required this.child});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<String> _routes = ["/home", "/explore", "/baby", "/sos", "/info"];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Điều hướng tới route tương ứng
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
