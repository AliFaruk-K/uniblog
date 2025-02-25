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
      theme: ThemeData.dark(), // Tema siyah yapılıyor
      home: const LoginPage(), // LoginPage sayfasını ana ekran olarak belirliyoruz
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
  final _cityController = TextEditingController();

  // Formu gönderme işlemi
  void _submit() {
    String email = _emailController.text;
    String city = _cityController.text;

    // Burada girdiği bilgileri alabilirsiniz
    print('E-posta: $email');
    print('Şehir: $city');

    // Bu bilgileri kullanarak istediğiniz işlemi gerçekleştirebilirsiniz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka planı siyah yapıyoruz
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar rengi siyah
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
                controller: _emailController,
                style: const TextStyle(color: Colors.white), // Yazı rengi beyaz
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'E-posta adresinizi girin',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800], // Alanın arka plan rengi
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Şehir alanı
              TextField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white), // Yazı rengi beyaz
                decoration: InputDecoration(
                  labelText: 'Şehir',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintText: 'Okuduğunuz şehri girin',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800], // Alanın arka plan rengi
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Giriş butonu
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Butonun rengi
                ),
                child: const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
