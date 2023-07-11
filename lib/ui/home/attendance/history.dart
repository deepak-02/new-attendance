import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import '../../../db/todaysList.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Attendance> myAttendance = [];
  bool historyLoad = true;

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Attendance'),
        leading: IconButton(
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: _check(),
    );
  }

  _check() {
    if (!historyLoad && myAttendance.isNotEmpty) {
      return Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '    Date',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'IN',
                style: TextStyle(color: Colors.greenAccent, fontSize: 18),
              ),
              Text(
                'OUT            ',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  historyLoad = true;
                });
                myAttendance.clear();
                await getHistory();
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: myAttendance.length,
                  // reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    // var items = myAttendance[index];
                    var items = myAttendance[myAttendance.length - index - 1];
                    var datee = items.date;
                    var dates = DateFormat(' MMM dd').format(datee);
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListTile(
                        leading: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Text(
                            dates,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 15,
                                //color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade),
                          ),
                        ),
                        title: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                items.firstIn,
                                style: const TextStyle(
                                  fontSize: 14,
                                  //color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                items.secondIn,
                                style: const TextStyle(
                                  fontSize: 14,),
                              ),
                            ],
                          ),
                        ),
                        trailing: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                items.firstOut,
                                style: const TextStyle(
                                  fontSize: 14,
                                  //color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                items.secondOut,
                                style: const TextStyle(
                                  fontSize: 14,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      );
    } else if (!historyLoad && myAttendance.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            historyLoad = true;
          });
          myAttendance.clear();
          await getHistory();
        },
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  getHistory() async {
    try {
      myAttendance.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');

      final response = await http.get(
        Uri.parse('${api}api/rest/get-user-details?email=$email'),
      );

      // print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          historyLoad = false;
        });
        var listAttendance = json.decode(response.body);
        listAttendance.forEach((element) {
          setState(() {
            myAttendance.add(Attendance.fromJson(element));
          });
        });
      } else {
        setState(() {
          historyLoad = false;
        });
        Fluttertoast.showToast(
            msg: "${response.statusCode}: Error loading!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0x23000000),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      setState(() {
        historyLoad = false;
      });
      // print(e);
    }
  }
}
