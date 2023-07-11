import 'dart:convert';

import 'package:attendance/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../api.dart';
import '../../bigButton.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      this.name,
      this.address,
      this.phone,
      this.designation,
      this.batch});

  final name;
  final address;
  final phone;
  final designation;
  final batch;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController designationController;
  dynamic batch;

  bool loading = false;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    addressController = TextEditingController(text: widget.address);
    phoneController = TextEditingController(text: widget.phone);
    designationController = TextEditingController(text: widget.designation);
    setState(() {
      batch = widget.batch;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Profile'),
        leading: IconButton(
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
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
                  height: 50,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: const Color(0x123556FC),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.50),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter your name',
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.person,
                                      // color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: addressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  hintText: 'Enter your address',
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.home,
                                      // color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: phoneController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  hintText: 'Enter your phone',
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.phone,
                                      // color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: designationController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your designation';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Designation/Course',
                                  hintText: 'Enter your designation',
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.work,
                                      // color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Batch',
                                  hintText: 'Select batch',
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.batch_prediction,
                                      size: 30,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                value: batch,
                                onChanged: (value) {
                                  setState(() {
                                    batch = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Batch 1',
                                    child: Text('Batch 1'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Batch 2',
                                    child: Text('Batch 2'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a batch';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 80,
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
                    title: "Save",
                    onPressed: () {
                      if (loading) {
                        null;
                      } else {
                        if (_formKey.currentState!.validate()) {
                          saveProfile();
                        }
                      }
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  saveProfile() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      final response = await http.put(
        Uri.parse('${api}api/rest/update-profile'),
        body: jsonEncode({
          "email": email,
          "name": nameController.text,
          "phone": phoneController.text,
          "address": addressController.text,
          "designation": designationController.text,
          "batch": batch,
        }),
        headers: {"content-type": "application/json"},
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        prefs.setString('name', nameController.text);
        prefs.setString('phone', phoneController.text);
        prefs.setString('address', addressController.text);
        prefs.setString('designation', designationController.text);

        setState(() {
          loading = false;
        });
        Get.offAll(const Dashboard());

        Fluttertoast.showToast(
            msg: "Profile updated",
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
