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
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<File> getDataFile() async {
    return new File('${getAppDir()}/data.json');
  }

  Future<void> readData() async {
    try {
      File dataFile = await getDataFile();
      String data = await dataFile.readAsString();
      this.appData = convert.jsonDecode(data);
    } catch (e) {}
  }

  Future<void> writeData() async {
    File dataFile = await getDataFile();
    await dataFile.writeAsString(convert.jsonEncode(this.appData));
  }

  Future<void> fetchMangaUpdate() async {
    final response = await http.get("https://www.mangaeden.com/api/list/0/");

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      this.appData["mangaList"] = json["manga"];
    }

    this.writeData();
  }

  List<Map<String, dynamic>> searchManga(String query) {
    return this
        .appData["mangaList"]
        .where((entry) => entry["t"].contains(query))
        .toList();
  }

  Future<dynamic> getLatestChapter(Map<String, dynamic> mangaObject) async {
    final response = await http
        .get("https://www.mangaeden.com/api/manga/${mangaObject['i']}");

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      return json[0][0];
    } else {
      return null;
    }
  }

  dynamic getMangaCover(Map<String, dynamic> mangaObject) {
    return mangaObject['im']
        ? "https://cdn.mangaeden.com/mangasimg/${mangaObject['im']}"
        : null;
  }
}
