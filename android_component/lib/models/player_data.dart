import 'package:hive/hive.dart';

// Class to represent player data
class PlayerData {
  String playerName; // Name of the player
  Map<String, int> scores; // Map to store quiz scores

  // Constructor for PlayerData class
  PlayerData({required this.playerName, required this.scores});
}

// Hive TypeAdapter for PlayerData class
class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0; // Unique identifier for your class

  // Method to read data from binary format
  @override
  PlayerData read(BinaryReader reader) {
    return PlayerData(
      playerName: reader.readString(), // Read player name
      scores: reader.readMap().cast<String, int>(), // Read scores map
    );
  }

  // Method to write data to binary format
  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer.writeString(obj.playerName); // Write player name
    writer.writeMap(obj.scores); // Write scores map
  }
}
