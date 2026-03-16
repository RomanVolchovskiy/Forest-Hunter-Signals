import 'package:flutter/material.dart';

class HuntingSignal {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? audioUrl;
  final String? videoUrl;
  final String? notationUrl;
  final String? imageUrl;
  final int duration;
  final List<String>? tags;
  final String? historicalInfo;
  final String? usageInstructions;
  final bool isFavorite;

  HuntingSignal({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.audioUrl,
    this.videoUrl,
    this.notationUrl,
    this.imageUrl,
    required this.duration,
    this.tags,
    this.historicalInfo,
    this.usageInstructions,
    this.isFavorite = false,
  });

  HuntingSignal copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? audioUrl,
    String? videoUrl,
    String? notationUrl,
    String? imageUrl,
    int? duration,
    List<String>? tags,
    String? historicalInfo,
    String? usageInstructions,
    bool? isFavorite,
  }) {
    return HuntingSignal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      notationUrl: notationUrl ?? this.notationUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      historicalInfo: historicalInfo ?? this.historicalInfo,
      usageInstructions: usageInstructions ?? this.usageInstructions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'HuntingSignal{id: $id, name: $name, category: $category}';
  }
}

class SignalCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;

  SignalCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class HuntingEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final List<String> recommendedSignals;
  final String? imagePath;
  final bool isCustom;

  HuntingEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.recommendedSignals,
    this.imagePath,
    this.isCustom = false,
  });
}

class EducationMaterial {
  final String id;
  final String title;
  final String description;
  final EducationType type;
  final String content;
  final String? videoUrl;
  final String? imageUrl;
  final String category;
  final DifficultyLevel difficulty;
  final List<String> tags;
  final DateTime createdAt;

  EducationMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    this.videoUrl,
    this.imageUrl,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.createdAt,
  });
}

class Playlist {
  final String id;
  final String title;
  final String description;
  final DateTime createdDate;
  final List<String> signalIds;
  final bool isDefault;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.signalIds,
    this.isDefault = false,
  });
}

enum EducationType {
  article,
  video,
  audio,
  interactive,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}