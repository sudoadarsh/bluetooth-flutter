part of 'ttsbloc_bloc.dart';

@immutable
abstract class TTSEvent {}

class FetchVoicesEvent extends TTSEvent {}

class TestVoiceEvent extends TTSEvent {
  final VoiceModel voice;
  final int groupIndex;
  
  TestVoiceEvent({required this.voice, required this.groupIndex});
}