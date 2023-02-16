part of 'flu_blu_bloc.dart';

@immutable
abstract class FluBluEvent {}

class RequestPermissionEvent extends FluBluEvent {}

class TurnOnBluetoothFromSettings extends FluBluEvent {}

class CheckBluetoothStatus extends FluBluEvent {}
