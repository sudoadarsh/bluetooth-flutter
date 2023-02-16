import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

abstract class TTSAbs {
  final FlutterTts _tts = FlutterTts();

  /// Call this before using any of [TTSSingleton] methods.
  /// This initialises [TTSSingleton] with platform specific configuration.
  Future<void> init({double? speechRate, double? pitch, double? volume});

  /// Start speaking a given text.
  Future<void> speak(String text);

  /// Stop speaking.
  Future<void> stop();

  /// To get the the list of voices.
  Future<List> getVoice();

  /// Set new voice.
  Future<void> setVoice(Map<String, String> voice);

}

class TTSSingleton extends TTSAbs {

  /// Singleton pattern.
  TTSSingleton._();

  static final TTSSingleton instance = TTSSingleton._();

  @override
  Future<void> init({double? speechRate, double? pitch, double? volume}) async {

    // Set speech rate, volume and pitch.
    _tts.setSpeechRate(speechRate ?? 0.6);
    _tts.setVolume(volume ?? 1.0);
    _tts.setPitch(pitch ?? 0.6);

    if (Platform.isIOS) {
      // Set shared audio instance.
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers
          ],
          IosTextToSpeechAudioMode.voicePrompt
      );
    }

    // Async text to speech conversion is required.
    await _tts.awaitSpeakCompletion(true);
  }

  @override
  Future<void> speak(String text) async {
    // Stop any speaking session first.
    await _tts.stop();

    return await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    return await _tts.stop();
  }

  @override
  Future<List> getVoice() async {
    return await _tts.getVoices;
  }

  @override
  Future<void> setVoice(Map<String, String> voice) async {
    return await _tts.setVoice(voice);
  }
}