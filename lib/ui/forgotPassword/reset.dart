import 'dart:async';

import 'package:attendance/ui/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../api.dart';
import '../bigButton.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, this.email});

  final email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Reset",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: 200, child: Lottie.asset('assets/lottie/reset.json')),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
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
                      title: "Reset",
                      onPressed: () {
                        if (loading) {
                          null;
                        } else {
                          if (_formKey.currentState!.validate()) {
                            reset();
                          }
                        }
                      },
                    ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }

  void reset() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(
        Uri.parse(
            '${api}api/mail/reset-password?newpassword=${passwordController.text}&email=${widget.email}&username=${widget.email}'),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        deleteOtp();
        Fluttertoast.showToast(
            msg: "Password reset",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
        Get.offAll(const Login());
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
      // print(e);
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0x23000000),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> deleteOtp() async {
    final response = await http.post(
      Uri.parse('${api}api/mail/delete-otp?email=${widget.email}'),
      headers: {"content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("otp deleted");
      }
    } else {
      if (kDebugMode) {
        print("not deleted");
      }
    }
  }
}
