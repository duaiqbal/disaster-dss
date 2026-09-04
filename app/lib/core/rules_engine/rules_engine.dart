// UNVERIFIED DRAFT — not run/tested against a real Flutter build.
// Deterministic rules: maps retrieved evidence + hazard level to a
// structured, explainable response. This is the safety-critical layer —
// no LLM involved.

import '../retrieval/retrieval_engine.dart';

enum EvidenceLevel { high, moderate, limited }

class GuidanceResponse {
  final String answerText;
  final List<RetrievedChunk> sources;
  final EvidenceLevel evidenceLevel;
  final bool isCached;
  final String? staleNote;

  GuidanceResponse({
    required this.answerText,
    required this.sources,
    required this.evidenceLevel,
    required this.isCached,
    this.staleNote,
  });
}

class RulesEngine {
  /// Combines retrieved chunks into a structured, explainable answer.
  /// Never invents content — only assembles what was actually retrieved.
  static GuidanceResponse buildResponse(
    String query,
    List<RetrievedChunk> chunks, {
    bool offline = true,
  }) {
    if (chunks.isEmpty) {
      return GuidanceResponse(
        answerText:
            'No verified official information found for this query in the '
            'local knowledge base. Please consult official NDMA/PDMA sources '
            'directly if connectivity is available.',
        sources: [],
        evidenceLevel: EvidenceLevel.limited,
        isCached: offline,
      );
    }

    final evidenceLevel = chunks.length >= 3
        ? EvidenceLevel.high
        : chunks.length == 2
            ? EvidenceLevel.moderate
            : EvidenceLevel.limited;

    final combinedText = chunks.map((c) => c.text).join('\n\n');

    return GuidanceResponse(
      answerText: combinedText,
      sources: chunks,
      evidenceLevel: evidenceLevel,
      isCached: offline,
      staleNote: offline
          ? 'This information is from the last synchronized offline package.'
          : null,
    );
  }
}

/// Static hazard-to-action rules (Go-Bag / preparedness module).
/// Content should be sourced from official preparedness guidance where
/// possible — cite the source in each item during Phase 1 data collection.
class PreparednessRules {
  static const List<Map<String, String>> goBagChecklist = [
    {'item': 'Identity documents (CNIC, etc.)', 'why': 'Required for aid/registration after displacement'},
    {'item': 'Water (safe drinking)', 'why': 'Clean water may be unavailable for days'},
    {'item': 'Non-perishable food', 'why': 'Sustenance if supply chains are disrupted'},
    {'item': 'First-aid supplies', 'why': 'Basic injury treatment before help arrives'},
    {'item': 'Flashlight + batteries', 'why': 'Electricity outages are common during disasters'},
    {'item': 'Emergency contact list', 'why': 'Phone networks may be down; written backup needed'},
  ];
}
