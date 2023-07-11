import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      tileColor: Colors.transparent,
                      onTap: () => {
                        Get.to(
                          () => const About(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        ),
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xcb1662ef),
                        child: Icon(
                          Icons.info_outlined,
                          color: Color(0xffffffff),
                        ),
                      ),
                      title: const Text(
                        "About",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  // Card(
                  //   color: Colors.white,
                  //   child: ListTile(
                  //     tileColor: Colors.transparent,
                  //     onTap: () => {
                  //       // Get.to(
                  //       //       () => delet(),
                  //       //   transition: Transition.rightToLeft,
                  //       //   duration: Duration(milliseconds: 500),
                  //       // ),
                  //     },
                  //     leading: CircleAvatar(
                  //       backgroundColor: Color(0xcb1662ef),
                  //       child: Icon(
                  //         Icons.person_remove_rounded,
                  //         color: Color(0xffffffff),
                  //       ),
                  //     ),
                  //     title: Text(
                  //       "Delete Account",
                  //       style: TextStyle(
                  //         fontSize: 16
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
