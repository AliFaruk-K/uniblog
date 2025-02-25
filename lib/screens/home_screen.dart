import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: Center(child: Text("Hoş geldiniz!")),
    );
  }
}
