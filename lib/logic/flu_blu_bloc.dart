// ignore_for_file: depend_on_referenced_packages
import 'package:app_settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flublu/flu_blu_singleton.dart';
import 'package:meta/meta.dart';

part 'flu_blu_event.dart';

part 'flu_blu_state.dart';

class FluBluBloc extends Bloc<FluBluEvent, FluBluState> {
  FluBluBloc() : super(FluBluInitial()) {

    on<RequestPermissionEvent>((event, emit) async {

      emit(FluBluShowDialog());

      emit(FluBluPermissionLoading());

      FluBlueEnum status =
          await FluBluSingleton.instance.requestPermissions();

      switch (status) {
        case FluBlueEnum.denied:
          emit(FluBluDenied());
          break;
        case FluBlueEnum.accepted:
          emit(FluBluAccepted());
          break;
        case FluBlueEnum.noLocation:
          emit(FluBluNoLocation());
          break;
      }
    });

    on<TurnOnBluetoothFromSettings>((event, emit) async {
      await AppSettings.openBluetoothSettings();
    });

    on<CheckBluetoothStatus>((event, emit) async {
      bool positive = await FluBluSingleton.instance.isOn();
      emit(FluBluStatus(status: positive));
    });

  }
}
