import 'package:flutter/material.dart';
import 'package:hunting_signals/models/hunting_models.dart';
import 'package:hunting_signals/services/admin_service.dart';
import 'package:hunting_signals/services/hunting_data_service.dart';

class AddEducationScreen extends StatefulWidget {
  const AddEducationScreen({super.key});

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DifficultyLevel _selectedDifficulty = DifficultyLevel.beginner;
  EducationType _selectedType = EducationType.article;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _videoController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додати навчальний матеріал'),
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
                  controller: _titleController,
                  label: 'Заголовок матеріалу *',
                  hint: 'Введіть заголовок навчального матеріалу',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть заголовок';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Опис матеріалу *',
                  hint: 'Короткий опис навчального матеріалу',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть опис';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownField<DifficultyLevel>(
                  label: 'Рівень складності',
                  value: _selectedDifficulty,
                  items: DifficultyLevel.values,
                  itemLabel: (level) {
                    switch (level) {
                      case DifficultyLevel.beginner:
                        return 'Початківець';
                      case DifficultyLevel.intermediate:
                        return 'Середній';
                      case DifficultyLevel.advanced:
                        return 'Просунутий';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownField<EducationType>(
                  label: 'Тип матеріалу',
                  value: _selectedType,
                  items: EducationType.values,
                  itemLabel: (type) {
                    switch (type) {
                      case EducationType.article:
                        return 'Стаття';
                      case EducationType.video:
                        return 'Відео';
                      case EducationType.audio:
                        return 'Аудіо';
                      case EducationType.interactive:
                        return 'Інтерактивний';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Контент'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _contentController,
                  label: 'Зміст матеріалу *',
                  hint: 'Основний зміст навчального матеріалу',
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть зміст матеріалу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _categoryController,
                  label: 'Категорія *',
                  hint: 'Наприклад: Нотна грамота, Теорія, Практика',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть категорію';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Мультимедійні файли'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _videoController,
                  label: 'Відео файл',
                  hint: 'URL або шлях до відео файлу',
                  icon: Icons.videocam,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _imageController,
                  label: 'Зображення',
                  hint: 'URL або шлях до зображення',
                  icon: Icons.image,
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Теги'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _tagsController,
                  label: 'Теги',
                  hint: 'Через кому, наприклад: ноти, теорія, практика',
                ),
                
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Зберегти навчальний матеріал',
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
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
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

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newMaterial = EducationMaterial(
        id: 'edu_admin_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        content: _contentController.text,
        videoUrl: _videoController.text.isNotEmpty ? _videoController.text : null,
        imageUrl: _imageController.text.isNotEmpty ? _imageController.text : null,
        category: _categoryController.text,
        difficulty: _selectedDifficulty,
        tags: _tagsController.text.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList(),
        createdAt: DateTime.now(),
      );

      // Add the educational material to Firebase through admin service
      final success = await AdminService.addEducationalMaterial(newMaterial);

      if (success) {
        if (mounted) {
          AdminService.showSuccessMessage(context, 'Навчальний матеріал успішно додано до Firebase!');
          // Also add to local storage for immediate availability
          HuntingDataService.addEducationMaterial(newMaterial);
        }
      } else {
        if (mounted) {
          AdminService.showErrorMessage(context, 'Помилка при додаванні навчального матеріалу');
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}