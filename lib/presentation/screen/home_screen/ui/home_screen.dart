import 'package:attendence_management/auth/auth_screen.dart';
import 'package:attendence_management/presentation/screen/add_task/add_task_screen.dart';
import 'package:attendence_management/presentation/screen/home_screen/bloc/home_bloc.dart';
import 'package:attendence_management/presentation/screen/user_profile_screen/user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? uid;

  @override
  void initState() {
    getUID();
    // TODO: implement initState
    super.initState();
  }

  getUID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserProfileScreen()));
        }
        if (state is HomeNavigateToAddTaskScreen) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()));
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
                  icon: CircleAvatar(
                    child: Image.asset(
                      userIcon,
                    ),
                  ))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children:  const [
                DrawerHeader(
                    // decoration: BoxDecoration(color: Colors.orange),
                    child: Column(
                      children: [
                        DrawerHearderLogo(),
                      ],
                    ),),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(onPressed: () { homeBloc.add(HomeFloatingAddClickedEvent()); },child: Icon(Icons.add),

          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("tasks")
                .doc(uid)
                .collection("myTask")
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final doc = snapshots.data!.docs;
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      // childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    itemCount: doc.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                doc[index]['title'],
                                textScaleFactor: 1.5,
                              ),
                              Flexible(
                                child: Text(
                                  doc[index]['description'],
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),

        );
      },
    );
  }
}

class DrawerHearderLogo extends StatelessWidget {
  const DrawerHearderLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const EndDrawerButton(),
        SizedBox(width: 10,),
        Image.asset(
          appLogo,
          height: 40,
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Text(
            appName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
