import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hunting_signals/services/storage_manager.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/add_signal_screen.dart';
import 'screens/add_education_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/education_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage (choose your preferred storage type)
  await _initializeStorage();
  
  runApp(const HuntingSignalsApp());
}

/// Initialize storage - you can choose between different storage options
Future<void> _initializeStorage() async {
  // OPTION 1: Local storage only (SharedPreferences + Hive)
  await StorageManager.initialize(storageType: StorageManager.StorageType.local);
  
  // OPTION 2: Google Drive + local cache
  // await StorageManager.initialize(storageType: StorageManager.StorageType.googleDrive);
  
  // OPTION 3: Keep existing Firebase (if you have it configured)
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } catch (e) {
  //   print('Firebase initialization error: $e');
  // }
}

/// Main application class
class HuntingSignalsApp extends StatelessWidget {
  const HuntingSignalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мисливські Сигнали',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[700],
          secondary: Colors.orange[700],
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminScreen(),
        '/add-signal': (context) => const AddSignalScreen(),
        '/add-education': (context) => const AddEducationScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/education': (context) => const EducationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}