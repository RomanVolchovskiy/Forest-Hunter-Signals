# Hunting Signals - Мисливські Сигнали

Додаток для вивчення та прослуховування традиційних мисливських сигналів з категоріями, аудіо, відео, нотами та навчальними матеріалами.

## 🎯 Особливості

- **Аудіо сигнали** - Прослуховування традиційних мисливських сигналів
- **Відео матеріали** - Навчальні відео по техніці виконання
- **Ноти** - Нотні записи для кожного сигналу
- **Категорії** - Зручна система категорій для навігації
- **Освітні матеріали** - Історія та культура мисливської сигнальної музики
- **Google Drive інтеграція** - Зберігання даних у хмарі
- **Офлайн режим** - Робота без інтернету з подальшою синхронізацією

## 🚀 Як розпочати розробку

### Вимоги
- Flutter 3.35.4
- Dart 3.9.2
- Android Studio / IntelliJ IDEA
- Android SDK API Level 35

### Встановлення

1. **Клонуйте репозиторій:**
```bash
git clone https://github.com/RomanVolchovskiy/Forest-Hunter-Signals.git
cd Forest-Hunter-Signals
```

2. **Встановіть залежності:**
```bash
flutter pub get
```

3. **Налаштуйте Google Drive API:**
   - Перейдіть до [Google Cloud Console](https://console.cloud.google.com/)
   - Створіть новий проєкт
   - Увімкніть Google Drive API та Google Sign-In
   - Завантажте `google-services.json` та помістіть в `android/app/`

4. **Запустіть додаток:**
```bash
flutter run
```

## 📱 Android Studio інструкція

1. **Відкрийте проєкт в Android Studio:**
   - Відкрийте Android Studio
   - Виберіть "Open an existing Android Studio project"
   - Вкажіть шлях до папки проєкту

2. **Налаштуйте Flutter SDK:**
   - File → Settings → Languages & Frameworks → Flutter
   - Вкажіть шлях до Flutter SDK

3. **Налаштуйте Android SDK:**
   - File → Settings → Appearance & Behavior → System Settings → Android SDK
   - Встановіть Android API Level 35

4. **Запустіть проєкт:**
   - Натисніть кнопку "Run" або використовуйте Shift+F10

## 🔧 Налаштування Google Drive

1. **Створіть OAuth 2.0 клієнта:**
   - Тип програми: Android
   - Package name: `com.huntingsignals.audio`
   - SHA-1 fingerprint: отримайте з команди `keytool -list -v -keystore ~/.android/debug.keystore`

2. **Увімкніть API:**
   - Google Drive API
   - Google Sign-In API

3. **Оновіть `android/app/google-services.json`** з вашого проєкту

## 📁 Структура проєкту

```
lib/
├── main.dart                    # Головний файл додатку
├── services/
│   ├── google_drive_service.dart # Google Drive інтеграція
│   ├── local_storage_service.dart # Локальне збереження
│   └── storage_manager.dart    # Управління збереженням
├── models/
│   ├── signal.dart             # Модель сигналу
│   ├── category.dart           # Модель категорії
│   └── user.dart               # Модель користувача
├── screens/
│   ├── home_screen.dart        # Головний екран
│   ├── signal_list_screen.dart # Список сигналів
│   ├── signal_detail_screen.dart # Деталі сигналу
│   ├── category_screen.dart    # Екран категорій
│   └── admin_screen.dart       # Адмін панель
└── widgets/
    ├── signal_card.dart        # Карточка сигналу
    ├── category_card.dart      # Карточка категорії
    └── audio_player.dart       # Аудіо плеєр
```

## 🔐 Адмін панель

- **Пароль адміністратора:** 1488
- Доступ до управління сигналами, категоріями та користувачами
- Можливість додавати, редагувати та видаляти контент

## 🎵 Аудіо формати

Підтримувані формати: MP3, WAV, AAC

## 📸 Зображення

Підтримувані формати: JPG, PNG, SVG

## 🎥 Відео

Підтримувані формати: MP4, AVI, MOV

## 📄 Ноти

Підтримувані формати: PDF, PNG, JPG

## 🛠 Розробка

### Код стандарти
- Використовуйте `flutter analyze` для перевірки коду
- Використовуйте `dart format .` для форматування
- Дотримуйтесь Flutter best practices

### Тестування
```bash
flutter test
```

### Білд для релізу
```bash
flutter build apk --release
```

## 📱 Підтримувані платформи

- Android (API 21+)
- iOS (якщо потрібно)
- Web

## 📞 Підтримка

Якщо у вас виникли проблеми:
1. Перевірте що всі залежності встановлені (`flutter pub get`)
2. Перевірте Google Drive налаштування
3. Перевірте інтернет з'єднання

## 📄 Ліцензія

Цей проєкт розповсюджується під ліцензією MIT.

## 🎨 Інтерфейс

Додаток використовує Material Design 3 для сучасного вигляду.

---

**Розроблено для:** Прикарпатського професійного коледжу лісового господарства та туризму
**Автор:** Роман Волчовський
**Спеціальність:** Мисливські сигнали: культура та історія полювання