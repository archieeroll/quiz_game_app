import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 

class TrophyScreen extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onNext;
  final int currentScore;
  final int totalQuestions;

  const TrophyScreen({
    super.key,
    required this.isCorrect,
    required this.onNext,
    required this.currentScore,
    required this.totalQuestions,
  });

  @override
  State<TrophyScreen> createState() => _TrophyScreenState();
}

class _TrophyScreenState extends State<TrophyScreen>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _stampController;
  late Animation<double> _trophyScale;
  late Animation<double> _trophyGlow;
  late Animation<double> _stampScale;
  final AudioPlayer _audioPlayer = AudioPlayer(); 

  @override
  void initState() {
    super.initState();

    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _stampController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _trophyScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut),
    );

    _trophyGlow = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.easeInOut),
    );

    _stampScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _stampController, curve: Curves.bounceOut),
    );

    // Start animations
    _trophyController.forward();
    if (widget.isCorrect) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _stampController.forward();
      });
    }

    // Play win or fail sound
    Future.delayed(const Duration(milliseconds: 100), () async {
      try {
        if (widget.isCorrect) {
          await _audioPlayer.play(AssetSource('sounds/win.mp3'), volume: 0.7);
        } else {
          await _audioPlayer.play(AssetSource('sounds/fail.mp3'), volume: 0.7);
        }
      } catch (e) {
        debugPrint("Failed to play result sound: $e");
      }
    });

    // Auto-close after showing the result
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        widget.onNext();
      }
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _stampController.dispose();
    _audioPlayer.dispose(); 
    super.dispose();
  }

  Widget _buildStampCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Progress Card",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.totalQuestions, (index) {
              bool isEarned = index < widget.currentScore;
              bool isNewStamp =
                  widget.isCorrect && index == widget.currentScore - 1;

              return AnimatedBuilder(
                animation: _stampController,
                builder: (context, child) {
                  double scale = isNewStamp ? _stampScale.value : 1.0;

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isEarned ? Colors.amber : Colors.grey.shade200,
                        border: Border.all(
                          color: isEarned
                              ? Colors.orange
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: isEarned
                            ? [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isEarned
                            ? const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            "${widget.currentScore}/${widget.totalQuestions} Stars Earned",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isCorrect
                ? [Colors.green.shade400, Colors.green.shade700]
                : [Colors.red.shade400, Colors.red.shade700],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_trophyController, _stampController]),
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: _trophyScale.value,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3 * _trophyGlow.value),
                            Colors.white,
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(
                              0.3 * _trophyGlow.value,
                            ),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: widget.isCorrect
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  // circular glow
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber,
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/happy_quizmos.gif",
                                    height: 160,
                                  ),
                                ],
                              )
                            : Image.asset(
                                "assets/sad_quizmos.gif",
                                height: 160,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Result text
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      widget.isCorrect ? "Excellent!" : "Nice Try! ",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Stamp card system
                  _buildStampCard(),

                  const SizedBox(height: 20),

                  // Auto-close indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Auto-continuing...",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
