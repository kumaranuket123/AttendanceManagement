part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {}

///Action state
class HomeNavigateToLoginPage extends HomeActionState {}

class HomeNavigateToUserProfile extends HomeActionState {}
