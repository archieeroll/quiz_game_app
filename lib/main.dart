import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'trophy_collection_screen.dart';
import 'splash_screen.dart';




void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Science Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'MadimiOne'),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Science Quiz")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Start Quiz"),
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("My Trophies"),
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrophyCollectionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

