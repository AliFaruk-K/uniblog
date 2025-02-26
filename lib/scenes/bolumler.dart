import 'package:flutter/material.dart';
import 'package:untitled1/scenes/kayit.dart';
import 'package:untitled1/scenes/giris.dart';
import 'package:untitled1/scenes/profil.dart';
import 'package:untitled1/scenes/ayarlar.dart';
// bunu cıkıs butonunu kullanabilmek icin import ettik
import 'package:flutter/services.dart';

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
  int _selectedIndex = 0;

  // Sayfa listesi
  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchPage(),
    NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 50),
            onPressed: _openDrawer,
          ),
          title: const Text("Enes Birer", style: TextStyle(color: Colors.white)), // Başlık burada "Enes Birer" olarak değiştirildi
          actions: [
            // Sağdaki metin kısmı
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  // AU metni
                  const Text(
                    'AU',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 20.0), // İkonu daha fazla aşağıya kaydırdık
                child: const Icon(Icons.person, color: Colors.white, size: 40), // İkon boyutu
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 12.0), // Yazıyı daha fazla aşağıya kaydırdık
                child: const Text("Profil", style: TextStyle(color: Colors.white, fontSize: 24)), // Yazı boyutu
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 20.0), // İkonu daha fazla aşağıya kaydırdık
                child: const Icon(Icons.settings, color: Colors.white, size: 40), // İkon boyutu
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 12.0), // Yazıyı daha fazla aşağıya kaydırdık
                child: const Text("Ayarlar", style: TextStyle(color: Colors.white, fontSize: 24)), // Yazı boyutu
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 20.0), // İkonu daha fazla aşağıya kaydırdık
                child: const Icon(Icons.exit_to_app, color: Colors.white, size: 40), // İkon boyutu
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 12.0), // Yazıyı daha fazla aşağıya kaydırdık
                child: const Text("Çıkış", style: TextStyle(color: Colors.white, fontSize: 24)), // Yazı boyutu
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),

      body: _pages[_selectedIndex], // Seçili sayfayı göster

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        currentIndex: _selectedIndex, // Seçili sekme
        onTap: _onItemTapped, // Tıklanınca değiştir
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
// Ana Sayfa
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka planı siyah yapıyoruz
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar arka planı siyah
        title: const Text('Ana Sayfa', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Mesajların yer aldığı ListView
          Expanded(
            child: Scrollbar(
              thickness: 8.0,
              radius: const Radius.circular(10),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 0, // Artık öğe sayısı 0 olacak, yani listede mesaj yok
                itemBuilder: (context, index) {
                  return const SizedBox(); // Hiçbir şey döndürülmeyecek
                },
              ),
            ),
          ),

          // Mesaj ekleme alanı ve gönderme ikonu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Mesaj yazma alanı
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı buraya yazın...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),

                // Gönderme ikonu
                IconButton(
                  onPressed: () {
                    // Mesaj gönderme işlevi eklenebilir
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Arama Sayfası
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _allItems = [
    'Bilgisayar Mühendisliği',
    'Elektrik Mühendisliği',
    'Makine Mühendisliği',
    'Yazılım Mühendisliği',
    'Veritabanı Yönetimi',
    'Flutter Geliştirme',
    'Web Geliştirme',
    'Mobil Uygulama Geliştirme',
    'Yapay Zeka',
    'Makine Öğrenimi'
  ];
  List<String> _foundItems = [];

  @override
  void initState() {
    super.initState();
    _foundItems = _allItems; // Başlangıçta tüm öğeleri göster
  }

  // Arama fonksiyonu
  void _search(String query) {
    final suggestions = _allItems.where((item) {
      final itemLower = item.toLowerCase();
      final queryLower = query.toLowerCase();
      return itemLower.contains(queryLower);
    }).toList();
    setState(() {
      _foundItems = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Body arka planı siyah
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar arka planı siyah
        title: const Text(
          'Giriş',
          style: TextStyle(color: Colors.white), // Başlık yazısı beyaz
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama kutusu
            TextField(
              controller: _searchController,
              onChanged: _search,
              style: const TextStyle(color: Colors.white), // Yazı rengi beyaz
              decoration: InputDecoration(
                labelText: 'Ara...',
                labelStyle: const TextStyle(color: Colors.white), // Etiket rengi beyaz
                hintText: 'Anahtar kelime girin',
                hintStyle: const TextStyle(color: Colors.white54), // Hint rengi beyaz
                filled: true,
                fillColor: Colors.grey[800], // Arka plan rengini koyu gri yapıyoruz
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search, color: Colors.white), // Arama ikonu beyaz
              ),
            ),
            const SizedBox(height: 20),
            // Arama sonuçlarını listele
            Expanded(
              child: ListView.builder(
                itemCount: _foundItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900], // Kartların arka planı koyu gri
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        _foundItems[index],
                        style: const TextStyle(color: Colors.white, fontSize: 18), // Yazı rengi beyaz
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  // Bildirim verisi (Örnek olarak)
  final List<Map<String, String>> notifications = [
    {'title': 'Yeni Mesaj', 'content': 'Bir kullanıcı size mesaj gönderdi.'},
    {'title': 'Yeni Yorum', 'content': 'Paylaştığınız gönderiye yorum yapıldı.'},
    {'title': 'Yeni Takipçi', 'content': 'Birisi sizi takip etmeye başladı.'},
    {'title': 'Yeni Güncelleme', 'content': 'Uygulamanız için yeni bir güncelleme mevcut.'},
  ];

  // Bildirim tıklandığında açılacak olan dialog
  void _showNotificationDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dialog arka planı koyu
          title: Text(
            title,
            style: const TextStyle(color: Colors.white), // Başlık rengi beyaz
          ),
          content: Text(
            content,
            style: const TextStyle(color: Colors.white), // İçerik rengi beyaz
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: const Text(
                'Kapat',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka planı siyah yaptık
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar arka planı siyah
        title: const Text('Gelen Kutusu', style: TextStyle(color: Colors.white)), // Başlık beyaz
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length + 2, // Ekstra 2 bildirim kutusu ekleniyor
          itemBuilder: (context, index) {
            // Formalite için eklenen bildirim kutuları
            if (index == notifications.length) {
              return Card(
                color: Colors.grey[900], // Kart arka planı koyu gri
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const ListTile(
                  title: Text(
                    'Yeni Takipçi!',
                    style: TextStyle(color: Colors.white, fontSize: 18), // Yazı rengi beyaz
                  ),
                  subtitle: Text(
                    'Birisi sizi takip etmeye başladı.',
                    style: TextStyle(color: Colors.white70, fontSize: 14), // Alt yazı rengi daha açık beyaz
                  ),
                ),
              );
            } else if (index == notifications.length + 1) {
              return Card(
                color: Colors.grey[900], // Kart arka planı koyu gri
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const ListTile(
                  title: Text(
                    'Yeni Yorum!',
                    style: TextStyle(color: Colors.white, fontSize: 18), // Yazı rengi beyaz
                  ),
                  subtitle: Text(
                    'Paylaştığınız gönderiye yeni bir yorum yapıldı.',
                    style: TextStyle(color: Colors.white70, fontSize: 14), // Alt yazı rengi daha açık beyaz
                  ),
                ),
              );
            }

            // Normal bildirimler
            final notification = notifications[index];
            return Card(
              color: Colors.grey[900], // Kart arka planı koyu gri
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  notification['title']!,
                  style: const TextStyle(color: Colors.white, fontSize: 18), // Yazı rengi beyaz
                ),
                subtitle: Text(
                  notification['content']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14), // Alt yazı rengi daha açık beyaz
                ),
                onTap: () {
                  // Bildirime tıklandığında detayları göster
                  _showNotificationDetails(context, notification['title']!, notification['content']!);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

