# 📚 Quizmos

Quizmos is a **Flutter-based quiz game app** where users can test their knowledge through fun and interactive quizzes.  
It features multiple screens for navigation, question/answer flow, results, rewards, and a splash intro.  

---

##  Features  
- **Welcome Screen** – Main navigation home screen  
- **Splash Screen** – Intro loading screen before the game starts  
- **Quiz Screen** – Displays questions and multiple-choice answers  
- **Trophy Screen** – Shows stamp card and results if answers are right or wrong  
- **Result Screen** – Displays the final score and total results  

---

##  Project Structure  
```
lib/
│── main.dart               # Entry point of the app
│ ── welcome_screen.dart # Home/Navigation screen
│ ── splash_screen.dart  # App intro/splash
│ ── quiz_screen.dart    # Question & answer flow
│ ── result_screen.dart  # Final results display
│ ── trophy_screen.dart  # Rewards/stamp card & answer feedback
```

---

##  Getting Started  

### 1. Prerequisites  
Make sure you have installed:  
- [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- [Dart SDK](https://dart.dev/get-dart) (included in Flutter)  
- Android Studio / VS Code with Flutter extension  

Check installation with:  
```bash
flutter doctor
```

---

### 2. Clone the Repository  
```bash
git clone https://github.com/archieeroll/quiz_game_app.git
cd quiz_game_app
```

---

### 3. Install Dependencies  
```bash
flutter pub get
```

---

### 4. Run the App  
- For **Android Emulator**:  
  ```bash
  flutter run
  ```  
- For **iOS Simulator**:  
  ```bash
  flutter run
  ```  

---

##  Dependencies  
Make sure these are included in your `pubspec.yaml`:  
```yaml
dependencies:
  flutter:
    sdk: flutter
    cupertino_icons: ^1.0.8
  provider: ^6.0.5
  shared_preferences: ^2.1.1
  flutter_svg: ^2.0.7
  http: ^1.1.0
  google_fonts: ^6.0.0
  percent_indicator: ^4.2.2
  flutter_spinkit: ^5.1.0
```

---



