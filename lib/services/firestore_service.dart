import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/hunting_models.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String _signalsCollection = 'signals';
  static const String _educationCollection = 'education_materials';
  static const String _categoriesCollection = 'categories';

  // Signals
  static Future<void> addSignal(HuntingSignal signal) async {
    try {
      await _firestore.collection(_signalsCollection).doc(signal.id).set({
        'id': signal.id,
        'name': signal.name,
        'description': signal.description,
        'category': signal.category,
        'audioUrl': signal.audioUrl,
        'videoUrl': signal.videoUrl,
        'notationUrl': signal.notationUrl,
        'imageUrl': signal.imageUrl,
        'duration': signal.duration,
        'historicalInfo': signal.historicalInfo,
        'usageInstructions': signal.usageInstructions,
        'tags': signal.tags,
        'isFavorite': signal.isFavorite,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add signal: $e');
    }
  }

  static Future<List<HuntingSignal>> getSignals() async {
    try {
      final querySnapshot = await _firestore.collection(_signalsCollection).get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return HuntingSignal(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          audioUrl: data['audioUrl'],
          videoUrl: data['videoUrl'],
          notationUrl: data['notationUrl'],
          imageUrl: data['imageUrl'],
          duration: data['duration'] ?? 30,
          historicalInfo: data['historicalInfo'],
          usageInstructions: data['usageInstructions'],
          tags: List<String>.from(data['tags'] ?? []),
          isFavorite: data['isFavorite'] ?? false,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get signals: $e');
    }
  }

  static Stream<List<HuntingSignal>> getSignalsStream() {
    return _firestore.collection(_signalsCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return HuntingSignal(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          audioUrl: data['audioUrl'],
          videoUrl: data['videoUrl'],
          notationUrl: data['notationUrl'],
          imageUrl: data['imageUrl'],
          duration: data['duration'] ?? 30,
          historicalInfo: data['historicalInfo'],
          usageInstructions: data['usageInstructions'],
          tags: List<String>.from(data['tags'] ?? []),
          isFavorite: data['isFavorite'] ?? false,
        );
      }).toList();
    });
  }

  // Education Materials
  static Future<void> addEducationMaterial(EducationMaterial material) async {
    try {
      await _firestore.collection(_educationCollection).doc(material.id).set({
        'id': material.id,
        'title': material.title,
        'description': material.description,
        'type': material.type.toString().split('.').last,
        'content': material.content,
        'videoUrl': material.videoUrl,
        'imageUrl': material.imageUrl,
        'category': material.category,
        'difficulty': material.difficulty.toString().split('.').last,
        'tags': material.tags,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add education material: $e');
    }
  }

  static Future<List<EducationMaterial>> getEducationMaterials() async {
    try {
      final querySnapshot = await _firestore.collection(_educationCollection).get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return EducationMaterial(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          type: EducationType.values.firstWhere(
            (e) => e.toString().split('.').last == data['type'],
            orElse: () => EducationType.article,
          ),
          content: data['content'] ?? '',
          videoUrl: data['videoUrl'],
          imageUrl: data['imageUrl'],
          category: data['category'] ?? '',
          difficulty: DifficultyLevel.values.firstWhere(
            (e) => e.toString().split('.').last == data['difficulty'],
            orElse: () => DifficultyLevel.beginner,
          ),
          tags: List<String>.from(data['tags'] ?? []),
          createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get education materials: $e');
    }
  }

  static Stream<List<EducationMaterial>> getEducationMaterialsStream() {
    return _firestore.collection(_educationCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return EducationMaterial(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          type: EducationType.values.firstWhere(
            (e) => e.toString().split('.').last == data['type'],
            orElse: () => EducationType.article,
          ),
          content: data['content'] ?? '',
          videoUrl: data['videoUrl'],
          imageUrl: data['imageUrl'],
          category: data['category'] ?? '',
          difficulty: DifficultyLevel.values.firstWhere(
            (e) => e.toString().split('.').last == data['difficulty'],
            orElse: () => DifficultyLevel.beginner,
          ),
          tags: List<String>.from(data['tags'] ?? []),
          createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

  // Categories
  static Future<void> addCategory(SignalCategory category) async {
    try {
      await _firestore.collection(_categoriesCollection).doc(category.id).set({
        'id': category.id,
        'name': category.name,
        'description': category.description,
        'icon': category.icon,
        'color': category.color.toARGB32(),
      });
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  static Future<List<SignalCategory>> getCategories() async {
    try {
      final querySnapshot = await _firestore.collection(_categoriesCollection).get();
      
      if (querySnapshot.docs.isEmpty) {
        // Return default categories if none exist
        return _getDefaultCategories();
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SignalCategory(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          icon: data['icon'] ?? '',
          color: Color(data['color'] ?? 0xFF2196F3),
        );
      }).toList();
    } catch (e) {
      // Return default categories if there's an error
      return _getDefaultCategories();
    }
  }

  static List<SignalCategory> _getDefaultCategories() {
    return [
      SignalCategory(
        id: '1',
        name: 'Інформаційні',
        description: 'Сигнали для передачі інформації',
        icon: 'info',
        color: const Color(0xFF2196F3),
      ),
      SignalCategory(
        id: '2',
        name: 'Організаційні',
        description: 'Сигнали для організації полювання',
        icon: 'organization',
        color: const Color(0xFF4CAF50),
      ),
      SignalCategory(
        id: '3',
        name: 'Сигнали покоту',
        description: 'Сигнали для полювання з гончими',
        icon: 'pets',
        color: const Color(0xFFFF9800),
      ),
      SignalCategory(
        id: '4',
        name: 'Святкові',
        description: 'Сигнали для святкових подій',
        icon: 'celebration',
        color: const Color(0xFF9C27B0),
      ),
      SignalCategory(
        id: '5',
        name: 'Довільна програма',
        description: 'Сигнали для вільного виконання',
        icon: 'custom',
        color: const Color(0xFF00BCD4),
      ),
    ];
  }

  // Initialize default data
  static Future<void> initializeDefaultData() async {
    try {
      final categories = await getCategories();
      if (categories.isEmpty || categories.length <= 1) {
        final defaultCategories = _getDefaultCategories();
        for (final category in defaultCategories) {
          await addCategory(category);
        }
      }
    } catch (e) {
      debugPrint('Error initializing default data: $e');
    }
  }
}