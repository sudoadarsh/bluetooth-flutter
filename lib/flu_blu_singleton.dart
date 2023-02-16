import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

typedef FluBluScanController = StreamController<ScanResult>;

enum FluBlueEnum { denied, accepted, noLocation }

abstract class FluBlueAbs {
  late final FlutterBluePlus fb;

  void init();

  Future<bool> isOn();

  void scan({required FluBluScanController controller});

  Future<FluBlueEnum> requestPermissions();
}

class FluBluSingleton extends FluBlueAbs {
  /// Singleton pattern.
  FluBluSingleton._();

  static final FluBlueAbs instance = FluBluSingleton._();

  @override
  void init() {
    fb = FlutterBluePlus.instance;
  }

  @override
  void scan({required FluBluScanController controller}) {
    fb.scanResults.listen((results) {
      for (ScanResult res in results) {
        controller.add(res);
      }
    });
  }

  @override
  Future<FluBlueEnum> requestPermissions() async {
    PermissionStatus location = await Permission.location.request();
    if (location.isDenied) return FluBlueEnum.noLocation;

    // 2. Check if bluetooth is on or not.
    // if (await fb.isOn) return FluBlueEnum.on;

    // 3. Request platform dependent permissions.
    PermissionStatus blC;
    PermissionStatus blS;
    if (Platform.isAndroid) {
      blC = await Permission.bluetoothConnect.request();
      blS = await Permission.bluetoothScan.request();

      // Open the intent and request for permission.
      await const AndroidIntent(
        action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
      ).launch().catchError((e) {
        debugPrint("Error enabling bluetooth via android intent.");
      });
      if (blS.isGranted && blC.isGranted) return FluBlueEnum.accepted;

    } else {
      PermissionStatus bl = await Permission.bluetooth.request();
      // Workaround to ask for new connection in iOS.
      await fb.isAvailable;
      if (bl.isGranted) return FluBlueEnum.accepted;
    }

    return FluBlueEnum.denied;
  }

  @override
  Future<bool> isOn() async {
    return await fb.isOn;
  }
}
