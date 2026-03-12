import 'package:flutter/material.dart';
import 'package:hunting_signals/models/hunting_models.dart';
import 'package:hunting_signals/services/data_persistence_service.dart';
import 'package:hunting_signals/services/firebase_service.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// HuntingDataService — оновлений сервіс даних.
///
/// Логіка пріоритетів:
///   1. Первинне джерело → Cloud Firestore (realtime, всі пристрої синхронізовані)
///   2. Резервне джерело → SharedPreferences (офлайн-кеш, зворотна сумісність)
///
/// При першому запуску, якщо Firestore порожній, сервіс автоматично
/// заповнює базу початковими даними та зберігає їх локально.
/// ──────────────────────────────────────────────────────────────────────────
class HuntingDataService {
  // Локальний кеш (для швидкого старту та офлайн-режиму)
  static List<HuntingSignal> _signals = [];
  static List<EducationMaterial> _educationMaterials = [];

  // ─── Ініціалізація ──────────────────────────────────────────────────────
  static Future<void> loadPersistedData() async {
    // Завантажуємо локальний кеш
    final loadedSignals = await DataPersistenceService.loadSignals();
    if (loadedSignals.isNotEmpty) {
      _signals = loadedSignals;
    }
    final loadedMaterials =
        await DataPersistenceService.loadEducationMaterials();
    if (loadedMaterials.isNotEmpty) {
      _educationMaterials = loadedMaterials;
    }

    // Якщо Firestore порожній — заповнюємо початковими даними
    await _seedFirestoreIfEmpty();
  }

