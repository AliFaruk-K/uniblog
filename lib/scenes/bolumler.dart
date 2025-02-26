import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/screens/register_screen.dart';
import 'package:untitled1/scenes/ayarlar.dart';
import 'package:untitled1/scenes/profil.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _tweetController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _tweets = [];
  int? _commentingTweetIndex; // Yorum yapılacak tweet'in index'i
  late String tweetsFilePath;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Tweet ekleme fonksiyonu
  void _addTweet() {
    String tweetText = _tweetController.text.trim();
    if (tweetText.isNotEmpty) {
      final currentTime = DateTime.now();
      final formattedTime = '${currentTime.hour}:${currentTime.minute}'; // Sadece saat ve dakika
      setState(() {
        _tweets.insert(0, {
          "username": widget.username,
          "tweet": tweetText,
          "timestamp": formattedTime, // Sadece saat ve dakika
          "comments": [], // Başlangıçta yorumlar boş olacak
        });
      });
      _saveTweets(); // Tweetleri kaydet
      sendTweetToBackend(widget.username, tweetText); // Tweeti backend'e gönder
      _tweetController.clear();
    }
  }

  // Yorum ekleme fonksiyonu
  void _addComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty && _commentingTweetIndex != null) {
      setState(() {
        _tweets[_commentingTweetIndex!]["comments"].add({
          "username": widget.username,
          "comment": commentText,
        });
      });
      _saveTweets(); // Yorum ekledikten sonra tweetleri kaydet
      _commentController.clear();
      setState(() {
        _commentingTweetIndex = null; // Yorum yapmayı bitirdik, eski haline dön
      });
    }
  }

  // Tweetleri JSON dosyasına kaydetme
  Future<void> _saveTweets() async {
    final file = File(tweetsFilePath);
    final jsonData = json.encode(_tweets);
    await file.writeAsString(jsonData, mode: FileMode.write, flush: true);
  }

  // Tweetleri JSON dosyasından okuma
  Future<void> _loadTweets() async {
    final file = File(tweetsFilePath);
    if (file.existsSync()) {
      final jsonData = await file.readAsString();
      final List<dynamic> decodedData = json.decode(jsonData);
      setState(() {
        _tweets = decodedData
            .map((tweet) => Map<String, dynamic>.from(tweet)) // Yorumları da alıyoruz
            .toList();
      });
    }
  }

  // Backend API'ye tweet gönderme fonksiyonu
  Future<void> sendTweetToBackend(String username, String tweet) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/tweets'); 

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'tweet': tweet,
      }),
    );

    if (response.statusCode == 201) {
      print('Tweet başarıyla gönderildi!');
    } else {
      print('Tweet gönderilemedi: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTweetFile();
  }

  Future<void> _initializeTweetFile() async {
    final directory = await getApplicationDocumentsDirectory();
    tweetsFilePath = '${directory.path}/tweets.json';
    await _loadTweets(); 
  }

  // Tweet silme fonksiyonu
  void _deleteTweet(int index) {
    setState(() {
      _tweets.removeAt(index); // Tweeti listeden sil
    });
    _saveTweets(); // Değişiklikleri kaydet
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.username, style: const TextStyle(color: Colors.white)),
            const Text("AU", style: TextStyle(color: Colors.white, fontSize: 26)),
          ],
        ),
      ),
    ),
    drawer: Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("Profil", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(username: widget.username)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text("Ayarlar", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            title: const Text("Çıkış", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    ),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Ana Sayfa",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _tweets.length,
            itemBuilder: (context, index) {
              final tweet = _tweets[index];
              final timestamp = tweet["timestamp"];
              final username = tweet["username"];
              final comments = tweet["comments"];

              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(tweet["username"]!, style: const TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tweet["tweet"]!, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timestamp != null ? 'Atıldı: $timestamp' : '',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                          if (widget.username == username)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTweet(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (var comment in comments)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              const Icon(Icons.comment, color: Colors.white, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                '${comment["username"]}: ${comment["comment"]}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_comment, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _commentingTweetIndex = index;
                                });
                              },
                            ),
                            const Text(
                              'Yorum ekle',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _commentingTweetIndex != null
                        ? TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Yorum yaz...',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: const OutlineInputBorder(),
                            ),
                          )
                        : TextField(
                            controller: _tweetController,
                            style: const TextStyle(color: Colors.white),
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
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _commentingTweetIndex != null ? _addComment : _addTweet,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Alt Menü Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Ana Menü Butonu
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(username: widget.username)),
                          );
                        },
                      ),
                      const Text("Ana Menü", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  // Arama Butonu
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 30),
                        onPressed: () {
                          // Buraya arama sayfasına yönlendirme eklenebilir
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                        },
                      ),
                      const Text("Arama", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  // Bildirimler Butonu
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white, size: 30),
                        onPressed: () {
                          // Buraya bildirimler sayfasına yönlendirme eklenebilir
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
                        },
                      ),
                      const Text("Bildirimler", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}

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