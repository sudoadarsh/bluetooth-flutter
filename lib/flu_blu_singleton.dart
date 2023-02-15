import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

typedef FluBluScanController = StreamController<ScanResult>;

enum FluBluStatus { unavailable, on, denied, accepted }

abstract class FluBlueSingleton {
  late final FlutterBluePlus fb;

  void init();

  void scan({required FluBluScanController controller});

  Future<FluBluStatus> requestPermissions();
}

class FluBluSingleton extends FluBlueSingleton {
  /// Singleton pattern.
  FluBluSingleton._();

  static final FluBlueSingleton instance = FluBluSingleton._();

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
  Future<FluBluStatus> requestPermissions() async {
    // 1. Check if the device supports BLE.
    if (!await fb.isAvailable) return FluBluStatus.unavailable;

    // 2. Check if bluetooth is turned on.
    if (await fb.isOn) return FluBluStatus.on;

    // Ask for location and bluetooth permissions.
    PermissionStatus location = await Permission.location.request();
    PermissionStatus bluetooth = await Permission.bluetooth.request();
    PermissionStatus bluetoothC;
    PermissionStatus bluetoothS;

    if (Platform.isAndroid) {
      bluetoothC = await Permission.bluetoothConnect.request();
      bluetoothS = await Permission.bluetoothScan.request();

      if (location.isGranted &&
          bluetooth.isGranted &&
          bluetoothC.isGranted &&
          bluetoothS.isGranted) return FluBluStatus.accepted;
    } else {
      if (location.isGranted && bluetooth.isGranted) return FluBluStatus.accepted;
    }

    return FluBluStatus.denied;
  }
}
