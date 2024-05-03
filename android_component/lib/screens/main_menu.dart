import 'package:android_component/screens/game_screen.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pixel Adventure",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => GameScreen(
                          isSoundOn: isSoundOn,
                        ),
                      ));
                    },
                    icon: Image.asset('assets/images/Menu/Buttons/PlayN.png'),
                  ),
                  IconButton(
                    onPressed: () {
                     setState(() {
                       isSoundOn = !isSoundOn;
                     });
                    },
                    icon: isSoundOn ? Image.asset('assets/images/Menu/Buttons/SoundOn.png'):Image.asset('assets/images/Menu/Buttons/SoundOff.png'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
