import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/models/family.dart';
import 'package:parentee_fe/features/auth/models/family_user.dart';
import 'package:parentee_fe/features/auth/models/user.dart';
import 'package:parentee_fe/services/family_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class FamilyPage extends StatefulWidget {
  final Family family;

  const FamilyPage({super.key, required this.family});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final List<Map<String, dynamic>> _partners = [
    {
      "name": "Nguyễn Thảo",
      "role": "Vợ",
      "avatar": "https://i.pravatar.cc/150?img=10",
    },
  ];

  final List<Map<String, dynamic>> _children = [
    {
      "name": "Bé An",
      "age": 0,
      "gender": "Nam",
      "avatar": "https://i.pravatar.cc/150?img=3",
    },
    {
      "name": "Bé Linh",
      "age": 0,
      "gender": "Nữ",
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
  ];


  @override
  Widget build(BuildContext context) {
    final family = widget.family;

    return Scaffold(
      appBar: AppBar(title: const Text("Gia đình")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Thành viên -----
            const Text(
              "Thành viên",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...family.familyUsers
                .where((member) => (member.invitationStatus == 0))
                .map((member) => buildProfileCard(context, member)),

            const SizedBox(height: 20),

            // // ----- Các con -----
            // const Text(
            //   "Các con",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const Divider(),
            // ..._children.map((child) => buildChildrenCard(context, child)),
            //
            // const SizedBox(height: 20),

            // ----- Đã mời -----
            const Text(
              "Đã mời",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...family.familyUsers
                .where((member) => (member.invitationStatus == 1))
                .map((member) => buildProfileCard(context, member)),
          ],
        ),
      ),

      // Nút mời thành viên
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInviteDialog(context, family.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildProfileCard(BuildContext context, FamilyUser member) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            // fallback: use pravatar with email seed if no avatar URL exists
            "https://i.pravatar.cc/150?u=${member.email}",
          ),
          radius: 25,
        ),
        title: Text(
          member.fullName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${member.familyRole} • Giới tính: ${_getGenderText(member.gender)}",
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget buildChildrenCard(BuildContext context, Map<String, dynamic> member) {
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
        subtitle:
            member.containsKey("age")
                ? Text(
                  "Tuổi: ${member["age"]} tháng • Giới tính: ${member["gender"]}",
                )
                : Text(member["role"]),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  /// Helper method to convert gender enum/int to readable text
  String _getGenderText(dynamic gender) {
    if (gender is int) {
      // Example: 0 = Male, 1 = Female — adjust to your actual enum
      return gender == 0 ? "Nam" : "Nữ";
    } else if (gender.toString().toLowerCase().contains("male")) {
      return "Nam";
    } else if (gender.toString().toLowerCase().contains("female")) {
      return "Nữ";
    } else {
      return "Khác";
    }
  }

  void _showInviteDialog(BuildContext context, String familyId) async {
    final result = await FamilyService.getUserWithNoFamily();
    if (!result.success || result.data == null) {
      PopUpToastService.showErrorToast(context, "Không thể lấy danh sách người dùng.");
      return;
    }

    // Safely parse result into User list
    final users = (result.data as List)
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        final ScrollController scrollController = ScrollController();

        return StatefulBuilder(
          builder: (context, setState) {
            // Filter by name or email
            final filteredUsers = users.where((user) {
              final query = searchQuery.toLowerCase();
              return user.fullName.toLowerCase().contains(query) ||
                  user.email.toLowerCase().contains(query);
            }).toList();

            return AlertDialog(
              title: const Text("Mời làm thành viên"),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // 🔍 Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm thành viên...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (value) => setState(() {
                        searchQuery = value;
                      }),
                    ),
                    const SizedBox(height: 12),

                    // 📜 Scrollable user list
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        radius: const Radius.circular(10),
                        child: filteredUsers.isEmpty
                            ? const Center(
                          child: Text(
                            "Không có thành viên nào để mời",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                            : ListView.builder(
                          controller: scrollController,
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                dense: true, // Giảm khoảng cách trong ListTile
                                minLeadingWidth: 36, // Tránh bị chiếm quá nhiều chỗ từ avatar
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://i.pravatar.cc/150?u=${user.email}",
                                  ),
                                ),
                                title: Text(
                                  user.fullName,
                                  maxLines: 1, // ✅ Chỉ 1 dòng
                                  overflow: TextOverflow.ellipsis, // ✅ Nếu dài quá -> "..."
                                ),
                                subtitle: Text(
                                  user.email,
                                  maxLines: 1, // ✅ Đảm bảo 1 dòng
                                  overflow: TextOverflow.ellipsis, // ✅ Không xuống dòng
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    _showRoleSelectDialog(context, familyId, user);
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

  void _showRoleSelectDialog(BuildContext context, String familyId, User user) {
    int? selectedRole;
    final List<Map<String, dynamic>> roles = [
      {"label": "Bố", "value": 0},
      {"label": "Mẹ", "value": 1},
      {"label": "Khác", "value": 2},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Chọn vai trò cho ${user.fullName}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: "Vai trò",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: selectedRole,
                    items: roles
                        .map(
                          (role) => DropdownMenuItem<int>(
                        value: role["value"],
                        child: Text(role["label"]),
                      ),
                    )
                        .toList(),
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Gửi lời mời"),
                    onPressed: selectedRole == null
                        ? null
                        : () async {
                      // Check đã chọn role
                      if(selectedRole == null){
                        PopUpToastService.showErrorToast(context, "Xin hãy chọn vai trò");
                        return;
                      }

                      // Send invitation API
                      final result = await FamilyService.sendInvitation(familyId, user.id, selectedRole!);
                      if (result.success) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        PopUpToastService.showSuccessToast(context, "Đã gửi lời mời tới ${user.fullName} với vai trò ${roles.firstWhere((r) => r["value"] == selectedRole)["label"]}");
                      }
                      else {
                        PopUpToastService.showErrorToast(context, result.message.toString());
                        return;
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
