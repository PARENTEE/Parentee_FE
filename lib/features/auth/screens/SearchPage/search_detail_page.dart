import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDetailPage extends StatelessWidget {
  final String keyword;

  const SearchDetailPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết"), centerTitle: true),
      body: Center(
        child: Text(
          "Kết quả chi tiết cho: $keyword",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
