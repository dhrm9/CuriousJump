import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool isSoundOn = true;
  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
  }

  void setSound(bool isSoundOn){
    this.isSoundOn = isSoundOn;
  }

  void startBgm(String fileName) {
    if (isSoundOn) {
      FlameAudio.bgm.play(fileName, volume: 0.2);
    }
  }

  // Pauses currently playing BGM if any.
  void pauseBgm() {
    if (isSoundOn) {
      FlameAudio.bgm.pause();
    }
  }

  // Resumes currently paused BGM if any.
  void resumeBgm() {
    if (isSoundOn) {
      FlameAudio.bgm.resume();
    }
  }

  // Stops currently playing BGM if any.
  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  // Plays the given audio file once.
  void playSfx(String fileName) {
    if (isSoundOn) {
      FlameAudio.play(fileName , );
    }
  }
}