import 'package:demirbasim/theme/all_theme.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('Ercan Yiğit'),
              accountEmail: const Text('ercanyt@gmail.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/siyah1.png'),
              ),
              decoration: BoxDecoration(
                color: DemirBasimTheme.of(context).alternate,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle drawer item tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
