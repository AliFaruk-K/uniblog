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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    String email = _emailController.text;
    String password = _passwordController.text;
    print('E-posta: $email');
    print('Şifre: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // **Ortalanmış Giriş İkonu**
                const Icon(
                  Icons.login,
                  size: 100.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // **Kullanıcı Girişi Başlığı**
                const Text(
                  'Kullanıcı Girişi',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 30),

                // **E-Posta Alanı**
                TextField(
                  controller: _emailController,
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

                // **Şifre Alanı**
                TextField(
                  controller: _passwordController,
                  obscureText: true,
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

                // **Giriş Yap Butonu**
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),

                // **Kayıt Ol Butonu**
                ElevatedButton(
                  onPressed: () {
                    print("Kayıt Ol butonuna tıklandı");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Kayıt Ol', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
