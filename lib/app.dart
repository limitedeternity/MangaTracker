import 'package:flutter/material.dart';
import 'package:manga_tracker/pages/listPage.dart';

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
    return new ListPage();
  }
}
