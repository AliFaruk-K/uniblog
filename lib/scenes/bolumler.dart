import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/screens/register_screen.dart';

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
          title: Text(widget.username, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: const Icon(Icons.login, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 50),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              icon: const Icon(Icons.app_registration, color: Colors.white, size: 40),
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
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _tweets.length,
              itemBuilder: (context, index) {
                final tweet = _tweets[index];
                final timestamp = tweet["timestamp"]; // Zaman bilgisini alıyoruz
                final username = tweet["username"]; // Tweet sahibini alıyoruz
                final comments = tweet["comments"]; // Yorumları alıyoruz

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
                            // Yalnızca tweet sahibi silme butonunu görebilir
                            if (widget.username == username)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTweet(index), // Tweet silme
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Yorumları listele
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
                        // Yorum ekle butonu
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_comment, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _commentingTweetIndex = index; // Yorum yapılacak tweet'i seç
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
            child: Row(
              children: [
                Expanded(
                  child: _commentingTweetIndex != null // Yorum yaparken tweet alanı değişir
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
                  icon: const Icon(Icons.image, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _commentingTweetIndex != null
                      ? _addComment // Yorum ekle
                      : _addTweet, // Tweet gönder
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
