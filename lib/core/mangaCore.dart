import 'dart:async' show Future;
import 'dart:io' show File, Directory;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:http/http.dart' as http show get, Response;
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

  Future<void> loadData() async {
    File dataFile = await this.getDataFileLocation();
    bool dataFileExists = await dataFile.exists();

    if (dataFileExists) {
      String data = await dataFile.readAsString();
      this.appData = new Map<String, List<dynamic>>.from(jsonDecode(data));
    } else {
      await this.createDataFile();
    }

    await this.fetchMangaUpdate();
  }

  Future<void> fetchMangaUpdate() async {
    http.Response response;

    while (true) {
      try {
        response = await http.get("https://www.mangaeden.com/api/list/0/");
        break;
      } catch (e) {
        await new Future.delayed(const Duration(seconds: 2));
      }
    }

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      this.appData["mangaList"] = json["manga"];
      this.saveData();
    }
  }

  Future<void> saveData() async {
    File dataFile = await this.getDataFileLocation();
    await dataFile.writeAsString(jsonEncode(this.appData));
  }

  void trackManga(String title) {
    if (!this.appData["savedManga"].contains(title)) {
      this.appData["savedManga"].insert(0, title);
      this.saveData();
    }
  }

  void untrackManga(String title) {
    this.appData["savedManga"] =
        this.appData["savedManga"].where((entry) => entry != title).toList();

    this.saveData();
  }

  void reorderManga(int before, int after) {
    if (before != after) {
      String title = this.appData["savedManga"][before];

      this.appData["savedManga"].removeAt(before);
      this.appData["savedManga"].insert(after, title);
      this.saveData();
    }
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
}
