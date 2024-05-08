import 'package:android_component/models/database.dart';
import 'package:android_component/models/player_data.dart';
import 'package:android_component/screens/main_menu.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? playerName; // Player's name entered in the text field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF201e30), // Background color
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
              // Text field for entering player's name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Enter your name',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Button to continue to the main menu
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    playerName = _nameController.text; // Get player's name from text field
                  });
                  getPlayerData(playerName!); // Get player data from database
                },
                child: const Text('Continue'),
              ),
              const SizedBox(height: 20),
              // Display player's name (if entered)
              // playerName != null
              //     ? Text('Player Name: $playerName', style: const TextStyle(color: Colors.white),)
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to get player data from the database
  void getPlayerData(String playerName) async {
    // Get player data from the database using the player's name
    PlayerData playerData = Database.getPlayerData(playerName);
    // Navigate to the main menu screen with the player data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainMenu(playerData:playerData),
      ),
    );
  }
}
