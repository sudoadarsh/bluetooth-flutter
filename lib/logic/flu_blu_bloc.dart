// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flublu/flu_blu_singleton.dart';
import 'package:meta/meta.dart';

part 'flu_blu_event.dart';
part 'flu_blu_state.dart';

class FluBluBloc extends Bloc<FluBluEvent, FluBluState> {
  FluBluBloc() : super(FluBluInitial()) {
    on<FluBluEvent>((event, emit) async {

      /// Request bluetooth permissions.
      if (event is RequestPermissionEvent) {
        emit (FluBluePermissionLoading());

        FluBluStatus status = await FluBluSingleton.instance.requestPermissions();

        switch (status) {
          case FluBluStatus.unavailable:
            emit (FluBluUnavailable());
            break;
          case FluBluStatus.on:
            emit (FluBluOn());
            break;
          case FluBluStatus.denied:
            emit (FluBluDenied());
            break;
          case FluBluStatus.accepted:
            emit (FluBluAccepted());
            break;
        }
      }
    });
  }
}
