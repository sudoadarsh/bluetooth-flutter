// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flublu/text_to_speech/tts_singleton.dart';
import 'package:flublu/text_to_speech/voice_model.dart';
import 'package:meta/meta.dart';

part 'ttsbloc_event.dart';
part 'ttsbloc_state.dart';

class TTSBloc extends Bloc<TTSEvent, TTSState> {
  TTSBloc() : super(TTSInitialState()) {

    TTSSingleton.instance.init();

    /// Fetch voices list event.
    on<FetchVoicesEvent>((event, emit) async {
      emit (TTSVoicesLoadingState());
      List voices = await TTSSingleton.instance.getVoice();
      emit (TTSVoicesListState(voices: voices));
    });
    
    /// Test voice event. 
    on<TestVoiceEvent>((event, emit) async {
      emit (TTSTextVoicePlaying(groupIndex: event.groupIndex, isPlaying: true));
      // Set the voice in TTSSingleton. 
      TTSSingleton.instance.setVoice(event.voice.toJson());
      
      // Speak a certain line. 
      await TTSSingleton.instance.speak("Tap to save this as the default voice.");

      emit (TTSTextVoicePlaying(groupIndex: event.groupIndex, isPlaying: false));
    });
  }
}
