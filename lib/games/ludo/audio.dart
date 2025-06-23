

import 'package:audioplayers/audioplayers.dart';

class Audio {
  static AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> playMove() async {
    audioPlayer.play(AssetSource('sound/move.wav'));
  }

  static Future<void> playKill() async {
    audioPlayer.play(AssetSource('sound/laugh.mp3'));
  }

  static Future<void> rollDice() async {
    audioPlayer.play(AssetSource('sound/roll_the_dice.mp3'));
  }
}
