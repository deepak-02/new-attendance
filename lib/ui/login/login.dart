import 'dart:convert';
import 'package:attendance/ui/bigButton.dart';
import 'package:attendance/ui/login/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import '../../global.dart';
import '../dashboard.dart';
import '../forgotPassword/forgotPassword.dart';
import '../home/settings/change_api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const Spacer(),
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              //const Spacer(),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ic_launcher.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(60.0),
                ),
              ),
              // const Spacer(),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.alternate_email,
                              // color: Colors.white,
                              size: 30,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.key,
                              // color: Colors.white,
                              size: 30,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                //color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Get.to(
                          () => const Forgot(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // TextButton(
              //   child: const Text(
              //     'Change Api',
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   onPressed: () {
              //     Get.to(
              //           () => const ChangeApi(),
              //       transition: Transition.rightToLeft,
              //       duration: const Duration(milliseconds: 800),
              //     );
              //   },
              // ),
              const SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? AnimatedContainer(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF367EFA),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : BigButton(
                        title: "Login",
                        onPressed: () {
                          if (loading) {
                            null;
                          } else {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          }
                        },
                      ),
              ),

              //const Spacer(),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ))),
                child: TextButton(
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Get.to(
                      () => const Signup(),
                      // SignUp_Page(),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 800),
                    );
                  },
                ),
              ),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.post(
        Uri.parse('${api}api/auth/signin'),
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text
        }),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 202) {
        checkLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString('email', usernameController.text);
          loading = false;
        });
        Get.offAll(
          () => const Dashboard(),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 800),
        );
      } else if (response.statusCode == 208) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Permission denied",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 401) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Username or Password is wrong!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "${response.statusCode}: Something wrong!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0x23000000),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      // print(e);
    }
  }

  void checkLoading() async {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
