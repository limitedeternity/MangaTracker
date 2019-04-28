import 'package:flutter/material.dart';
import 'package:manga_tracker/core/mangaCore.dart';
import 'package:material_search/material_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({this.coreInstance});
  final MangaCore coreInstance;

  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new MaterialSearch<String>(
        placeholder: "Search",
        getResults: (String query) async {
          List<MaterialSearchResult<String>> materialResult = [];
          List<dynamic> result = this.widget.coreInstance.searchManga(query);

          for (var mangaObject in result) {
            materialResult.add(
              new MaterialSearchResult<String>(
                value: mangaObject["t"],
                text: mangaObject["t"],
                icon: Icons.library_books,
              ),
            );
          }

          return materialResult;
        },
        onSelect: (dynamic selected) {
          this.widget.coreInstance.trackManga(selected);
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
