import 'package:flutter/material.dart';
import 'package:hunting_signals/services/storage_manager.dart';

/// Settings screen with storage options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  StorageManager.StorageType _currentStorage = StorageManager.currentStorage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentStorage();
  }

  Future<void> _loadCurrentStorage() async {
    setState(() {
      _currentStorage = StorageManager.currentStorage;
    });
  }

  Future<void> _changeStorageType(StorageManager.StorageType newType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await StorageManager.setStorageType(newType);
      setState(() {
        _currentStorage = newType;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Тип зберігання змінено на: ${_getStorageTypeName(newType)}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка зміни типу зберігання: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getStorageTypeName(StorageManager.StorageType type) {
    switch (type) {
      case StorageManager.StorageType.local:
        return 'Локальне сховище';
      case StorageManager.StorageType.googleDrive:
        return 'Google Drive';
      case StorageManager.StorageType.firebase:
        return 'Firebase';
    }
  }

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await StorageManager.createBackup();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Резервна копія створена успішно'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не вдалося створити резервну копію'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка створення резервної копії: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restoreFromBackup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await StorageManager.restoreFromBackup();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Дані відновлено з резервної копії'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не вдалося відновити дані'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка відновлення: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showStorageInfo() async {
    try {
      final info = await StorageManager.getStorageInfo();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Інформація про сховище'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Тип сховища: ${info['storageType'] ?? 'невідомий'}'),
                if (info['localStorage'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Локальні дані: ${info['localStorage']['itemCount'] ?? 0} елементів'),
                  Text('Розмір: ${info['localStorage']['totalSize'] ?? 0} байт'),
                ],
                if (info['googleDrive'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Google Drive: ${info['googleDrive']}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка отримання інформації: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Тип сховіщa даних',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Виберіть де зберігати дані програми:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          
                          RadioListTile<StorageManager.StorageType>(
                            title: const Text('Локальне сховище'),
                            subtitle: const Text('Дані зберігаються на пристрої'),
                            value: StorageManager.StorageType.local,
                            groupValue: _currentStorage,
                            onChanged: (value) {
                              if (value != null) {
                                _changeStorageType(value);
                              }
                            },
                          ),
                          
                          RadioListTile<StorageManager.StorageType>(
                            title: const Text('Google Drive'),
                            subtitle: const Text('Дані зберігаються в хмарі'),
                            value: StorageManager.StorageType.googleDrive,
                            groupValue: _currentStorage,
                            onChanged: (value) {
                              if (value != null) {
                                _changeStorageType(value);
                              }
                            },
                          ),
                          
                          RadioListTile<StorageManager.StorageType>(
                            title: const Text('Firebase (поточний)'),
                            subtitle: const Text('Дані зберігаються в Firebase'),
                            value: StorageManager.StorageType.firebase,
                            groupValue: _currentStorage,
                            onChanged: (value) {
                              if (value != null) {
                                _changeStorageType(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Резервні копії',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Керування резервними копіями:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _createBackup,
                              icon: const Icon(Icons.backup),
                              label: const Text('Створити резервну копію'),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _restoreFromBackup,
                              icon: const Icon(Icons.restore),
                              label: const Text('Відновити з резервної копії'),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _showStorageInfo,
                              icon: const Icon(Icons.info_outline),
                              label: const Text('Інформація про сховище'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Поточне сховище: ${_getStorageTypeName(_currentStorage)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentStorage == StorageManager.StorageType.local
                              ? 'Дані зберігаються локально на пристрої'
                              : _currentStorage == StorageManager.StorageType.googleDrive
                                  ? 'Дані синхронізуються з Google Drive'
                                  : 'Дані зберігаються в Firebase',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}