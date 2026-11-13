import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../services/fcm_service.dart';
import '../../widgets/custom_button.dart';

/// F-FCM-02: Tampilkan FCM token (bisa disalin). F-AUTH-03: Logout.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();
    final token = FcmService().fcmToken;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF1E3A5F),
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  user?.email ?? '-',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),

              Text('FCM Token Perangkat',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        token ?? 'Token belum tersedia',
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Salin token',
                      onPressed: token == null
                          ? null
                          : () {
                              Clipboard.setData(ClipboardData(text: token));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Token disalin ke clipboard')),
                              );
                            },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gunakan token ini untuk mengirim notifikasi uji coba dari Firebase Console.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),

              const SizedBox(height: 40),
              CustomButton(
                label: 'Logout',
                icon: Icons.logout,
                color: Colors.red.shade600,
                onPressed: () async {
                  await authService.logout();
                  // StreamBuilder di main.dart otomatis mengarahkan ke Login.
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
