import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hunting_signals/models/hunting_models.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// DataPersistenceService — локальний офлайн-кеш на основі SharedPreferences.
///
/// Використовується як РЕЗЕРВНЕ сховище, коли немає доступу до Firestore.
/// Основне сховище — Cloud Firestore (firebase_service.dart).
/// ──────────────────────────────────────────────────────────────────────────
class DataPersistenceService {
  static const String _signalsKey = 'cached_signals';
  static const String _educationMaterialsKey = 'cached_education_materials';

  // ─── Signals ──────────────────────────────────────────────────────────────

  static Future<void> saveSignals(List<HuntingSignal> signals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(signals
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'description': s.description,
                'category': s.category,
                'audioUrl': s.audioUrl,
                'videoUrl': s.videoUrl,
                'notationUrl': s.notationUrl,
                'imageUrl': s.imageUrl,
                'duration': s.duration,
                'tags': s.tags,
                'historicalInfo': s.historicalInfo,
                'usageInstructions': s.usageInstructions,
                'isFavorite': s.isFavorite,
              })
          .toList());
      await prefs.setString(_signalsKey, json);
    } catch (_) {}
  }

  static Future<List<HuntingSignal>> loadSignals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_signalsKey);
      if (str != null) {
        final list = jsonDecode(str) as List<dynamic>;
        return list
            .map((j) => HuntingSignal(
                  id: j['id'],
                  name: j['name'],
                  description: j['description'],
                  category: j['category'],
                  audioUrl: j['audioUrl'],
                  videoUrl: j['videoUrl'],
                  notationUrl: j['notationUrl'],
                  imageUrl: j['imageUrl'],
                  duration: j['duration'] ?? 30,
                  tags: j['tags'] != null
                      ? List<String>.from(j['tags'])
                      : null,
                  historicalInfo: j['historicalInfo'],
                  usageInstructions: j['usageInstructions'],
                  isFavorite: j['isFavorite'] ?? false,
                ))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Education Materials ──────────────────────────────────────────────────

  static Future<void> saveEducationMaterials(
      List<EducationMaterial> materials) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(materials
          .map((m) => {
                'id': m.id,
                'title': m.title,
                'description': m.description,
                'type': m.type.name,
                'content': m.content,
                'videoUrl': m.videoUrl,
                'imageUrl': m.imageUrl,
                'category': m.category,
                'difficulty': m.difficulty.name,
                'tags': m.tags,
                'createdAt': m.createdAt.toIso8601String(),
              })
          .toList());
      await prefs.setString(_educationMaterialsKey, json);
    } catch (_) {}
  }

  static Future<List<EducationMaterial>> loadEducationMaterials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_educationMaterialsKey);
      if (str != null) {
        final list = jsonDecode(str) as List<dynamic>;
        return list
            .map((j) => EducationMaterial(
                  id: j['id'],
                  title: j['title'],
                  description: j['description'],
                  type: EducationType.values.firstWhere(
                    (e) => e.name == j['type'],
                    orElse: () => EducationType.article,
                  ),
                  content: j['content'],
                  videoUrl: j['videoUrl'],
                  imageUrl: j['imageUrl'],
                  category: j['category'],
                  difficulty: DifficultyLevel.values.firstWhere(
                    (e) => e.name == j['difficulty'],
                    orElse: () => DifficultyLevel.beginner,
                  ),
                  tags: List<String>.from(j['tags'] ?? []),
                  createdAt: DateTime.parse(j['createdAt']),
                ))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // ─── Очистити кеш ─────────────────────────────────────────────────────────

  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_signalsKey);
      await prefs.remove(_educationMaterialsKey);
    } catch (_) {}
  }
}
