import 'package:flutter/material.dart';
import 'package:manga_tracker/core/mangaCore.dart';
import 'package:manga_tracker/pages/searchPage.dart';

class ListPage extends StatefulWidget {
  @override
  ListPageState createState() => new ListPageState();
}

class ListPageState extends State<ListPage> {
  MangaCore coreInstance;

  @override
  void initState() {
    super.initState();
    coreInstance = new MangaCore();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("MangaTracker"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: new Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline,
            ),
          );
        }),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(coreInstance: this.coreInstance),
            ),
          );
        },
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
