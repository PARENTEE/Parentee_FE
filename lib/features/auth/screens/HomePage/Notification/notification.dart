import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/models/invitation.dart';
import 'package:parentee_fe/services/family_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:parentee_fe/services/utils_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    _fetchInvitations();
  }

  // Danh sách thông báo (demo)
  List<Map<String, dynamic>> notifications = [
    // {
    //   "title": "Lời mời tham gia gia đình",
    //   "time": "5 phút trước",
    //   "message":
    //       "Nguyễn Minh mời bạn tham gia gia đình của anh ấy với vai trò 'Vợ'.",
    //   "icon": Icons.favorite,
    //   "color": Colors.pinkAccent,
    //   "isInvite": true, // 👈 đánh dấu đây là thông báo lời mời
    //   "inviterName": "Nguyễn Minh",
    //   "familyId": "abc123",
    // },
    // {
    //   "title": "Hệ thống",
    //   "time": "1 giờ trước",
    //   "message":
    //       "Tài khoản của bạn đã được cập nhật thành công. Vui lòng đăng nhập lại để đồng bộ dữ liệu.",
    //   "icon": Icons.groups,
    //   "color": Colors.redAccent,
    // },
    // {
    //   "title": "Báo cáo của bé yêu",
    //   "time": "2 giờ trước",
    //   "message":
    //       "Hôm nay bé đã ngủ đủ giấc 8 tiếng và uống được 500ml sữa. Bé đang phát triển tốt!",
    //   "icon": Icons.child_care,
    //   "color": Colors.orangeAccent,
    // },
    // {
    //   "title": "Đến giờ cho bé bú",
    //   "time": "3 tuần trước",
    //   "message":
    //       "Đã đến khung giờ cho bé bú. Hãy chuẩn bị bình sữa hoặc cho bé bú mẹ nhé.",
    //   "icon": Icons.baby_changing_station,
    //   "color": Colors.pinkAccent,
    // },
    // {
    //   "title": "Đến giờ bé ngủ",
    //   "time": "3 tuần trước",
    //   "message":
    //       "Đã tới giờ ngủ trưa. Bạn nên tạo không gian yên tĩnh để bé dễ dàng đi vào giấc ngủ.",
    //   "icon": Icons.nightlight_round,
    //   "color": Colors.amber,
    // },
    // {
    //   "title": "Một ngày tốt cho bé",
    //   "time": "3 tuần trước",
    //   "message":
    //       "Thời tiết hôm nay rất đẹp, hãy đưa bé ra ngoài vận động nhẹ để tăng cường sức khỏe.",
    //   "icon": Icons.wb_sunny,
    //   "color": Colors.deepOrangeAccent,
    // },
  ];

  Future<void> _fetchInvitations() async {
    final result = await FamilyService.getInvitation();
    if(!result.success){
      PopUpToastService.showErrorToast(context, result.message.toString());
      return;
    }

    final List<dynamic> data = result.data;
    final List<Map<String, dynamic>> inviteNotifications = data.map((e) {
      final invitation = Invitation.fromJson(e);
      return {
        "title": "Lời mời tham gia gia đình",
        "time": UtilsService.formatTime(invitation.createdAt),
        "message":
        "${invitation.inviterName} mời bạn tham gia gia đình của họ với vai trò '${invitation.role == "Father" ? "Bố" : "Mẹ"}'.",
        "icon": Icons.favorite,
        "color": Colors.pinkAccent,
        "isInvite": true,
        "inviterName": invitation.inviterName,
        "userFamilyRoleId": invitation.userFamilyRoleId, // you might change to familyId if available
      };
    }).toList();

    setState(() {
      notifications = inviteNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã xóa tất cả thông báo")),
              );
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              "Xóa tất cả",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];
          final bool isInvite = item["isInvite"] == true;

          return Dismissible(
            key: ValueKey(item["title"] + item["time"]),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            onDismissed: (_) {
              setState(() {
                notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đã xóa ${item["title"]}")),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: (item["color"] as Color).withOpacity(0.15),
                    child: Icon(item["icon"], color: item["color"], size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["time"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["message"],
                          style: const TextStyle(fontSize: 14, height: 1.3),
                        ),
                        if (isInvite) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text("Đồng ý"),
                                  onPressed: () {
                                    _handleInviteAction(context, item, true);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text("Từ chối"),
                                  onPressed: () {
                                    _handleInviteAction(context, item, false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleInviteAction(BuildContext context, Map<String, dynamic> item, bool accepted) async {
    final inviter = item["inviterName"];
    final userFamilyRoleId = item["userFamilyRoleId"];

    // show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await FamilyService.updateInvitation(userFamilyRoleId, accepted);

    Navigator.pop(context);

    setState(() {
      notifications.remove(item);
    });

    if (result.success) {
      PopUpToastService.showSuccessToast(context, "Bạn đã chấp nhận lời mời từ $inviter.");
    } else {
      PopUpToastService.showErrorToast(context,"Bạn đã từ chối lời mời từ $inviter.");
    }
  }
}
