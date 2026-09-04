// LIKE-based retrieval from knowledge.sqlite (plain table, not FTS5).
// FTS5 is not reliably available via sqflite's OS-bundled SQLite on
// all Android devices/emulators, so this uses simple LIKE matching
// instead — no embeddings on-device, keyword search only.

import '../local_db/local_db.dart';

class RetrievedChunk {
  final String chunkId;
  final String text;
  final String sourceOrg;
  final String sourceTitle;
  final String publicationDate;

  RetrievedChunk({
    required this.chunkId,
    required this.text,
    required this.sourceOrg,
    required this.sourceTitle,
    required this.publicationDate,
  });
}

class RomanUrduNormalizer {
  // Populated from data/roman_urdu_variants.json during Phase 6 evaluation.
  // Starter set only — expand based on real failed-query analysis.
  static const Map<String, String> _variants = {
    'selab': 'flood',
    'sailaab': 'flood',
    'baarish': 'rain',
    'barish': 'rain',
    'paani': 'water',
    'pani': 'water',
    'zameen khisakna': 'landslide',
    'zamin khisakna': 'landslide',
  };

  static String normalize(String query) {
    String result = query.toLowerCase();
    _variants.forEach((variant, canonical) {
      result = result.replaceAll(variant, canonical);
    });
    return result;
  }
}

class RetrievalEngine {
  static Future<List<RetrievedChunk>> search(String query, {int limit = 5}) async {
    final normalized = RomanUrduNormalizer.normalize(query);
    final db = await LocalDb.knowledgeDb;

    final words = normalized
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .toList();

    if (words.isEmpty) return [];

    final likeConditions = words.map((_) => 'k.text LIKE ?').join(' OR ');
    final likeArgs = words.map((w) => '%$w%').toList();

    final rows = await db.rawQuery('''
      SELECT k.chunk_id, k.text, m.source_org, m.source_title, m.publication_date
      FROM knowledge k
      JOIN chunk_metadata m ON k.chunk_id = m.chunk_id
      WHERE $likeConditions
      LIMIT ?
    ''', [...likeArgs, limit]);

    return rows
        .map((r) => RetrievedChunk(
              chunkId: r['chunk_id'] as String,
              text: r['text'] as String,
              sourceOrg: r['source_org'] as String,
              sourceTitle: r['source_title'] as String,
              publicationDate: r['publication_date'] as String,
            ))
        .toList();
  }
}