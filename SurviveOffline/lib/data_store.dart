import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class DataStore {
  static const _boxName = 'articles';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<List<Article>> getAll({String query = ''}) async {
    final box = Hive.box(_boxName);
    final raw = box.values.cast<String>().toList();
    final items = raw.map((s) => Article.fromMap(json.decode(s))).toList()
      ..sort((a,b) => b.updatedAt.compareTo(a.updatedAt));
    if (query.trim().isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((a) => a.title.toLowerCase().contains(q) || a.body.toLowerCase().contains(q)).toList();
  }

  static Future<Article?> get(String id) async {
    final box = Hive.box(_boxName);
    final s = box.get(id) as String?; if (s == null) return null;
    return Article.fromMap(json.decode(s));
  }

  static Future<void> upsert(Article a) async {
    final box = Hive.box(_boxName);
    await box.put(a.id, json.encode(a.toMap()));
  }

  static Future<void> importFromAssets() async {
    final box = Hive.box(_boxName);
    if (box.isNotEmpty) return; // first run only
    final text = await rootBundle.loadString('assets/sample_content.json');
    final list = (json.decode(text) as List).cast<Map<String,dynamic>>();
    for (final m in list) {
      final a = Article.fromMap(m);
      await upsert(a);
    }
  }

  // Optional: import da file .json tramite condivisione (non usato di default qui)
  static Future<void> importFromFile(File f) async {
    final text = await f.readAsString();
    final list = (json.decode(text) as List).cast<Map<String,dynamic>>();
    for (final m in list) {
      await upsert(Article.fromMap(m));
    }
  }
}
