import 'package:flutter/material.dart';
import 'theme/hunting_theme.dart';
import 'screens/main_navigation.dart';
import 'services/hunting_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load persisted data
  await HuntingDataService.loadPersistedData();
  
  runApp(const HuntingSignalsApp());
}

class HuntingSignalsApp extends StatelessWidget {
  const HuntingSignalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мисливська сигнальна музика',
      theme: HuntingTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}