import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/scenes/home_Page.dart';
import 'home_screen.dart'; // Ana ekranı içe aktardık
import 'package:untitled1/scenes/bolumler.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/login'), // Android Emülatör için localhost
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

      // Kullanıcıyı ana ekrana yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
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
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "E-mail")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Şifre"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Giriş Yap")),
          ],
        ),
      ),
    );
  }
}
