import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Büyük Kullanıcı İkonu
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[800],
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40), // Boşluk artırıldı
            // İsim ve Üniversite Bilgileri
            _buildProfileInfo('İsim', username, 28),
            const SizedBox(height: 24), // Boşluk artırıldı
            _buildProfileInfo('Üniversite', 'Amasya Üniversitesi', 30), // Üniversite bilgisi biraz daha büyük yazıldı
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, double fontSize) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
