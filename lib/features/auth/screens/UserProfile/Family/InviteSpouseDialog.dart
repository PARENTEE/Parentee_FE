import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InviteSpouseDialog extends StatefulWidget {
  const InviteSpouseDialog({super.key});

  @override
  State<InviteSpouseDialog> createState() => _InviteSpouseDialogState();
}

class _InviteSpouseDialogState extends State<InviteSpouseDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Mời làm vợ / chồng"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Vai trò",
                border: OutlineInputBorder(),
              ),
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: "Vợ", child: Text("Vợ")),
                DropdownMenuItem(value: "Chồng", child: Text("Chồng")),
              ],
              onChanged: (value) {
                setState(() => _selectedRole = value);
              },
              validator: (value) =>
              value == null ? "Vui lòng chọn vai trò" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email người được mời",
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
          icon: const Icon(Icons.person_add),
          label: const Text("Gửi lời mời"),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              final role = _selectedRole!;

              // 🔹 Gọi API gửi lời mời
              await sendInvitation(email, role);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã gửi lời mời làm $role tới $email"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<void> sendInvitation(String email, String role) async {
    // Gọi API .NET backend
    // (ví dụ dùng http package)
    /*
    final response = await http.post(
      Uri.parse('https://yourapi.com/api/v1/family/invite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'inviteeEmail': email,
        'role': role,
      }),
    );
    */
  }
}
