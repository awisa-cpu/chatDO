import 'package:chatdo/common/styles/custom_layout_view.dart';
import 'package:chatdo/services/auth_services.dart';
import 'package:chatdo/services/database_services.dart';
import 'package:chatdo/services/navigation_services.dart';
import 'package:chatdo/views/chats/chats_view.dart';
import 'package:chatdo/views/personalization/user_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'all_users_home_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //
  final GetIt _getIt = GetIt.instance;
  late final AuthServices authService;
  late final NavigationServices navService;
  late final DatabaseServices dbService;
  int selectedView = 0;

  @override
  void initState() {
    super.initState();
    dbService = _getIt.get<DatabaseServices>();
    authService = _getIt.get<AuthServices>();
    navService = _getIt.get<NavigationServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeUi(selectedView),
      bottomNavigationBar: _buildBottomNavBar(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
        enableFeedback: false,
        elevation: 0,
        currentIndex: selectedView,
        onTap: (value) {
          setState(() {
            selectedView = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ]);
  }

  Widget _buildHomeUi(int selectedView) {
    switch (selectedView) {
      case 0:
        return CustomLayoutView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _builAppBar(),
              const SizedBox(height: 15),
              AllUsersHomeView(
                dbService: dbService,
                currentUserId: authService.currentUser!.uid,
                authService: authService,
                navService: navService,
              )
            ],
          ),
        );

      case 1:
        return ChatsView(
          authService: authService,
          dbService: dbService,
          navService: navService,
        );

      case 2:
        return UserSettingsView(
          dbService: dbService,
          navService: navService,
          authService: authService,
        );
      default:
        return Container();
    }
  }

  Widget _builAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //first child
        Text(
          'CHATDO',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .apply(fontWeightDelta: 2),
        ),

        //second child
        Row(
          children: [
            //search bar
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),

            //
          ],
        ),
      ],
    );
  }
}
