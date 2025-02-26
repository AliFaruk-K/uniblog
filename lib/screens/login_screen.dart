import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/scenes/bolumler.dart';
import 'package:untitled1/screens/home_screen.dart';
import 'package:untitled1/screens/register_screen.dart'; // Kayıt ol sayfası
import 'package:untitled1/screens/login_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  // Giriş fonksiyonu
  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/login'), // Backend API endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data['token']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarılı! Ana ekrana yönlendiriliyorsunuz...")),
      );

      // Kullanıcıyı ana sayfaya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarısız! Lütfen tekrar deneyin.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka plan siyah
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Kullanıcı Girişi', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // E-posta alanı
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'E-posta adresinizi girin',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Şifre alanı
              TextField(
                controller: passwordController,
                obscureText: true, // Şifre gizleme
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Şifrenizi girin',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Giriş Butonu
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Buton rengi
                ),
                child: const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              // Kayıt Ol Butonu
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text("Hesabınız yok mu? Kayıt olun!", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
