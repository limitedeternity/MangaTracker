import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MangaCore {
  Map<String, List<dynamic>> appData = {
    "savedManga": [],
    "mangaList": [],
  };

  Future<String> getAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<File> getDataFileLocation() async {
    String appDir = await this.getAppDir();
    return new File('$appDir/data.json');
  }

  Future<void> createDataFile() async {
    File dataFile = await this.getDataFileLocation();
    await dataFile.create(recursive: true);
    await this.saveData();
  }

  Future<void> readSavedData() async {
    File dataFile = await this.getDataFileLocation();
    bool dataFileExists = await dataFile.exists();

    if (!dataFileExists) {
      await this.createDataFile();
      await this.fetchMangaUpdate();
    } else {
      String data = await dataFile.readAsString();
      this.appData = Map<String, List<dynamic>>.from(convert.jsonDecode(data));
      this.fetchMangaUpdate();
    }
  }

  Future<void> fetchMangaUpdate() async {
    final response = await http.get("https://www.mangaeden.com/api/list/0/");

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      this.appData["mangaList"] = json["manga"];
      this.saveData();
    }
  }

  Future<void> saveData() async {
    File dataFile = await this.getDataFileLocation();
    await dataFile.writeAsString(convert.jsonEncode(this.appData));
  }

  Future<void> trackManga(String title) async {
    this.appData["savedManga"].add(title);
    this.saveData();
  }

  Future<void> untrackManga(String title) async {
    this.appData["savedManga"] =
        this.appData["savedManga"].where((entry) => entry != title).toList();

    this.saveData();
  }

  List<dynamic> searchManga(String query) {
    return this
        .appData["mangaList"]
        .where(
          (entry) => entry["t"]
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase().trim()),
        )
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
