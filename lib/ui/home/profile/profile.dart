import 'dart:convert';

import 'package:attendance/ui/home/settings/settings.dart';
import 'package:attendance/ui/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../../../api.dart';
import '../../../global.dart';
import 'editProfile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      checkLoading();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: "Settings",
              icon: const Icon(Icons.settings),
              onPressed: () {
                Get.to(const Settings());
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                profile
                    ? Container(
                        decoration: ShapeDecoration(
                          color: const Color(0x123556FC),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 0.50),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    tooltip: "Edit Profile",
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Get.to(EditProfile(
                                        name: name.toString(),
                                        address: address.toString(),
                                        phone: phone.toString(),
                                        designation: designation.toString(),
                                        batch: batch.toString(),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/icon.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.person),
                                    ),
                                    const Text(
                                      "Name: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$name",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.home),
                                    ),
                                    const Text(
                                      "Address: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$address",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.phone),
                                    ),
                                    const Text(
                                      "Phone: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$phone",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.work),
                                    ),
                                    const Text(
                                      "Designation: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$designation",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.computer),
                                    ),
                                    const Text(
                                      "Batch: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "$batch",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.black26,
                        highlightColor: Colors.white,
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0x123556FC),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.50),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 80,
                ),
                OutlinedButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        surfaceTintColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        title: const Text("Are you sure?"),
                        content: const Text("Do you want to logout?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel',
                                style: TextStyle(color: Color(0xff7f91dd))),
                          ),
                          TextButton(
                            onPressed: () {
                              logout();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0x27d0d8ff)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff367efa),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profile = prefs.getBool('profile')!;
      name = prefs.getString('name');
      address = prefs.getString('address');
      phone = prefs.getString('phone');
      batch = prefs.getString('batch');
      designation = prefs.getString('designation');
    });
    if (name != null) {
      setState(() {
        profile = true;
      });
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void logout() {
    clearSharedPreferences();
    Get.offAll(const Login());
  }
}
