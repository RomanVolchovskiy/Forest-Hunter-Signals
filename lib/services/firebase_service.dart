import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunting_signals/models/hunting_models.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// FirebaseService — центральний клас для роботи з Cloud Firestore.
///
/// Структура колекцій у Firestore:
///
///   signals/          → HuntingSignal
///   education/        → EducationMaterial
///   categories/       → SignalCategory
///   events/           → HuntingEvent
///
/// Всі методи повертають Stream для realtime-оновлень або Future для
/// одноразового читання / запису.
/// ──────────────────────────────────────────────────────────────────────────
class FirebaseService {
  // Singleton
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Назви колекцій ──────────────────────────────────────────────────────
  static const String _signalsCol = 'signals';
  static const String _educationCol = 'education';
  static const String _categoriesCol = 'categories';
  static const String _eventsCol = 'events';

  // ═══════════════════════════════════════════════════════════════════════════
  //  SIGNALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream — всі сигнали
  Stream<List<HuntingSignal>> signalsStream() {
    return _db
        .collection(_signalsCol)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map(_docToSignal).toList());
  }

  /// Realtime stream — сигнали за категорією
  Stream<List<HuntingSignal>> signalsByCategoryStream(String category) {
    return _db
        .collection(_signalsCol)
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map(_docToSignal).toList());
  }

  /// Одноразово отримати всі сигнали
  Future<List<HuntingSignal>> getSignals() async {
    final snap = await _db.collection(_signalsCol).orderBy('name').get();
    return snap.docs.map(_docToSignal).toList();
  }

  /// Додати новий сигнал (адмін)
  Future<String> addSignal(HuntingSignal signal) async {
    final data = _signalToMap(signal);
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _db.collection(_signalsCol).add(data);
    return ref.id;
  }

  /// Оновити сигнал (адмін)
  Future<void> updateSignal(String id, HuntingSignal signal) async {
    final data = _signalToMap(signal);
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection(_signalsCol).doc(id).update(data);
  }

  /// Видалити сигнал (адмін)
  Future<void> deleteSignal(String id) async {
    await _db.collection(_signalsCol).doc(id).delete();
  }

  /// Конвертація Firestore doc → HuntingSignal
  HuntingSignal _docToSignal(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return HuntingSignal(
      id: doc.id,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      category: d['category'] ?? '',
      audioUrl: d['audioUrl'],
      videoUrl: d['videoUrl'],
      notationUrl: d['notationUrl'],
      imageUrl: d['imageUrl'],
      duration: (d['duration'] as num?)?.toInt() ?? 0,
      tags: d['tags'] != null ? List<String>.from(d['tags']) : null,
      historicalInfo: d['historicalInfo'],
      usageInstructions: d['usageInstructions'],
      isFavorite: d['isFavorite'] ?? false,
    );
  }

  /// Конвертація HuntingSignal → Map для Firestore
  Map<String, dynamic> _signalToMap(HuntingSignal s) => {
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
      };

  // ═══════════════════════════════════════════════════════════════════════════
  //  EDUCATION MATERIALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream — всі навчальні матеріали
  Stream<List<EducationMaterial>> educationStream() {
    return _db
        .collection(_educationCol)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_docToEducation).toList());
  }

  /// Одноразово отримати всі навчальні матеріали
  Future<List<EducationMaterial>> getEducationMaterials() async {
    final snap = await _db
        .collection(_educationCol)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(_docToEducation).toList();
  }

  /// Додати навчальний матеріал (адмін)
  Future<String> addEducationMaterial(EducationMaterial material) async {
    final data = _educationToMap(material);
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _db.collection(_educationCol).add(data);
    return ref.id;
  }

  /// Оновити навчальний матеріал (адмін)
  Future<void> updateEducationMaterial(
      String id, EducationMaterial material) async {
    final data = _educationToMap(material);
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection(_educationCol).doc(id).update(data);
  }

  /// Видалити навчальний матеріал (адмін)
  Future<void> deleteEducationMaterial(String id) async {
    await _db.collection(_educationCol).doc(id).delete();
  }

  EducationMaterial _docToEducation(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return EducationMaterial(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      type: EducationType.values.firstWhere(
        (e) => e.name == d['type'],
        orElse: () => EducationType.article,
      ),
      content: d['content'] ?? '',
      videoUrl: d['videoUrl'],
      imageUrl: d['imageUrl'],
      category: d['category'] ?? '',
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == d['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      tags: d['tags'] != null ? List<String>.from(d['tags']) : [],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> _educationToMap(EducationMaterial m) => {
        'title': m.title,
        'description': m.description,
        'type': m.type.name,
        'content': m.content,
        'videoUrl': m.videoUrl,
        'imageUrl': m.imageUrl,
        'category': m.category,
        'difficulty': m.difficulty.name,
        'tags': m.tags,
      };

  // ═══════════════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream — всі категорії
  Stream<List<SignalCategory>> categoriesStream() {
    return _db
        .collection(_categoriesCol)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map(_docToCategory).toList());
  }

  /// Одноразово отримати всі категорії
  Future<List<SignalCategory>> getCategories() async {
    final snap =
        await _db.collection(_categoriesCol).orderBy('name').get();
    return snap.docs.map(_docToCategory).toList();
  }

  /// Заповнити категорії початковими даними (викликається один раз)
  Future<void> seedCategories(List<Map<String, dynamic>> categories) async {
    final batch = _db.batch();
    for (final cat in categories) {
      final ref = _db.collection(_categoriesCol).doc(cat['id']);
      batch.set(ref, cat, SetOptions(merge: true));
    }
    await batch.commit();
  }

  SignalCategory _docToCategory(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SignalCategory(
      id: doc.id,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      icon: d['icon'] ?? '',
      color: Color(d['colorValue'] as int? ?? 0xFF4CAF50),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream — всі події
  Stream<List<HuntingEvent>> eventsStream() {
    return _db
        .collection(_eventsCol)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(_docToEvent).toList());
  }

  /// Одноразово отримати всі події
  Future<List<HuntingEvent>> getEvents() async {
    final snap = await _db
        .collection(_eventsCol)
        .orderBy('date', descending: false)
        .get();
    return snap.docs.map(_docToEvent).toList();
  }

  /// Додати подію (адмін)
  Future<String> addEvent(HuntingEvent event) async {
    final data = _eventToMap(event);
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _db.collection(_eventsCol).add(data);
    return ref.id;
  }

  /// Видалити подію (адмін)
  Future<void> deleteEvent(String id) async {
    await _db.collection(_eventsCol).doc(id).delete();
  }

  HuntingEvent _docToEvent(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return HuntingEvent(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: d['location'] ?? '',
      recommendedSignals:
          d['recommendedSignals'] != null
              ? List<String>.from(d['recommendedSignals'])
              : [],
      imagePath: d['imagePath'],
      isCustom: d['isCustom'] ?? false,
    );
  }

  Map<String, dynamic> _eventToMap(HuntingEvent e) => {
        'title': e.title,
        'description': e.description,
        'date': Timestamp.fromDate(e.date),
        'location': e.location,
        'recommendedSignals': e.recommendedSignals,
        'imagePath': e.imagePath,
        'isCustom': e.isCustom,
      };
}
