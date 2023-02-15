part of 'flu_blu_bloc.dart';

@immutable
abstract class FluBluState {}

class FluBluePermissionLoading extends FluBluState {}

class FluBluInitial extends FluBluState {}

class FluBluUnavailable extends FluBluState {}

class FluBluOn extends FluBluState {}

class FluBluDenied extends FluBluState {}

class FluBluAccepted extends FluBluState {}
