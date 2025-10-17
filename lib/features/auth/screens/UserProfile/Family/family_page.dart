import 'package:flutter/material.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final List<Map<String, dynamic>> _partners = [
    {
      "name": "Nguyễn Thảo",
      "role": "Vợ",
      "avatar": "https://i.pravatar.cc/150?img=10"
    },
  ];

  final List<Map<String, dynamic>> _children = [
    {
      "name": "Bé An",
      "age": 0,
      "gender": "Nam",
      "avatar": "https://i.pravatar.cc/150?img=3"
    },
    {
      "name": "Bé Linh",
      "age": 0,
      "gender": "Nữ",
      "avatar": "https://i.pravatar.cc/150?img=5"
    },
  ];

  final List<Map<String, dynamic>> _users = [
    {"name": "Nguyễn An", "avatar": "https://i.pravatar.cc/150?img=1"},
    {"name": "Trần Bình", "avatar": "https://i.pravatar.cc/150?img=2"},
    {"name": "Phạm Chi", "avatar": "https://i.pravatar.cc/150?img=3"},
    {"name": "Lê Duyên", "avatar": "https://i.pravatar.cc/150?img=4"},
    {"name": "Hoàng Nam", "avatar": "https://i.pravatar.cc/150?img=5"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gia đình")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Vợ / Chồng -----
            const Text(
              "Vợ / Chồng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ..._partners.map((p) => buildProfileCard(context, p)),

            const SizedBox(height: 20),

            // ----- Các con -----
            const Text(
              "Các con",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ..._children.map((child) => buildProfileCard(context, child)),
          ],
        ),
      ),

      // Nút mời thành viên
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInviteDialog(context),
        child: const Icon(Icons.email),
      ),
    );
  }

  Widget buildProfileCard(BuildContext context, Map<String, dynamic> member) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(member["avatar"]),
          radius: 25,
        ),
        title: Text(
          member["name"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: member.containsKey("age")
            ? Text("Tuổi: ${member["age"]} tháng • Giới tính: ${member["gender"]}")
            : Text(member["role"]),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        final ScrollController scrollController = ScrollController();

        return StatefulBuilder(
          builder: (context, setState) {
            final filteredUsers = _users
                .where((user) => user["name"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              title: const Text("Mời thành viên làm vợ/chồng"),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm thành viên...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (value) => setState(() {
                        searchQuery = value;
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Scrollable list with scrollbar
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user["avatar"]),
                                ),
                                title: Text(user["name"]),
                                trailing: ElevatedButton.icon(
                                  icon: const Icon(Icons.mail_outline, size: 18),
                                  label: const Text("Mời"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Đã gửi lời mời tới ${user["name"]}"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
