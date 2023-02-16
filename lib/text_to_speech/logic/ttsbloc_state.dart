part of 'ttsbloc_bloc.dart';

@immutable
abstract class TTSState {}

class TTSInitialState extends TTSState {}

class TTSVoicesLoadingState extends TTSState {}

class TTSVoicesListState extends TTSState {
  final List voices;

  TTSVoicesListState({required this.voices});
}

class TTSTextVoicePlaying extends TTSState {
  final int groupIndex;
  final bool isPlaying;

  TTSTextVoicePlaying({required this.groupIndex, required this.isPlaying});
}