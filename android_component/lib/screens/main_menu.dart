import 'package:android_component/quiz/quiz.dart';
import 'package:android_component/screens/game_screen.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  QuizLevel selectedLevel = QuizLevel.easy;
  QuizType selectedGameType = QuizType.animal;
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/Background/BackGround.png'),
          fit: BoxFit.fill,
        )),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // First column of buttons (aligned to the left)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Level",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedLevel = QuizLevel.easy;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedLevel == QuizLevel.easy
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Easy'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedLevel = QuizLevel.medium;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedLevel == QuizLevel.medium
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Medium'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedLevel = QuizLevel.hard;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedLevel == QuizLevel.hard
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Hard'),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Curious Jump",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => GameScreen(
                                      isSoundOn: isSoundOn,
                                      quizLevel: selectedLevel,
                                      quizType: selectedGameType,
                                    ),
                                  ));
                                },
                                icon: Image.asset(
                                    'assets/images/Menu/Buttons/PlayN.png'),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSoundOn = !isSoundOn;
                                  });
                                },
                                icon: isSoundOn
                                    ? Image.asset(
                                        'assets/images/Menu/Buttons/SoundOn.png')
                                    : Image.asset(
                                        'assets/images/Menu/Buttons/SoundOff.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      // Second column of buttons (aligned to the right)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Game Type",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGameType = QuizType.animal;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedGameType == QuizType.animal
                                      ? Color.fromARGB(255, 224, 217, 73)
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Animal'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGameType = QuizType.fruits;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedGameType == QuizType.fruits
                                      ? Color.fromARGB(255, 255, 55, 55)
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Fruits'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGameType = QuizType.capital;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedGameType == QuizType.capital
                                      ? Color.fromARGB(255, 21, 0, 255)
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Capital'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGameType = QuizType.maths;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedGameType == QuizType.maths
                                      ? Color.fromARGB(255, 251, 0, 255)
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Maths'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGameType = QuizType.vegetables;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  selectedGameType == QuizType.vegetables
                                      ? Color.fromARGB(255, 0, 255, 81)
                                      : Colors.grey,
                                ),
                              ),
                              child: const Text('Vegetables'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Row of play, pause, and mute buttons (middle of the screen)
                ],
              ),
            ),
          ),
        ),
    );
  }
}
