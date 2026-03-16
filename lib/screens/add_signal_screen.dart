import 'package:flutter/material.dart';
import 'package:hunting_signals/models/hunting_models.dart';
import 'package:hunting_signals/services/admin_service.dart';
import 'package:hunting_signals/services/hunting_data_service.dart';

class AddSignalScreen extends StatefulWidget {
  const AddSignalScreen({super.key});

  @override
  State<AddSignalScreen> createState() => _AddSignalScreenState();
}

class _AddSignalScreenState extends State<AddSignalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _audioController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _notationController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _historicalController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _audioController.dispose();
    _videoController.dispose();
    _notationController.dispose();
    _imageController.dispose();
    _historicalController.dispose();
    _usageController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додати новий сигнал'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown[100]!,
              Colors.brown[50]!,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Основна інформація'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _nameController,
                  label: 'Назва сигналу *',
                  hint: 'Введіть назву сигналу',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть назву сигналу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Опис сигналу *',
                  hint: 'Введіть опис сигналу',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть опис сигналу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _categoryController,
                  label: 'Категорія *',
                  hint: 'Наприклад: Організаційні, Святкові, Традиційні',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть категорію';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _durationController,
                  label: 'Тривалість (секунди)',
                  hint: 'Наприклад: 30',
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Мультимедійні файли'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _audioController,
                  label: 'Аудіо файл',
                  hint: 'URL або шлях до аудіо файлу',
                  icon: Icons.audiotrack,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _videoController,
                  label: 'Відео файл',
                  hint: 'URL або шлях до відео файлу',
                  icon: Icons.videocam,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _notationController,
                  label: 'Файл з нотами',
                  hint: 'URL або шлях до файлу з нотами',
                  icon: Icons.music_note,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _imageController,
                  label: 'Зображення',
                  hint: 'URL або шлях до зображення',
                  icon: Icons.image,
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Додаткова інформація'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _historicalController,
                  label: 'Історична інформація',
                  hint: 'Історична довідка про сигнал',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _usageController,
                  label: 'Інструкції з використання',
                  hint: 'Коли і як використовувати цей сигнал',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _tagsController,
                  label: 'Теги',
                  hint: 'Через кому, наприклад: традиція, святковий, трофей',
                ),
                
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Зберегти сигнал',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int? maxLines,
    TextInputType? keyboardType,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
      ),
      validator: validator,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newSignal = HuntingSignal(
        id: 'admin_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        audioUrl: _audioController.text.isNotEmpty ? _audioController.text : null,
        videoUrl: _videoController.text.isNotEmpty ? _videoController.text : null,
        notationUrl: _notationController.text.isNotEmpty ? _notationController.text : null,
        imageUrl: _imageController.text.isNotEmpty ? _imageController.text : null,
        duration: int.tryParse(_durationController.text) ?? 30,
        tags: _tagsController.text.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList(),
        historicalInfo: _historicalController.text.isNotEmpty ? _historicalController.text : null,
        usageInstructions: _usageController.text.isNotEmpty ? _usageController.text : null,
        isFavorite: false,
      );

      // Add the signal to Firebase through admin service
      try {
        final success = await AdminService.addHuntingSignal(newSignal);

        if (!mounted) return;
        
        if (success) {
          if (mounted) {
            AdminService.showSuccessMessage(context, 'Сигнал успішно додано до Firebase!');
            // Also add to local storage for immediate availability
            HuntingDataService.addSignal(newSignal);
          }
        } else {
          if (mounted) {
            AdminService.showErrorMessage(context, 'Помилка при додаванні сигналу');
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Сигнал "${_nameController.text}" успішно додано!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      // Error handling is done in the catch block above
    }
  }
}