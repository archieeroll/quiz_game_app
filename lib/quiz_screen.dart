import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 
import 'result_screen.dart';
import 'trophy_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  int score = 0;
  String? selectedOption;
  late AnimationController _progressController;
  late AnimationController _cardController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cardAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer(); 

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What planet is known as the Red Planet?",
      "options": ["A. Mercury", "B. Venus", "C. Mars", "D. Jupiter"],
      "answer": "C. Mars",
    },
    {
      "question":
          "What is the name of the galaxy that contains our Solar System?",
      "options": [
        "A. Andromeda Galaxy",
        "B. Milky Way Galaxy",
        "C. Whirlpool Galaxy",
        "D. Black Eye Galaxy",
      ],
      "answer": "B. Milky Way Galaxy",
    },
    {
      "question": "Which planet has the most moons?",
      "options": ["A. Earth", "B. Jupiter", "C. Saturn", "D. Neptune"],
      "answer": "B. Jupiter",
    },
    {
      "question": "What is a supernova?",
      "options": [
        "A. A collision of two stars",
        "B. A black hole eating a star",
        "C. The explosion of a star",
        "D. A new star being born",
      ],
      "answer": "C. The explosion of a star",
    },
    {
      "question": "Who was the first woman to travel into space?",
      "options": [
        "A. Sally Ride",
        "B. Valentina Tereshkova",
        "C. Mae Jemison",
        "D. Kalpana Chawla",
      ],
      "answer": "B. Valentina Tereshkova",
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _progressController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    _audioPlayer.dispose(); 
    super.dispose();
  }

  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/select.mp3'), volume: 0.4);
    } catch (e) {
      debugPrint("Failed to play sound: $e");
    }
  }

  void checkAnswer(String selected) {
    bool isCorrect = selected == questions[currentIndex]["answer"];
    if (isCorrect) score++;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrophyScreen(
          isCorrect: isCorrect,
          currentScore: score,
          totalQuestions: questions.length,
          onNext: () {
            Navigator.pop(context);
            if (currentIndex < questions.length - 1) {
              setState(() {
                currentIndex++;
                selectedOption = null;
              });
              _cardController.reset();
              _progressController.reset();
              _startAnimations();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultScreen(
                    score: score,
                    totalQuestions: questions.length,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header with level and progress
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      // Level indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber, Colors.orange],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "SPACE QUIZ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Question counter
                      Text(
                        "Question ${currentIndex + 1} of ${questions.length}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Progress bar
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white24,
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress * _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: LinearGradient(
                                    colors: [Colors.amber, Colors.orange],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Question text
                Text(
                  q["question"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 32),

                // Question card with animation
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              

                              // Options
                              Expanded(
                                child: ListView.builder(
                                  itemCount: q["options"].length,
                                  itemBuilder: (context, index) {
                                    final option = q["options"][index];
                                    final isSelected = option == selectedOption;

                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Material(
                                        elevation: isSelected ? 8 : 2,
                                        borderRadius: BorderRadius.circular(16),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          onTap: () async {
                                            await _playClickSound(); 
                                            setState(() {
                                              selectedOption = option;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gradient: isSelected
                                                  ? LinearGradient(
                                                      colors: [
                                                        Colors.purple.shade400,
                                                        Colors.purple.shade600,
                                                      ],
                                                    )
                                                  : null,
                                              color: isSelected
                                                  ? null
                                                  : Colors.grey.shade50,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors
                                                                .grey
                                                                .shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: isSelected
                                                      ? const Icon(
                                                          Icons.check,
                                                          size: 16,
                                                          color: Colors.purple,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Text(
                                                    option,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF2D3748,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Submit button
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedOption != null
                                        ? Colors.purple
                                        : Colors.grey.shade300,
                                    foregroundColor: selectedOption != null
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    elevation: selectedOption != null ? 8 : 0,
                                    shadowColor: Colors.amber.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: selectedOption != null
                                      ? () => checkAnswer(selectedOption!)
                                      : null,
                                  child: Text(
                                    selectedOption != null
                                        ? "SUBMIT ANSWER"
                                        : "SELECT AN OPTION",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
