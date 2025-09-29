import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/SearchPage/search_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> recentSearches = [];
  final List<String> popularSearches = [
    "Sốt",
    "Cảm cúm",
    "Ho",
    "Dinh dưỡng",
    "Tiêm chủng",
  ];

  @override
  void initState() {
    super.initState();
    // Tự bật bàn phím khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _onSearch(String keyword) {
    if (keyword.isEmpty) return;
    setState(() {
      // Nếu đã có thì xóa đi để thêm mới nhất lên đầu
      recentSearches.remove(keyword);
      recentSearches.insert(0, keyword);
      // Giữ tối đa 5 kết quả
      if (recentSearches.length > 5) {
        recentSearches = recentSearches.sublist(0, 5);
      }
    });

    // Chuyển sang trang detail
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchDetailPage(keyword: keyword)),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: "Tìm kiếm...",
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(_controller.text),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent searches
            if (recentSearches.isNotEmpty) ...[
              const Text(
                "Tìm kiếm gần đây",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final item = recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.history, size: 18),
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          recentSearches.removeAt(index);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchDetailPage(keyword: item),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // Popular searches
            const Text(
              "Tìm kiếm phổ biến",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  popularSearches.map((item) {
                    return ActionChip(
                      label: Text(item),
                      onPressed: () {
                        _onSearch(item);
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
