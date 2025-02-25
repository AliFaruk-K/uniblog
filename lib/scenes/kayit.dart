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
      theme: ThemeData.dark(), // Siyah tema
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka plan siyah
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar rengi
        title: const Text('Kayıt Ol', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // İsim Alanı
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 18), // Font boyutunu artırdık
                decoration: const InputDecoration(
                  labelText: 'İsim',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen isminizi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Soyisim Alanı
              TextFormField(
                controller: _surnameController,
                style: const TextStyle(color: Colors.white, fontSize: 18), // Font boyutunu artırdık
                decoration: const InputDecoration(
                  labelText: 'Soyisim',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyadınızı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-posta Alanı
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white, fontSize: 18), // Font boyutunu artırdık
                decoration: const InputDecoration(
                  labelText: 'E-posta Adresi',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Üniversite Adı Alanı
              TextFormField(
                controller: _universityController,
                style: const TextStyle(color: Colors.white, fontSize: 18), // Font boyutunu artırdık
                decoration: const InputDecoration(
                  labelText: 'Üniversite Adı',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen üniversite adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Kayıt Ol Butonu
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Form geçerli ise
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kayıt başarılı!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Buton rengi
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0), // Butonun boyutunu büyüt
                  ),
                  child: const Text('Kayıt Ol', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
