import 'package:flutter/material.dart';
import 'ads.dart';
import 'data_store.dart';
import 'models.dart';
import 'reader_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.init();
  await DataStore.init();
  await DataStore.importFromAssets();
  runApp(const SurviveOfflineApp());
}

class SurviveOfflineApp extends StatelessWidget {
  const SurviveOfflineApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SurviveOffline',
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4F46E5)),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: const Color(0xFF4F46E5)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  final _banner = BannerAdWidget();
  List<Article> _items = [];

  @override
  void initState() { super.initState(); _refresh(); }

  Future<void> _refresh() async { _items = await DataStore.getAll(query: _searchCtrl.text); setState((){}); }

  @override
  void dispose() { _searchCtrl.dispose(); _banner.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SurviveOffline')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (_) => _refresh(),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cerca…', border: OutlineInputBorder()),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 70),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final a = _items[i];
                return ListTile(
                  title: Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(a.updatedAt.toIso8601String()),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderPage(article: a))),
                  trailing: IconButton(
                    icon: Icon(a.favorite ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: () async { a.favorite = !a.favorite; await DataStore.upsert(a); setState((){}); },
                  ),
                );
              },
            ),
          ),
        ),
        if (_banner.widget != null)
          SizedBox(height: _banner.size.height.toDouble(), child: Center(child: _banner.widget)),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSample,
        label: const Text('Aggiungi testo'), icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addSample() async {
    final now = DateTime.now();
    final a = Article(
      id: now.microsecondsSinceEpoch.toString(),
      title: 'Nuovo testo — ${now.toIso8601String()}',
      body: '# Titolo\n\nTesto di esempio salvato offline.\n\n- Punto 1\n- Punto 2',
      updatedAt: now,
    );
    await DataStore.upsert(a);
    await _refresh();
  }
}
