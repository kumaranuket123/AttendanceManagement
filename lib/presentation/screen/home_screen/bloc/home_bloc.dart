import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLogOutClickedEvent>(homeLogOutClickedEvent);
    on<HomeUserProfileClickedEvent>(homeUserProfileClickedEvent);
    on<HomeFloatingAddClickedEvent>(homeFloatingAddClickedEvent);
  }

  FutureOr<void> homeLogOutClickedEvent(
      HomeLogOutClickedEvent event, Emitter<HomeState> emit) {
    debugPrint("logged Out");
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    emit(HomeNavigateToLoginPage());
  }

  FutureOr<void> homeUserProfileClickedEvent(
      HomeUserProfileClickedEvent event, Emitter<HomeState> emit) {
    debugPrint("User profile clicked");
    emit(HomeNavigateToUserProfile());
  }

  FutureOr<void> homeFloatingAddClickedEvent(
      HomeFloatingAddClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToAddTaskScreen());
  }
}
