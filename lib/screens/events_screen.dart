import 'package:flutter/material.dart';
import 'package:hunting_signals/theme/hunting_theme.dart';
import 'package:hunting_signals/widgets/category_header.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryHeader(
            title: 'Мисливські Події',
            subtitle: 'Організуйте свої мисливські заходи',
            icon: Icons.event,
          ),
          const SizedBox(height: 24),
          
          // Create Event Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement create event functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функція створення подій буде доступна незабаром')),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Створити подію'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HuntingTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Upcoming Events Section
          Text(
            'Майбутні події',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          
          // Event Cards
          _buildEventCard(
            'Відкриття сезону',
            '15 жовтня 2024',
            'Традиційне відкриття мисливського сезону з урочистою церемонією',
            Icons.star,
            Colors.amber,
          ),
          
          const SizedBox(height: 12),
          
          _buildEventCard(
            'Свято мисливської музики',
            '28 жовтня 2024',
            'Фестиваль традиційної мисливської сигнальної музики',
            Icons.music_note,
            Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          // Recommended Signals Section
          Text(
            'Рекомендовані сигнали',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRecommendedSignal(
            'Сигнал збору',
            'Інформаційні сигнали',
            'Для початку мисливського заходу',
          ),
          
          const SizedBox(height: 12),
          
          _buildRecommendedSignal(
            'Сигнал закінчення',
            'Організаційні сигнали', 
            'Для завершення мисливської події',
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    String title,
    String date,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 18,
              ),
              onPressed: () {
                // TODO: Implement event details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Деталі події будуть доступні незабаром')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSignal(
    String name,
    String category,
    String purpose,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: HuntingTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.surround_sound,
                color: HuntingTheme.primaryDark,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    purpose,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: HuntingTheme.primaryColor,
                size: 24,
              ),
              onPressed: () {
                // TODO: Implement play recommended signal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Відтворення: $name')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}