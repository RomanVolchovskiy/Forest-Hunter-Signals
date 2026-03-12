# 🔥 Firebase Integration Guide
## Forest-Hunter-Signals · Flutter App

---

## 📁 Змінені / нові файли

| Файл | Статус | Опис |
|------|--------|------|
| `pubspec.yaml` | ✏️ Оновлено | Додано Firebase залежності |
| `lib/main.dart` | ✏️ Оновлено | Ініціалізація Firebase при старті |
| `lib/firebase_options.dart` | 🆕 Новий | Конфігурація Firebase платформ |
| `lib/services/firebase_service.dart` | 🆕 Новий | Всі операції з Firestore |
| `lib/services/hunting_data_service.dart` | ✏️ Оновлено | Використовує Firebase як основне джерело |
| `lib/services/data_persistence_service.dart` | ✏️ Оновлено | Тепер офлайн-кеш (SharedPreferences) |
| `firestore.rules` | 🆕 Новий | Правила безпеки Firestore |

---

## 🚀 Крок 1: Створення Firebase проекту

1. Перейди на [console.firebase.google.com](https://console.firebase.google.com)
2. Натисни **"Add project"** → назви `forest-hunter-signals`
3. Google Analytics — за бажанням
4. Натисни **"Create project"**

---

## 📱 Крок 2: Додавання платформ

### Android
1. У Firebase Console → **"Add app"** → Android
2. **Package name**: знайди у `android/app/build.gradle` (поле `applicationId`)
   - Зазвичай: `com.example.hunting_signals`
3. Завантаж `google-services.json`
4. Помісти файл у: `android/app/google-services.json`
5. У `android/build.gradle` додай у `buildscript > dependencies`:
   ```groovy
   classpath 'com.google.gms:google-services:4.4.2'
   ```
6. У `android/app/build.gradle` внизу додай:
   ```groovy
   apply plugin: 'com.google.gms.google-services'
   ```

### iOS
1. У Firebase Console → **"Add app"** → iOS
2. **Bundle ID**: знайди у `ios/Runner.xcodeproj` або `ios/Runner/Info.plist`
   - Зазвичай: `com.example.huntingSignals`
3. Завантаж `GoogleService-Info.plist`
4. Відкрий Xcode → перетягни файл у `Runner/Runner/`
5. Обов'язково постав ✅ **"Copy items if needed"**

---

## ⚙️ Крок 3: Генерація firebase_options.dart (рекомендовано)

Найпростіший спосіб — використати **FlutterFire CLI**:

```bash
# 1. Встанови FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Запусти конфігурацію (у корені проекту)
flutterfire configure

# 3. Вибери свій Firebase-проект та платформи (Android, iOS)
# CLI автоматично згенерує lib/firebase_options.dart
```

> **Якщо CLI не доступний** — заміни значення у `lib/firebase_options.dart` вручну
> (знайди їх у Firebase Console → Project Settings → Your apps)

---

## 📦 Крок 4: Встановлення залежностей

```bash
flutter pub get
```

---

## 🗄️ Крок 5: Налаштування Firestore

1. У Firebase Console → **Firestore Database** → **"Create database"**
2. Вибери **"Start in test mode"** (для розробки)
3. Обери регіон (рекомендовано: `europe-west3` для України)
4. Натисни **"Done"**

### Структура колекцій (створюється автоматично при першому запуску):

```
Firestore
├── signals/          ← HuntingSignal (мисливські сигнали)
│   └── {docId}
│       ├── name: string
│       ├── description: string
│       ├── category: string
│       ├── audioUrl: string?
│       ├── videoUrl: string?
│       ├── notationUrl: string?
│       ├── imageUrl: string?
│       ├── duration: number
│       ├── tags: array
│       ├── historicalInfo: string?
│       ├── usageInstructions: string?
│       ├── isFavorite: boolean
│       └── createdAt: timestamp
│
├── education/        ← EducationMaterial (навчальні матеріали)
│   └── {docId}
│       ├── title: string
│       ├── description: string
│       ├── type: string (article|video|audio|interactive)
│       ├── content: string
│       ├── category: string
│       ├── difficulty: string (beginner|intermediate|advanced)
│       ├── tags: array
│       └── createdAt: timestamp
│
├── categories/       ← SignalCategory (категорії)
│   └── {docId}
│       ├── name: string
│       ├── description: string
│       ├── icon: string
│       └── colorValue: number
│
└── events/           ← HuntingEvent (мисливські події)
    └── {docId}
        ├── title: string
        ├── description: string
        ├── date: timestamp
        ├── location: string
        ├── recommendedSignals: array
        └── isCustom: boolean
```

---

## 🔒 Крок 6: Правила безпеки Firestore

Скопіюй вміст файлу `firestore.rules` у Firebase Console:
**Firestore → Rules → Edit rules → Publish**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /signals/{signalId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /education/{materialId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /events/{eventId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 🔄 Як використовувати StreamBuilder (оновлення в реальному часі)

Заміни `FutureBuilder` на `StreamBuilder` у скринах:

```dart
// БУЛО (FutureBuilder):
FutureBuilder<List<HuntingSignal>>(
  future: HuntingDataService.getAllSignals(),
  builder: (context, snapshot) { ... }
)

// СТАЛО (StreamBuilder — автооновлення):
StreamBuilder<List<HuntingSignal>>(
  stream: HuntingDataService.signalsStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Помилка: ${snapshot.error}');
    }
    final signals = snapshot.data ?? [];
    return ListView.builder(
      itemCount: signals.length,
      itemBuilder: (context, index) => SignalTile(signal: signals[index]),
    );
  },
)
```

---

## ✅ Переваги після інтеграції

| Функція | До | Після |
|---------|----|----|
| Збереження даних | SharedPreferences (локально) | Cloud Firestore (хмарно) |
| Синхронізація між пристроями | ❌ Немає | ✅ Автоматична |
| Оновлення контенту | Потрібне оновлення APK | ✅ Realtime без оновлень |
| Офлайн-підтримка | ✅ SharedPreferences | ✅ Firestore + SharedPreferences кеш |
| Адмін додає контент | Лише локально | ✅ Всі бачать відразу |
| Масштабованість | Обмежена | ✅ Необмежена |

---

## 🛠️ Корисні команди

```bash
# Запустити застосунок
flutter run

# Перевірити залежності
flutter pub get

# Очистити кеш Flutter
flutter clean && flutter pub get

# Перевірити Firebase підключення
flutter run --verbose
```

---

## ❓ Поширені помилки

### `google-services.json not found`
→ Переконайся, що файл знаходиться у `android/app/` (не у корені проекту)

### `FirebaseException: [core/no-app]`
→ Перевір, що `await Firebase.initializeApp()` викликається до `runApp()`

### `PERMISSION_DENIED`
→ Перевір правила безпеки у Firestore Console

### iOS Build Error
→ Запусти `cd ios && pod install && cd ..`
