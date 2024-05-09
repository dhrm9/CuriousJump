import 'package:android_component/database/database.dart';
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
  bool showExistingUser = false;
  late List<dynamic> allData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF201e30), // Background color
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (showExistingUser == true) {
                setState(() {
                  showExistingUser = false;
                });
              }
            },
            child: SingleChildScrollView(
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
                      onTap: () {
                        setState(() {
                          showExistingUser = false;
                        });
                      },
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
                          playerName = _nameController
                              .text; // Get player's name from text field
                        });
                        getPlayerData(
                            playerName!); // Get player data from database
                      },
                      child: const Text('Continue'),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          allData = Database.getPlayerList();
                          showExistingUser = true;
                        });
                      },
                      child: const Text('Existing User !'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          showExistingUser == true
              ? Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust border radius as needed
                      side: const BorderSide(
                          color: Colors.white,
                          width: 4.0), // Add border color and width
                    ),
                    color: const Color(0xFF201e30),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Player List",
                              style: TextStyle(color: Colors.yellow),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: allData
                                      .map(
                                        (data) => Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _nameController.text = data;
                                                  showExistingUser = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Border color
                                                    width: 1.0, // Border width
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        data,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Function to get player data from the database
  void getPlayerData(String playerName) async {
    if (playerName.isEmpty) {
      // If playerName is empty, show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // Snackbar content
          content: Center(
            child: Text(
              'Name can\'t be empty!', // Message shown in the Snackbar
              style: TextStyle(
                color: Colors.white, // Text color
              ),
            ),
          ),
          duration: Duration(
              seconds: 2), // Optional, specify duration for the Snackbar
        ),
      );
      return;
    }

    // Get player data from the database using the player's name
    PlayerData playerData = Database.getPlayerData(playerName);
    // Navigate to the main menu screen with the player data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainMenu(playerData: playerData),
      ),
    );
  }
}
