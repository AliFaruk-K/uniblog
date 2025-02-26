import 'package:flutter/material.dart';
import 'package:untitled1/scenes/kayit.dart';
import 'package:untitled1/scenes/giris.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/screens/register_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(), // Sayfanın arka planını siyah yapar
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer(); // Soldan paneli açacak
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black, // Tüm sayfanın arka planını siyah yap
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // AppBar'ı büyütüyoruz
        child: AppBar(
          backgroundColor: Colors.black, // AppBar arka planını siyah yap
          leading: IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 50), // Kullanıcı ikonunu büyüttüm
            onPressed: _openDrawer, // Soldan panel açılacak
          ),
          title: const SizedBox.shrink(), // Logo kaldırıldı
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen(),),
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white, size: 40), // Giriş butonuna ikon eklendi ve büyütüldü
                ),
              ],
            ),
            const SizedBox(width: 50), // Butonlar arasında boşluk
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen(),),
                    );
                  },

                  icon: const Icon(Icons.app_registration, color: Colors.white, size: 40), // Kayıt Ol butonuna ikon eklendi ve büyütüldü
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer( // Soldan açılan yan menü
        backgroundColor: Colors.black, // Yan panelin arka planı siyah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // Üst boşluk
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Profil", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("Ayarlar", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text("Çıkış", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900], // Kart rengini koyu yap
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Kullanıcı $index', style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Bu bir tweet içeriğidir.', style: TextStyle(color: Colors.white70)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white), // Yazı rengini beyaz yap
                    decoration: InputDecoration(
                      hintText: 'Tweet yaz...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Alt menünün arka planını siyah yap
        selectedItemColor: Colors.white, // Seçili ikonun rengini beyaz yap
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Menü',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Ara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Gelenler',
          ),
        ],
      ),
    );
  }
}
