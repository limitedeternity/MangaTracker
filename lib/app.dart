import 'package:flutter/material.dart';
import 'package:manga_tracker/pages/listPage.dart';
import 'package:manga_tracker/core/queryPermissions.dart';

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => new ApplicationState();
}

class ApplicationState extends State<Application> {
  bool permissionsGranted = false;

  @override
  void initState() {
    super.initState();

    queryPermissions().then((void _) {
      this.setState(() {
        this.permissionsGranted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.permissionsGranted
        ? new ListPage()
        : new Scaffold(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            appBar: new AppBar(
              elevation: 0.1,
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              title: new Center(
                child: const Text(""),
              ),
            ),
            body: new Center(
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
  }
}
