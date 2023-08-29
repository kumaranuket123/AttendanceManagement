import 'package:attendence_management/auth/auth_screen.dart';
import 'package:attendence_management/presentation/screen/home_screen/bloc/home_bloc.dart';
import 'package:attendence_management/presentation/widgets/company_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant/assets.dart';
import '../../../../constant/constants.dart';
import '../../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToLoginPage) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MyApp()));
        }
        if (state is HomeNavigateToUserProfile) {
          // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => const MLScreen()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: Text(dashboard),
            actions: [
              IconButton(
                  onPressed: () {
                    homeBloc.add(HomeLogOutClickedEvent());
                  },
                  icon: const Icon(Icons.login)),
              IconButton(
                  onPressed: () {
                    homeBloc.add(HomeUserProfileClickedEvent());
                  },
                  icon: const CircleAvatar())
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: const [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DrawerHeader(
                          child: CompanyLogoWidget(),
                          decoration: BoxDecoration(color: Colors.orange)),
                      EndDrawerButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: Container(),
        );
      },
    );
  }
}
