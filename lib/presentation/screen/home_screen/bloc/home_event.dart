part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeLogOutClickedEvent extends HomeEvent {}

class HomeUserProfileClickedEvent extends HomeEvent {}
