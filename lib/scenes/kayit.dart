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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Kayıt Ol', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // İsim Alanı
              _buildTextField(_nameController, 'İsim'),
              const SizedBox(height: 16),
              // Soyisim Alanı
              _buildTextField(_surnameController, 'Soyisim'),
              const SizedBox(height: 16),
              // E-posta Alanı
              _buildTextField(_emailController, 'E-posta Adresi', emailValidation: true),
              const SizedBox(height: 16),
              // Üniversite Adı Alanı
              _buildTextField(_universityController, 'Üniversite Adı'),
              const SizedBox(height: 32),
              // Kayıt Ol Butonu
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kayıt başarılı!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
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

  Widget _buildTextField(TextEditingController controller, String label, {bool emailValidation = false}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[800], // Daha açık siyah arkaplan
      ),
      textAlign: TextAlign.center, // Metni ortala
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen $label girin';
        }
        if (emailValidation && !RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Geçerli bir e-posta adresi girin';
        }
        return null;
      },
    );
  }
}
