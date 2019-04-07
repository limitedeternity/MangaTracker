import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => new ApplicationState();
}

class ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("MangaTracker"),
      ),
      body: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}
