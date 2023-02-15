import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

typedef FluBluScanController = StreamController<ScanResult>;

enum FluBluStatus { unavailable, on, denied, accepted }

abstract class FluBlueAbs {
  late final FlutterBluePlus fb;

  void init();

  void scan({required FluBluScanController controller});

  Future<FluBluStatus> requestPermissions();
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
  Future<FluBluStatus> requestPermissions() async {
    // 1. Check if the device supports BLE.
    if (!await fb.isAvailable) return FluBluStatus.unavailable;

    // 2. Check if bluetooth is turned on.
    if (await fb.isOn) return FluBluStatus.on;

    // Ask for location and bluetooth permissions.
    PermissionStatus location = await Permission.location.request();
    PermissionStatus bluetooth;
    PermissionStatus bluetoothC;
    PermissionStatus bluetoothS;

    if (Platform.isAndroid) {
      bluetoothC = await Permission.bluetoothConnect.request();
      bluetoothS = await Permission.bluetoothScan.request();

      if (location.isGranted &&
          bluetoothC.isGranted &&
          bluetoothS.isGranted) return FluBluStatus.accepted;
    } else {
      bluetooth = await Permission.bluetooth.request();
      if (location.isGranted && bluetooth.isGranted) {
        return FluBluStatus.accepted;
      }
    }

    return FluBluStatus.denied;
  }
}
