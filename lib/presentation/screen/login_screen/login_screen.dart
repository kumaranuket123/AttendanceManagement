import 'package:attendence_management/constant/constants.dart';
import 'package:attendence_management/presentation/screen/home_screen/ui/home_screen.dart';
import 'package:attendence_management/presentation/screen/login_screen/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginNavigateToHomeScreen) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      loginBloc.add(LoginButtonClickedEvent());
                    },
                    child: Text(login)),
              ],
            ),
          ),
        );
      },
    );
  }
}
