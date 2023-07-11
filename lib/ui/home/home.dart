import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slidable_button/slidable_button.dart';
import '../../api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _scanBarcodein = '';
  String _scanBarcodeout = '';

  Future<void> scanQRIn() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
// scanner
    setState(() {
      _scanBarcodein = barcodeScanRes;
      slideIn();
    });
  }

  Future<void> scanQROut() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
// scanner
    setState(() {
      _scanBarcodeout = barcodeScanRes;
      slideOut();
    });
  }

  @override
  void initState() {
    // getProfile();
    // getProdb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text('title'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: const TextSpan(
                  text: 'Scan your QR code to mark attendance for',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueAccent),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Prathibhatheeram Foundation',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Slide the button below to scan your QR code.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(
                  width: 150,
                  child: Lottie.asset('assets/lottie/arrow-down.json')),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0x123675FC),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      const Text("Slide to mark in"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HorizontalSlidableButton(
                          width: MediaQuery.of(context).size.width / 1,
                          height: 70,
                          buttonWidth: 70,
                          borderRadius: BorderRadius.circular(100),
                          isRestart: true,
                          initialPosition: SlidableButtonPosition.start,
                          color: const Color(0x4cc7c7c7),
                          buttonColor: const Color(0xff1662ef),
                          dismissible: false,
                          autoSlide: true,
                          label: const Center(
                              child: Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: Colors.white,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.black26,
                                      highlightColor: Colors.white,
                                      child: const Text(
                                        "Slide to mark attendance",
                                        style: TextStyle(
                                            color: Color(0xc5a9a9a9),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'IN',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          onChanged: (position) {
                            setState(() {
                              if (position == SlidableButtonPosition.end) {
                                scanQRIn();
                              } else {}
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      const Text("Slide to mark out"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HorizontalSlidableButton(
                          width: MediaQuery.of(context).size.width / 1,
                          height: 70,
                          buttonWidth: 70,
                          initialPosition: SlidableButtonPosition.end,
                          borderRadius: BorderRadius.circular(100),
                          isRestart: true,
                          color: const Color(0x4cc7c7c7),
                          buttonColor: const Color(0xff1662ef),
                          dismissible: false,
                          autoSlide: true,
                          label: const Center(
                              child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'OUT',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 70),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Shimmer.fromColors(
                                      direction: ShimmerDirection.rtl,
                                      baseColor: Colors.black26,
                                      highlightColor: Colors.white,
                                      child: const Text(
                                        "Slide to mark attendance",
                                        style: TextStyle(
                                            color: Color(0xc5a9a9a9),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onChanged: (position) {
                            setState(() {
                              if (position == SlidableButtonPosition.start) {
                                scanQROut();
                              } else {}
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> slideIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('${api}api/rest/save'),
        body: jsonEncode({
          "email": prefs.getString('email'),
          "last": 'in',
          "para": _scanBarcodein,
        }),
        headers: {"content-type": "application/json"},
      );
      // print(response.statusCode);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Marked IN",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 208) {
        Fluttertoast.showToast(
            msg: "This code is used, please reload",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Marked as late",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 423) {
        Fluttertoast.showToast(
            msg: "You have reached maximum scanning limit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 503) {
        Fluttertoast.showToast(
            msg: "You are already IN",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "${response.statusCode} : Something Wrong!",
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
    }
  }

  Future<void> slideOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('${api}api/rest/save'),
        body: jsonEncode({
          "email": prefs.getString('email'),
          "last": 'out',
          "para": _scanBarcodeout,
        }),
        headers: {"content-type": "application/json"},
      );
      // print(response.statusCode);

      if (response.statusCode == 410) {
        Fluttertoast.showToast(
            msg: "Marked OUT",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 208) {
        Fluttertoast.showToast(
            msg: "This code is used, please reload",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Marked as late",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 423) {
        Fluttertoast.showToast(
            msg: "You have reached maximum scanning limit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 503) {
        Fluttertoast.showToast(
            msg: "You are already IN",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "${response.statusCode} : Something Wrong!",
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
    }
  }
}
