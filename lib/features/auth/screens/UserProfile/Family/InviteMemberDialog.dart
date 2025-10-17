import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InviteMemberDialog extends StatefulWidget {
  const InviteMemberDialog({super.key});

  @override
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Mời thành viên gia đình"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // chọn vai trò
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Vai trò",
                border: OutlineInputBorder(),
              ),
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: "Vợ / Chồng", child: Text("Vợ / Chồng")),
                DropdownMenuItem(value: "Người chăm sóc", child: Text("Người chăm sóc")),
              ],
              onChanged: (value) {
                setState(() => _selectedRole = value);
              },
              validator: (value) =>
              value == null ? "Vui lòng chọn vai trò" : null,
            ),
            const SizedBox(height: 12),

            // nhập email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email thành viên",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập email";
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return "Email không hợp lệ";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text("Gửi lời mời"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              final role = _selectedRole;

              // TODO: gọi API backend để gửi mail mời
              // ví dụ:
              // await FamilyService.sendInvite(email, role);

              Navigator.pop(context); // đóng dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã gửi lời mời tới $email ($role)"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
