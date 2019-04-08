import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MangaCore {
  Map<String, List> appData = {
    "savedManga": [],
    "mangaList": [],
  };

  Future<String> getAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<File> getDataFile() async {
    String appDir = await getAppDir();
    return new File('$appDir/data.json');
  }

  Future<void> getData() async {
    try {
      File dataFile = await getDataFile();
      String data = await dataFile.readAsString();
      this.appData = convert.jsonDecode(data);
    } catch (e) {
      /* */
    }

    await this.fetchMangaUpdate();
  }

  Future<void> saveData() async {
    File dataFile = await getDataFile();
    await dataFile.writeAsString(convert.jsonEncode(this.appData));
  }

  Future<void> fetchMangaUpdate() async {
    final response = await http.get("https://www.mangaeden.com/api/list/0/");

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      this.appData["mangaList"] = json["manga"];
      await this.saveData();
    }
  }

  Future<void> trackManga(String title) async {
    dynamic manga = this
        .appData["mangaList"]
        .where((entry) => entry["t"] == title)
        .toList()[0];

    this.appData["savedManga"].add(manga);
    await this.saveData();
  }

  Future<void> untrackManga(String title) async {
    this.appData["savedManga"] = this
        .appData["savedManga"]
        .where((entry) => entry["t"] != title)
        .toList();

    await this.saveData();
  }

  List<dynamic> searchManga(String query) {
    return this
        .appData["mangaList"]
        .where((entry) => entry["t"].contains(query))
        .toList();
  }

  Future<dynamic> getLatestChapter(String mangaId) async {
    final response =
        await http.get("https://www.mangaeden.com/api/manga/$mangaId");

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      return json["chapters"][0][0];
    } else {
      return null;
    }
  }
}
