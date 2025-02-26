import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          _buildSettingsOption(
            Icons.account_circle,
            'Hesabım',
                () {
              // Hesabım tıklandığında yapılacak işlem
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hesabım seçildi')));
            },
          ),
          _buildSettingsOption(
            Icons.security,
            'Güvenlik',
                () {
              // Güvenlik tıklandığında yapılacak işlem
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Güvenlik seçildi')));
            },
          ),
          _buildSettingsOption(
            Icons.notifications,
            'Bildirimler',
                () {
              // Bildirimler tıklandığında yapılacak işlem
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bildirimler seçildi')));
            },
          ),
          _buildSettingsOption(
            Icons.lock,
            'Erişimler',
                () {
              // Erişimler tıklandığında yapılacak işlem
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erişimler seçildi')));
            },
          ),
          _buildSettingsOption(
            Icons.more_horiz,
            'Ek Ayarlar',
                () {
              // Ek ayarlar tıklandığında yapılacak işlem
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ek Ayarlar seçildi')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 30),
          title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
