import 'dart:convert';
import 'package:flutter/material.dart';
import 'local_storage_service.dart';
import 'google_drive_service.dart';

/// Storage manager that handles both local storage and Google Drive
/// Allows switching between Firebase, Google Drive, or local storage
class StorageManager {
  /// Storage types
  enum StorageType {
    local,      // Only local storage (SharedPreferences + Hive)
    googleDrive, // Google Drive + local cache
    firebase,   // Keep existing Firebase
  }

  static StorageType _currentStorage = StorageType.local;
  static bool _isInitialized = false;

  /// Initialize storage manager
  static Future<bool> initialize({StorageType storageType = StorageType.local}) async {
    try {
      _currentStorage = storageType;
      
      // Always initialize local storage as backup
      await LocalStorageService.initialize();
      
      if (storageType == StorageType.googleDrive) {
        await GoogleDriveService.initialize();
      }
      
      _isInitialized = true;
      debugPrint('StorageManager initialized with: $storageType');
      return true;
    } catch (e) {
      debugPrint('StorageManager initialization error: $e');
      return false;
    }
  }

  /// Get current storage type
  static StorageType get currentStorage => _currentStorage;

  /// Set storage type
  static Future<void> setStorageType(StorageType type) async {
    _currentStorage = type;
    if (type == StorageType.googleDrive) {
      await GoogleDriveService.initialize();
    }
  }

  /// Save hunting signals
  static Future<bool> saveHuntingSignals(List<Map<String, dynamic>> signals) async {
    try {
      // Always save to local storage first (as cache/backup)
      await LocalStorageService.saveHuntingSignals(signals);

      if (_currentStorage == StorageType.googleDrive) {
        // Also save to Google Drive
        final data = {
          'signals': signals,
          'timestamp': DateTime.now().toIso8601String(),
        };
        return await GoogleDriveService.saveHuntingSignals(data);
      }

      return true;
    } catch (e) {
      debugPrint('Error saving hunting signals: $e');
      return false;
    }
  }

  /// Load hunting signals
  static Future<List<Map<String, dynamic>>?> loadHuntingSignals() async {
    try {
      if (_currentStorage == StorageType.googleDrive) {
        // Try to load from Google Drive first
        final driveData = await GoogleDriveService.loadHuntingSignals();
        if (driveData != null && driveData.containsKey('signals')) {
          final signals = List<Map<String, dynamic>>.from(driveData['signals']);
          // Update local cache
          await LocalStorageService.saveHuntingSignals(signals);
          return signals;
        }
      }

      // Fallback to local storage
      return await LocalStorageService.loadHuntingSignals();
    } catch (e) {
      debugPrint('Error loading hunting signals: $e');
      return null;
    }
  }

  /// Save categories
  static Future<bool> saveCategories(List<Map<String, dynamic>> categories) async {
    try {
      await LocalStorageService.saveCategories(categories);
      
      if (_currentStorage == StorageType.googleDrive) {
        final data = {
          'categories': categories,
          'timestamp': DateTime.now().toIso8601String(),
        };
        // Save as separate file or combine with main data
        return await GoogleDriveService.saveHuntingSignals({
          'categories': categories,
          'type': 'categories',
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('Error saving categories: $e');
      return false;
    }
  }

  /// Load categories
  static Future<List<Map<String, dynamic>>?> loadCategories() async {
    try {
      // For now, use predefined categories or load from local storage
      return await LocalStorageService.loadCategories();
    } catch (e) {
      debugPrint('Error loading categories: $e');
      return null;
    }
  }

  /// Save educational materials
  static Future<bool> saveEducationalMaterials(List<Map<String, dynamic>> materials) async {
    try {
      await LocalStorageService.saveEducationalMaterials(materials);
      
      if (_currentStorage == StorageType.googleDrive) {
        final data = {
          'materials': materials,
          'timestamp': DateTime.now().toIso8601String(),
        };
        return await GoogleDriveService.saveHuntingSignals(data);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error saving educational materials: $e');
      return false;
    }
  }

  /// Load educational materials
  static Future<List<Map<String, dynamic>>?> loadEducationalMaterials() async {
    try {
      if (_currentStorage == StorageType.googleDrive) {
        final driveData = await GoogleDriveService.loadHuntingSignals();
        if (driveData != null && driveData.containsKey('materials')) {
          final materials = List<Map<String, dynamic>>.from(driveData['materials']);
          await LocalStorageService.saveEducationalMaterials(materials);
          return materials;
        }
      }

      return await LocalStorageService.loadEducationalMaterials();
    } catch (e) {
      debugPrint('Error loading educational materials: $e');
      return null;
    }
  }

  /// Save single item
  static Future<bool> saveItem(String key, dynamic value) async {
    try {
      return await LocalStorageService.saveItem(key, value);
    } catch (e) {
      debugPrint('Error saving item $key: $e');
      return false;
    }
  }

  /// Load single item
  static Future<dynamic> loadItem(String key) async {
    try {
      return await LocalStorageService.loadItem(key);
    } catch (e) {
      debugPrint('Error loading item $key: $e');
      return null;
    }
  }

  /// Delete item
  static Future<bool> deleteItem(String key) async {
    try {
      return await LocalStorageService.deleteItem(key);
    } catch (e) {
      debugPrint('Error deleting item $key: $e');
      return false;
    }
  }

  /// Create backup
  static Future<bool> createBackup() async {
    try {
      if (_currentStorage == StorageType.googleDrive) {
        return await GoogleDriveService.createBackup();
      } else {
        // Create local backup file
        final backupPath = await LocalStorageService.createBackupFile();
        return backupPath != null;
      }
    } catch (e) {
      debugPrint('Error creating backup: $e');
      return false;
    }
  }

  /// Restore from backup
  static Future<bool> restoreFromBackup() async {
    try {
      if (_currentStorage == StorageType.googleDrive) {
        return await GoogleDriveService.restoreFromBackup();
      } else {
        // For local storage, user needs to select backup file
        debugPrint('Select backup file for local restore');
        return false;
      }
    } catch (e) {
      debugPrint('Error restoring from backup: $e');
      return false;
    }
  }

  /// Get storage info
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final localInfo = await LocalStorageService.getStorageInfo();
      
      if (_currentStorage == StorageType.googleDrive) {
        final driveInfo = await GoogleDriveService.getStorageInfo();
        return {
          'storageType': 'googleDrive',
          'localStorage': localInfo,
          'googleDrive': driveInfo,
        };
      } else {
        return {
          'storageType': 'local',
          'localStorage': localInfo,
        };
      }
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  /// Clear all data
  static Future<bool> clearAll() async {
    try {
      return await LocalStorageService.clearAll();
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      return false;
    }
  }

  /// Migrate from Firebase to local storage
  static Future<bool> migrateFromFirebase(Map<String, dynamic> firebaseData) async {
    try {
      debugPrint('Migrating data from Firebase to local storage...');
      
      // Extract signals
      if (firebaseData.containsKey('signals')) {
        final signals = List<Map<String, dynamic>>.from(firebaseData['signals']);
        await saveHuntingSignals(signals);
      }

      // Extract categories
      if (firebaseData.containsKey('categories')) {
        final categories = List<Map<String, dynamic>>.from(firebaseData['categories']);
        await saveCategories(categories);
      }

      // Extract materials
      if (firebaseData.containsKey('materials')) {
        final materials = List<Map<String, dynamic>>.from(firebaseData['materials']);
        await saveEducationalMaterials(materials);
      }

      debugPrint('Migration completed successfully');
      return true;
    } catch (e) {
      debugPrint('Migration error: $e');
      return false;
    }
  }
}