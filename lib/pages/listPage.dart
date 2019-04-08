import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    MangaCore core = new MangaCore();
    core.getData().then((void _) {
      setState(() {
        this.coreInstance = core;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: new Center(
          child: const Text(
            "MangaTracker",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: this.coreInstance == null ||
              this.coreInstance.appData["savedManga"].isEmpty
          ? new ListTile(
              title: new Align(
                alignment: Alignment.topCenter,
                child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    "You are not tracking any manga.\nAdd any using button below.",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            )
          : new Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: this.coreInstance.appData["savedManga"].length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9),
                      ),
                      child: new ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        leading: new Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                            border: new Border(
                              right: new BorderSide(
                                width: 1.0,
                                color: Colors.white24,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.library_books,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        title: new Text(
                          this.coreInstance.appData["savedManga"][index]["t"],
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: new Row(
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(top: 20.0),
                            ),
                            new FutureBuilder<dynamic>(
                              future: this.coreInstance.getLatestChapter(this
                                  .coreInstance
                                  .appData["savedManga"][index]["i"]),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<dynamic> snapshot,
                              ) {
                                int releaseDateMS =
                                    (this.coreInstance.appData['savedManga']
                                                [index]['ld'] *
                                            1000)
                                        .toInt();

                                DateTime releaseDateTime =
                                    new DateTime.fromMillisecondsSinceEpoch(
                                  releaseDateMS,
                                );

                                String releaseDateReadable =
                                    new DateFormat("MMMM d, y")
                                        .format(releaseDateTime);

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return new Text(
                                      "<...>",
                                      style: new TextStyle(color: Colors.white),
                                    );
                                  default:
                                    if (snapshot.hasData)
                                      return new Text(
                                        "Chapter ${snapshot.data}",
                                        style: new TextStyle(
                                          color: Colors.yellowAccent,
                                        ),
                                      );
                                    else
                                      return new Text(
                                        "$releaseDateReadable",
                                        style: new TextStyle(
                                          color: Colors.yellowAccent,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                        trailing: new InkWell(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onTap: () {
                            this.coreInstance.untrackManga(this
                                .coreInstance
                                .appData["savedManga"][index]["t"]);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: this.coreInstance == null
          ? new FloatingActionButton(
              onPressed: () {},
              child: new Container(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            )
          : new FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) =>
                        new SearchPage(coreInstance: this.coreInstance),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
