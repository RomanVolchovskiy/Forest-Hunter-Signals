import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Google Drive service for storing hunting signals data
/// Alternative to Firebase - stores JSON files in Google Drive
class GoogleDriveService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );

  static drive.DriveApi? _driveApi;
  static bool _isInitialized = false;

  /// Initialize Google Drive service
  static Future<bool> initialize() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _signInSilently();
      }
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Google Drive initialization error: $e');
      return false;
    }
  }

  /// Sign in to Google account
  static Future<bool> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authenticateClient);
      
      // Save sign in state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('google_drive_signed_in', true);
      
      return true;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      return false;
    }
  }

  /// Silent sign in
  static Future<bool> _signInSilently() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      if (account == null) return false;

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authenticateClient);
      return true;
    } catch (e) {
      debugPrint('Silent sign in error: $e');
      return false;
    }
  }

  /// Sign out from Google account
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    _driveApi = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('google_drive_signed_in', false);
  }

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('google_drive_signed_in') ?? false;
  }

  /// Save hunting signals data to Google Drive
  static Future<bool> saveHuntingSignals(Map<String, dynamic> data) async {
    if (_driveApi == null) {
      if (!await signIn()) return false;
    }

    try {
      final jsonString = jsonEncode(data);
      final bytes = utf8.encode(jsonString);
      
      // Create file metadata
      final file = drive.File()
        ..name = 'hunting_signals_data.json'
        ..mimeType = 'application/json'
        ..parents = ['appDataFolder']; // Hidden app data folder

      // Upload file
      final result = await _driveApi!.files.create(
        file,
        uploadMedia: drive.Media(Stream.value(bytes), bytes.length),
      );

      debugPrint('File saved to Google Drive: ${result.id}');
      return true;
    } catch (e) {
      debugPrint('Error saving to Google Drive: $e');
      return false;
    }
  }

  /// Load hunting signals data from Google Drive
  static Future<Map<String, dynamic>?> loadHuntingSignals() async {
    if (_driveApi == null) {
      if (!await isSignedIn() || !await _signInSilently()) {
        return null;
      }
    }

    try {
      // Search for our file in app data folder
      final result = await _driveApi!.files.list(
        spaces: 'appDataFolder',
        q: "name='hunting_signals_data.json'",
      );

      if (result.files == null || result.files!.isEmpty) {
        debugPrint('No hunting signals data found in Google Drive');
        return null;
      }

      final file = result.files!.first;
      final fileId = file.id!;

      // Download file content
      final media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = await media.stream.expand((chunk) => chunk).toList();
      final jsonString = utf8.decode(bytes);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      debugPrint('Loaded hunting signals data from Google Drive');
      return data;
    } catch (e) {
      debugPrint('Error loading from Google Drive: $e');
      return null;
    }
  }

  /// Save backup to Google Drive
  static Future<bool> createBackup() async {
    try {
      // Get local data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final localData = <String, dynamic>{};
      
      // Collect all hunting signals data
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('hunting_')) {
          final value = prefs.get(key);
          if (value != null) {
            localData[key] = value;
          }
        }
      }

      if (localData.isNotEmpty) {
        return await saveHuntingSignals(localData);
      }
      return true;
    } catch (e) {
      debugPrint('Backup error: $e');
      return false;
    }
  }

  /// Restore from Google Drive backup
  static Future<bool> restoreFromBackup() async {
    try {
      final backupData = await loadHuntingSignals();
      if (backupData == null) return false;

      // Restore to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      for (final entry in backupData.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List) {
          await prefs.setStringList(key, List<String>.from(value));
        }
      }

      debugPrint('Successfully restored from Google Drive backup');
      return true;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    }
  }

  /// Get available storage space
  static Future<String> getStorageInfo() async {
    if (_driveApi == null) return 'Not connected';

    try {
      final about = await _driveApi!.about.get(fields: 'storageQuota');
      final quota = about.storageQuota;
      
      if (quota == null) return 'Unknown';
      
      final used = int.parse(quota.usage ?? '0');
      final limit = int.parse(quota.limit ?? '1');
      final available = limit - used;
      
      return 'Available: ${(available / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    } catch (e) {
      return 'Error getting storage info';
    }
  }
}

/// Google Auth Client for API calls
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() {
    _client.close();
  }
}