  /// Заповнює Firestore початковими даними, якщо колекції порожні.
  static Future<void> _seedFirestoreIfEmpty() async {
    try {
      final signals = await FirebaseService.instance.getSignals();
      if (signals.isEmpty) {
        final defaultSignals = _defaultSignals();
        for (final s in defaultSignals) {
          await FirebaseService.instance.addSignal(s);
        }
      }

      final materials =
          await FirebaseService.instance.getEducationMaterials();
      if (materials.isEmpty) {
        final defaultMaterials = _defaultEducationMaterials();
        for (final m in defaultMaterials) {
          await FirebaseService.instance.addEducationMaterial(m);
        }
      }

      // Seed категорій (один раз)
      await FirebaseService.instance.seedCategories(_defaultCategoriesData());
    } catch (_) {
      // Якщо немає інтернету — продовжуємо з локальним кешем
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SIGNALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream — підписуйся у StreamBuilder для автооновлень
  static Stream<List<HuntingSignal>> signalsStream() =>
      FirebaseService.instance.signalsStream();

  /// Realtime stream за категорією
  static Stream<List<HuntingSignal>> signalsByCategoryStream(String category) =>
      FirebaseService.instance.signalsByCategoryStream(category);

  /// Одноразово отримати всі сигнали (з кешем-fallback)
  static Future<List<HuntingSignal>> getAllSignals() async {
    try {
      final firestoreSignals = await FirebaseService.instance.getSignals();
      if (firestoreSignals.isNotEmpty) {
        _signals = firestoreSignals;
        DataPersistenceService.saveSignals(_signals); // оновити кеш
        return _signals;
      }
    } catch (_) {}
    // Fallback → локальний кеш
    if (_signals.isEmpty) _signals = _defaultSignals();
    return _signals;
  }

  /// Додати новий сигнал (адмін) → зберігається у Firestore
  static Future<void> addSignal(HuntingSignal signal) async {
    try {
      await FirebaseService.instance.addSignal(signal);
    } catch (_) {
      // Офлайн-fallback: зберегти локально
      _signals.add(signal);
      DataPersistenceService.saveSignals(_signals);
    }
  }

  /// Оновити сигнал (адмін)
  static Future<void> updateSignal(String id, HuntingSignal signal) async {
    await FirebaseService.instance.updateSignal(id, signal);
  }

  /// Видалити сигнал (адмін)
  static Future<void> deleteSignal(String id) async {
    await FirebaseService.instance.deleteSignal(id);
  }

  /// Отримати сигнали за категорією (одноразово)
  static Future<List<HuntingSignal>> getSignalsByCategory(
      String category) async {
    final all = await getAllSignals();
    return all.where((s) => s.category == category).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream категорій
  static Stream<List<SignalCategory>> categoriesStream() =>
      FirebaseService.instance.categoriesStream();

  /// Одноразово отримати категорії
  static Future<List<SignalCategory>> getCategories() async {
    try {
      final cats = await FirebaseService.instance.getCategories();
      if (cats.isNotEmpty) return cats;
    } catch (_) {}
    // Fallback
    return _defaultCategories();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  EDUCATION MATERIALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream навчальних матеріалів
  static Stream<List<EducationMaterial>> educationStream() =>
      FirebaseService.instance.educationStream();

  /// Одноразово отримати навчальні матеріали (з кешем-fallback)
  static Future<List<EducationMaterial>> getEducationMaterials() async {
    try {
      final materials =
          await FirebaseService.instance.getEducationMaterials();
      if (materials.isNotEmpty) {
        _educationMaterials = materials;
        DataPersistenceService.saveEducationMaterials(_educationMaterials);
        return _educationMaterials;
      }
    } catch (_) {}
    if (_educationMaterials.isEmpty) {
      _educationMaterials = _defaultEducationMaterials();
    }
    return _educationMaterials;
  }

  /// Додати навчальний матеріал (адмін)
  static Future<void> addEducationMaterial(EducationMaterial material) async {
    try {
      await FirebaseService.instance.addEducationMaterial(material);
    } catch (_) {
      _educationMaterials.add(material);
      DataPersistenceService.saveEducationMaterials(_educationMaterials);
    }
  }

  /// Оновити навчальний матеріал (адмін)
  static Future<void> updateEducationMaterial(
      String id, EducationMaterial material) async {
    await FirebaseService.instance.updateEducationMaterial(id, material);
  }

  /// Видалити навчальний матеріал (адмін)
  static Future<void> deleteEducationMaterial(String id) async {
    await FirebaseService.instance.deleteEducationMaterial(id);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Realtime stream подій
  static Stream<List<HuntingEvent>> eventsStream() =>
      FirebaseService.instance.eventsStream();

  /// Одноразово отримати події
  static Future<List<HuntingEvent>> getEvents() async {
    try {
      return await FirebaseService.instance.getEvents();
    } catch (_) {
      return [];
    }
  }

  /// Додати подію (адмін)
  static Future<void> addEvent(HuntingEvent event) async {
    await FirebaseService.instance.addEvent(event);
  }

  /// Видалити подію (адмін)
  static Future<void> deleteEvent(String id) async {
    await FirebaseService.instance.deleteEvent(id);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  ПОЧАТКОВІ ДАНІ (seed data)
  // ═══════════════════════════════════════════════════════════════════════════

  static List<HuntingSignal> _defaultSignals() => [
        HuntingSignal(
          id: 'seed_1',
          name: 'Сигнал збору',
          description: 'Сигнал для збору мисливців перед початком полювання',
          category: 'Інформаційні',
          audioUrl: 'https://example.com/signals/gathering.mp3',
          duration: 15,
        ),
        HuntingSignal(
          id: 'seed_2',
          name: 'Сигнал початку',
          description: 'Сигнал для початку мисливського заходу',
          category: 'Організаційні',
          audioUrl: 'https://example.com/signals/start.mp3',
          duration: 12,
        ),
        HuntingSignal(
          id: 'seed_3',
          name: 'Сигнал покоту',
          description: 'Сигнал для початку полювання з гончими',
          category: 'Сигнали покоту',
          audioUrl: 'https://example.com/signals/hunt.mp3',
          duration: 20,
        ),
        HuntingSignal(
          id: 'seed_4',
          name: 'Святковий марш',
          description: 'Сигнал для святкових мисливських подій',
          category: 'Святкові',
          audioUrl: 'https://example.com/signals/celebration.mp3',
          duration: 25,
        ),
        HuntingSignal(
          id: 'seed_5',
          name: 'Довільна мелодія',
          description: 'Сигнал для вільного виконання',
          category: 'Довільна програма',
          audioUrl: 'https://example.com/signals/custom.mp3',
          duration: 18,
        ),
      ];

  static List<EducationMaterial> _defaultEducationMaterials() => [
        EducationMaterial(
          id: 'edu_001',
          title: 'Як читати мисливські ноти',
          description: 'Повний посібник з читання мисливських нот',
          type: EducationType.article,
          content: 'Детальна інструкція про те, як читати мисливські ноти...',
          category: 'Нотна грамота',
          difficulty: DifficultyLevel.beginner,
          tags: ['ноти', 'грамота', 'основи'],
          createdAt: DateTime.now(),
        ),
        EducationMaterial(
          id: 'edu_002',
          title: 'Основи мисливської сигнальної музики',
          description: 'Вступ до мисливської сигнальної музики',
          type: EducationType.video,
          content: 'Відео урок про основи мисливської сигнальної музики...',
          videoUrl: 'assets/video/basic_signals.mp4',
          category: 'Теорія',
          difficulty: DifficultyLevel.beginner,
          tags: ['теорія', 'основи', 'сигнали'],
          createdAt: DateTime.now(),
        ),
      ];

  static List<SignalCategory> _defaultCategories() => [
        SignalCategory(
          id: '1',
          name: 'Інформаційні',
          description: 'Сигнали для передачі інформації',
          icon: 'info',
          color: Colors.blue,
        ),
        SignalCategory(
          id: '2',
          name: 'Організаційні',
          description: 'Сигнали для організації мисливства',
          icon: 'organization',
          color: Colors.green,
        ),
        SignalCategory(
          id: '3',
          name: 'Сигнали покоту',
          description: 'Сигнали для полювання з гончими',
          icon: 'hunt',
          color: Colors.orange,
        ),
        SignalCategory(
          id: '4',
          name: 'Святкові',
          description: 'Сигнали для святкових подій',
          icon: 'celebration',
          color: Colors.purple,
        ),
        SignalCategory(
          id: '5',
          name: 'Довільна програма',
          description: 'Сигнали для вільного виконання',
          icon: 'custom',
          color: Colors.teal,
        ),
      ];

  static List<Map<String, dynamic>> _defaultCategoriesData() => [
        {
          'id': '1',
          'name': 'Інформаційні',
          'description': 'Сигнали для передачі інформації',
          'icon': 'info',
          'colorValue': Colors.blue.value,
        },
        {
          'id': '2',
          'name': 'Організаційні',
          'description': 'Сигнали для організації мисливства',
          'icon': 'organization',
          'colorValue': Colors.green.value,
        },
        {
          'id': '3',
          'name': 'Сигнали покоту',
          'description': 'Сигнали для полювання з гончими',
          'icon': 'hunt',
          'colorValue': Colors.orange.value,
        },
        {
          'id': '4',
          'name': 'Святкові',
          'description': 'Сигнали для святкових подій',
          'icon': 'celebration',
          'colorValue': Colors.purple.value,
        },
        {
          'id': '5',
          'name': 'Довільна програма',
          'description': 'Сигнали для вільного виконання',
          'icon': 'custom',
          'colorValue': Colors.teal.value,
        },
      ];
}
