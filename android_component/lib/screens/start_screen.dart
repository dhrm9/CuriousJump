import 'package:android_component/models/database.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/screens/main_menu.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? playerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF201e30),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            120,
            20,
            20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Enter your name',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    playerName = _nameController.text;
                  });
                  getPlayerData(playerName!);
                },
                child: const Text('Continue'),
              ),
              const SizedBox(height: 20),
              // playerName != null
              //     ? Text('Player Name: $playerName', style: const TextStyle(color: Colors.white),)
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void getPlayerData(String playerName) async {
    PlayerData playerData = Database.getPlayerData(playerName);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainMenu(playerData:playerData),
      ),
    );
  }
}
