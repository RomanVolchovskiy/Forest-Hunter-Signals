import 'package:flutter/material.dart';
import 'package:hunting_signals/models/hunting_models.dart';
import 'package:hunting_signals/services/data_persistence_service.dart';
import 'package:hunting_signals/services/firestore_service.dart';

class HuntingDataService {
  static List<HuntingSignal> _signals = [];
  static List<EducationMaterial> _educationMaterials = [];
  static final bool _useFirebase = true;
  static bool get useFirebase => _useFirebase;

  // Initialize persisted data
  static Future<void> loadPersistedData() async {
    if (_useFirebase) {
      // Load from Firebase
      try {
        _signals = await FirestoreService.getSignals();
        _educationMaterials = await FirestoreService.getEducationMaterials();
      } catch (e) {
        debugPrint('Error loading from Firebase: $e');
        // Fallback to local storage if Firebase fails
        await _loadFromLocalStorage();
      }
    } else {
      // Load from local storage
      await _loadFromLocalStorage();
    }
  }

  static Future<void> _loadFromLocalStorage() async {
    final loadedSignals = await DataPersistenceService.loadSignals();
    if (loadedSignals.isNotEmpty) {
      _signals = loadedSignals;
    }

    final loadedMaterials = await DataPersistenceService.loadEducationMaterials();
    if (loadedMaterials.isNotEmpty) {
      _educationMaterials = loadedMaterials;
    }
  }

  static Future<List<SignalCategory>> getCategories() async {
    if (_useFirebase) {
      return await FirestoreService.getCategories();
    } else {
      // Return default categories if Firebase is not used
      return [
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
          description: 'Сигнали для організації полювання',
          icon: 'organization',
          color: Colors.green,
        ),
        SignalCategory(
          id: '3',
          name: 'Сигнали покоту',
          description: 'Сигнали для полювання з гончими',
          icon: 'pets',
          color: Colors.orange,
        ),
        SignalCategory(
          id: '4',
          name: 'Святкові',
          description: 'Сигнали для святкових подій',
          icon: 'celebration',
          color: Colors.purple,
        ),
      ];
    }
  }

  static Future<List<HuntingSignal>> getAllSignals() async {
    if (_signals.isEmpty) {
      _signals = [
        HuntingSignal(
          id: '1',
          name: 'Сигнал збору',
          description: 'Сигнал для збору мисливців перед початком полювання',
          category: 'Інформаційні',
          audioUrl: 'https://example.com/signals/gathering.mp3',
          duration: 15,
        ),
        HuntingSignal(
          id: '2',
          name: 'Сигнал початку',
          description: 'Сигнал для початку мисливського заходу',
          category: 'Організаційні',
          audioUrl: 'https://example.com/signals/start.mp3',
          duration: 12,
        ),
        HuntingSignal(
          id: '3',
          name: 'Сигнал покоту',
          description: 'Сигнал для початку полювання з гончими',
          category: 'Сигнали покоту',
          audioUrl: 'https://example.com/signals/hunt.mp3',
          duration: 20,
        ),
        HuntingSignal(
          id: '4',
          name: 'Святковий марш',
          description: 'Сигнал для святкових мисливських подій',
          category: 'Святкові',
          audioUrl: 'https://example.com/signals/celebration.mp3',
          duration: 25,
        ),
        HuntingSignal(
          id: '5',
          name: 'Довільна мелодія',
          description: 'Сигнал для вільного виконання',
          category: 'Довільна програма',
          audioUrl: 'https://example.com/signals/custom.mp3',
          duration: 18,
        ),
      ];
    }
    return _signals;
  }

  static void addSignal(HuntingSignal signal) {
    _signals.add(signal);
    DataPersistenceService.saveSignals(_signals);
  }

  static void addEducationMaterial(EducationMaterial material) {
    _educationMaterials.add(material);
    DataPersistenceService.saveEducationMaterials(_educationMaterials);
  }

  static Future<List<EducationMaterial>> getEducationMaterials() async {
    if (_educationMaterials.isEmpty) {
      _educationMaterials = [
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
    }
    return _educationMaterials;
  }

  static Future<List<HuntingSignal>> getSignalsByCategory(String category) async {
    final allSignals = await getAllSignals();
    return allSignals.where((signal) => signal.category == category).toList();
  }
}