import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trophy_collection_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    saveTrophy();
  }

  Future<void> saveTrophy() async {
    final prefs = await SharedPreferences.getInstance();
    if (widget.score >= 2) {
      await prefs.setBool("trophy_science", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool wonTrophy = widget.score >= 2;
    int incorrectAnswers = widget.totalQuestions - widget.score;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Confetti animation - to be edited sizing, not yet aligned properly
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset('assets/confetti.gif', fit: BoxFit.cover),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (wonTrophy) ...[
                    Image.asset('assets/trophy2.png', height: 220),
                    const SizedBox(height: 20),
                    const Text(
                      "Congratulations!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.sentiment_neutral,
                      size: 80,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 20),

                  // Score breakdown
                  Container(
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
  ),
  child: Column(
    children: [
      Text(
        "Your Score: ${widget.score}/${widget.totalQuestions}",
        style: const TextStyle(
          fontSize: 24,
          color: Colors.amber,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                '${widget.score}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Row(
            children: [
              const Icon(Icons.cancel, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                '$incorrectAnswers',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),


                  const SizedBox(height: 40),

                  // Back to home button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
