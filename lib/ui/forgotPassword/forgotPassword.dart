import 'package:attendance/ui/forgotPassword/otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../api.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    usernameController.dispose();
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
            Container(
                //width: 150,
                child: Lottie.asset('assets/lottie/forgot-password.json')),
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
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
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
                      sendOtp();
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
                        "Send OTP",
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
      setState(() {
        loading = true;
      });

      final response = await http.get(
        Uri.parse('${api}api/mail/send?email=${usernameController.text}'),
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

        Get.off(
          () => OtpPage(
            email: usernameController.text,
          ),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 1000),
        );
      } else if (response.statusCode == 404) {
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
}
