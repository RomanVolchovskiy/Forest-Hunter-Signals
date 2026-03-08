import 'package:flutter/material.dart';
import 'package:hunting_signals/screens/admin_panel_screen.dart';

class AdminService {
  static const String adminPassword = '1488';
  static bool _isAdminAuthenticated = false;

  static bool get isAdminAuthenticated => _isAdminAuthenticated;

  static Future<bool> authenticate(String password) async {
    _isAdminAuthenticated = password == adminPassword;
    return _isAdminAuthenticated;
  }

  static void logout() {
    _isAdminAuthenticated = false;
  }

  static void showAdminLoginDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вхід адміністратора'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Введіть пароль адміністратора:'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text;
                if (await AdminService.authenticate(password)) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminPanelScreen(),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Неправильний пароль!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Увійти'),
            ),
          ],
        );
      },
    );
  }
}