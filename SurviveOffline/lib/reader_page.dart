import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'models.dart';

class ReaderPage extends StatelessWidget {
  final Article article;
  const ReaderPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final html = md.markdownToHtml(article.body);
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SelectableText.rich(
            TextSpan(text: _stripHtml(html), style: theme.textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }

  String _stripHtml(String s) => s.replaceAll(RegExp(r'<[^>]*>'), '');
}
