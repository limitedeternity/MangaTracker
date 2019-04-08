import 'package:flutter/material.dart';
import 'package:manga_tracker/app.dart';

void main() => runApp(new MangaTracker());

class MangaTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MangaTracker",
      theme: new ThemeData(
        primaryColor: Colors.yellow,
        accentColor: Colors.yellowAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: new Application(),
    );
  }
}
