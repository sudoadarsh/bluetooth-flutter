import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Meditab Software Inc. CONFIDENTIAL
///__________________
///
/// [2023] Meditab Software Inc.
/// All Rights Reserved.
///
/// NOTICE:  All information contained herein is, and remains
/// the property of Meditab Software Inc. and its suppliers,
/// if any.  The intellectual and technical concepts contained
/// herein are proprietary to Meditab Software Incorporated
/// and its suppliers and may be covered by U.S. and Foreign Patents,
/// patents in process, and are protected by trade secret or copyright law.
/// Dissemination of this information or reproduction of this material
/// is strictly forbidden unless prior written permission is obtained
/// from Meditab Software Incorporated.
///
/// File Name: flu_blu_singleton
///
/// @author Adarsh Sudarsanan (adarshs@meditab.com) Meditab Software Inc.
/// @version 1.0.0
/// @since 15/02/23
///

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
