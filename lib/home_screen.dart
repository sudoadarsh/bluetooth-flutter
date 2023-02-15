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

  @override
  void initState() {
    super.initState();

    _fluBluBloc = FluBluBloc();

    _fluBluBloc.add(RequestPermissionEvent());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(title: const Text("FluBlu"))
          ],
        ),
      ),
    );
  }

  // ----------------------------- Class methods -------------------------------
  Future<void> _showDialog() async {
    String info = "Some unexpected error occurred";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocConsumer(
          bloc: _fluBluBloc,
          listener: (context, state) {
            if (state is FluBluOn || state is FluBluAccepted) {
              Navigator.of(context).pop();
            } else if (state is FluBluDenied) {
              _showPermissionDeniedDialog();
            }
          },
          builder: (context, state) {
            if (state is FluBluePermissionLoading) {
              info = "Loading...Please wait";
            } else if (state is FluBluUnavailable) {
              info = "Oops...Bluetooth in not available in your device 😔";
            }
            return AlertDialog(
              title: const Text("Bluetooth Setup"),
              content: Text(info),
            );
          },
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
            CupertinoDialogAction(
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop();
                _fluBluBloc.add(RequestPermissionEvent());
                _showDialog();
              },
            ),
          ],
        );
      },
    );
  }
}
