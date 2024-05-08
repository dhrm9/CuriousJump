import 'package:hive/hive.dart';

class PlayerData {
  String playerName;
  Map<String, int> scores;

  PlayerData({required this.playerName, required this.scores});
}

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0; // Unique identifier for your class

  @override
  PlayerData read(BinaryReader reader) {
    return PlayerData(
      playerName: reader.readString(),
      scores: reader.readMap().cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer.writeString(obj.playerName);
    writer.writeMap(obj.scores);
  }
}