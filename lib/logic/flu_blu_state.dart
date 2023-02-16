part of 'flu_blu_bloc.dart';

@immutable
abstract class FluBluState {}

class FluBluShowDialog extends FluBluState {}

class FluBluPermissionLoading extends FluBluState {}

class FluBluNoLocation extends FluBluState {}

class FluBluInitial extends FluBluState {}

class FluBluDenied extends FluBluState {}

class FluBluAccepted extends FluBluState {}

class FluBluStatus extends FluBluState {
  final bool status;
  FluBluStatus({required this.status});
}