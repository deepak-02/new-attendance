import 'dart:convert';
import 'package:attendance/ui/home/home.dart';
import 'package:attendance/ui/home/profile/profile.dart';
import 'package:attendance/ui/home/attendance/attendance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

PersistentTabController _controller = PersistentTabController(initialIndex: 0);
List<Widget> _buildScreens() {
  return [
    const MyHomePage(),
    const TodaysAttendance(),
    const Profile(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      iconSize: 24,
      textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
      title: ("Home"),
      // activeColorPrimary: const Color(0xff92278f),
      // inactiveColorPrimary: const Color(0xffd3a9d2),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.history),
      iconSize: 24,
      textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
      title: ("Attendance"),
      // activeColorPrimary: const Color(0xff92278f),
      // inactiveColorPrimary: const Color(0xffd3a9d2),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      iconSize: 24,
      textStyle: const TextStyle(fontSize: 12, fontFamily: "Metropolis"),
      title: ("Profile"),
      // activeColorPrimary: const Color(0xff92278f),
      // inactiveColorPrimary: const Color(0xffd3a9d2),
    ),
  ];
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: const Color(0xffffffff),
      // backgroundColor: Color(0xffc993c7), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(20.0),
      //   colorBehindNavBar: Colors.white,
      // ),
      padding: const NavBarPadding.all(5),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      navBarHeight: 56,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      // print("load profile");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('profile', false);
      var email = prefs.getString('email');
      final response = await http.get(
        Uri.parse('${api}api/rest/get-profile?email=$email'),
      );
      //print('Profile response:  ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        setState(() {
          prefs.setString('name', data['name']);
          prefs.setString('designation', data['designation']);
          prefs.setString('address', data['address']);
          prefs.setString('phone', data['phone']);
          prefs.setString('batch', data['batch']);
          prefs.setBool('profile', true);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
