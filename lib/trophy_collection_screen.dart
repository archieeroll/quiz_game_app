import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrophyCollectionScreen extends StatefulWidget {
  const TrophyCollectionScreen({super.key});

  @override
  State<TrophyCollectionScreen> createState() => _TrophyCollectionScreenState();
}

class _TrophyCollectionScreenState extends State<TrophyCollectionScreen> {
  bool hasScienceTrophy = false;

  @override
  void initState() {
    super.initState();
    loadTrophies();
  }

  Future<void> loadTrophies() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasScienceTrophy = prefs.getBool("trophy_science") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Trophies")),
      body: Center(
        child: hasScienceTrophy
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/quizmos_icon.png", height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    "🏆 Science Trophy Earned!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Text("No trophies earned yet 😢"),
      ),
    );
  }
}
