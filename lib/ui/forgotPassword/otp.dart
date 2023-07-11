import 'dart:async';

import 'package:attendance/ui/forgotPassword/reset.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../api.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.email});

  final email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  bool loading = false;
  Timer? _timer;
  int _cooldown = 60;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
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
              "OTP",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: 200, child: Lottie.asset('assets/lottie/otp-v2.json')),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "Enter the OTP send to ${widget.email}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: otpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your OTP';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        hintText: 'Enter your OTP',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.message,
                            // color: Colors.white,
                            size: 30,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isButtonDisabled ? null : () => sendOtp(),
                  child: Text(
                    _isButtonDisabled ? 'Resend in ($_cooldown)' : 'Resend OTP',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (loading) {
                    null;
                  } else {
                    if (_formKey.currentState!.validate()) {
                      verifyOtp();
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF367EFA)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Done",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }

  void sendOtp() async {
    try {
      startCooldown();
      setState(() {
        loading = true;
      });

      final response = await http.get(
        Uri.parse('${api}api/mail/send?email=${otpController.text}'),
        headers: {"content-type": "application/json"},
      );
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "OTP send",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 404) {
        forceResetCooldown();
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Email not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        forceResetCooldown();
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
      forceResetCooldown();
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

  void startCooldown() {
    //sendOtp();
    _isButtonDisabled = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_cooldown > 0) {
          _cooldown--;
        } else {
          _timer?.cancel();
          _isButtonDisabled = false;
        }
      });
    });
  }

  void forceResetCooldown() {
    _timer?.cancel();
    setState(() {
      _cooldown = 60;
      _isButtonDisabled = false;
    });
  }

  void verifyOtp() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${api}api/mail/forget-password?email=${widget.email}&otp=${otpController.text}'),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Get.off(
          () => ResetPassword(email: widget.email),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 1000),
        );
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "${response.statusCode}: Failed",
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
}
