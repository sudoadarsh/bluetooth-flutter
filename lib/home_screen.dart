import 'package:flublu/text_to_speech/logic/ttsbloc_bloc.dart';
import 'package:flublu/text_to_speech/tts_singleton.dart';
import 'package:flublu/text_to_speech/voice_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/flu_blu_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  /// FluBlu bloc.
  late final FluBluBloc _fluBluBloc;

  /// The text-to-speech bloc.
  late final TTSBloc _ttsBloc;

  @override
  void initState() {
    super.initState();

    _fluBluBloc = FluBluBloc();
    _ttsBloc = TTSBloc();

    _fluBluBloc.add(RequestPermissionEvent());
  }

  @override
  void dispose() {
    super.dispose();

    _fluBluBloc.close();
    _ttsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Title of the page.
            SliverAppBar.large(
              title: const Text("FluBlu"),
              actions: [
                IconButton(
                  onPressed: () {
                    // Get the available devices list.
                    _ttsBloc.add(FetchVoicesEvent());
                    // Change the voice.
                    _showVoicesList();
                  },
                  icon: const Icon(Icons.change_circle),
                )
              ],
            ),

            // Placeholder widget to listen to cubit/bloc states.
            BlocListener(
              bloc: _fluBluBloc,
              listener: (context, state) {
                if (state is FluBluShowDialog) {
                  _showDialog();
                } else if (state is FluBluStatus) {}
              },
              child: const SliverPadding(padding: EdgeInsets.zero),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------- Class methods -------------------------------
  Future<void> _showDialog() async {
    String info = "Some unexpected error occurred.";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("FluBlu"),
          content: BlocConsumer(
            bloc: _fluBluBloc,
            listener: (context, state) {
              if (state is FluBluNoLocation || state is FluBluDenied) {
                Navigator.of(context).pop();
                _showPermissionDeniedDialog();
              } else if (state is FluBluAccepted) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is FluBluPermissionLoading) {
                info = "Setting up bluetooth...Please wait";
              }
              return Text(info);
            },
          ),
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text("Error in Bluetooth Setup"),
          content: const Text("Insufficient permissions for bluetooth setup"),
          actions: [
            const CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Cancel"),
            ),
            CupertinoDialogAction(
              child: const Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop();
                _fluBluBloc.add(RequestPermissionEvent());
              },
            ),
          ],
        );
      },
    );
  }

  void _showVoicesList() {
    List voices = [];
    int grpIndex = -1;
    bool isPlaying = false;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocBuilder(
          bloc: _ttsBloc,
          builder: (context, state) {
            if (state is TTSVoicesLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TTSVoicesListState) {
              voices = state.voices;
            } else if (state is TTSTextVoicePlaying) {
              isPlaying = state.isPlaying;
              grpIndex = state.groupIndex;
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: voices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    onPressed: () {

                      if (isPlaying) {
                        TTSSingleton.instance.stop();
                        return;
                      }

                      VoiceModel voice = VoiceModel.fromJson(voices[index]);

                      _ttsBloc.add(
                        TestVoiceEvent(
                          voice: voice,
                          groupIndex: index,
                        ),
                      );
                    },
                    icon: isPlaying && (grpIndex == index)
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                  ),
                  title: Text("Voice $index"),
                  subtitle: const Text("Tap to save this as the default voice"),
                  onTap: () {},
                );
              },
            );
          },
        );
      },
    );
  }
}
