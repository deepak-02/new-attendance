import 'dart:convert';
import 'dart:developer';
import 'package:attendance/ui/home/attendance/history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../api.dart';
import '../../../db/todaysList.dart';

class TodaysAttendance extends StatefulWidget {
  const TodaysAttendance({Key? key}) : super(key: key);

  @override
  State<TodaysAttendance> createState() => _TodaysAttendanceState();
}

class _TodaysAttendanceState extends State<TodaysAttendance> {
  List<Attendance> todaysAttendance = [];
  bool attLoad = true;


  @override
  void initState() {
    super.initState();
    getAttendance();
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Today's Attendance"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: "History",
              icon: const Icon(Icons.timeline_sharp),
              onPressed: () {
                Get.to(const History());
              },
            ),
          ),
        ],
      ),
      body: _check(),
    );
  }

  getAttendance() async {
    try {
      final response = await http.get(
        Uri.parse('${api}api/rest/recent'),
      );

       log(response.body);

      if (response.statusCode == 200) {
        setState(() {
          attLoad = false;
        });
        var listAttendance = json.decode(response.body);
        listAttendance.forEach((element) {
          setState(() {
            todaysAttendance.add(Attendance.fromJson(element));
          });
        });
      } else {
        setState(() {
          attLoad = false;
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
        attLoad = false;
      });
      // print(e);
    }
  }

  _check() {
    if (!attLoad && todaysAttendance.isNotEmpty) {
      return
        // RefreshIndicator(
        //   onRefresh: () async {
        //     setState(() {
        //       attLoad = true;
        //     });
        //     todaysAttendance.clear();
        //     await getAttendance();
        //   },
        //   child: ListView(
        //
        //     children: [
        //       FittedBox(
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           child: DataTable(
        //             horizontalMargin: 10,
        //             showBottomBorder: true,
        //
        //             columns: [
        //               DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
        //               DataColumn(label: Text('First In/\nOut',style: TextStyle(fontWeight: FontWeight.bold),)),
        //              // DataColumn(label: Text('First Out')),
        //               DataColumn(label: Text('Second In/\nOut',style: TextStyle(fontWeight: FontWeight.bold),)),
        //               // DataColumn(label: Text('Second Out')),
        //             ],
        //             rows: todaysAttendance.map((todaysAttendance) {
        //               return DataRow(
        //                 cells: [
        //                   DataCell(Text(todaysAttendance.name)),
        //                   DataCell(Column(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Text(todaysAttendance.firstIn),
        //                       Text(todaysAttendance.firstOut)
        //                     ],
        //                   )),
        //                   //DataCell(Text(todaysAttendance.firstOut)),
        //                   DataCell(Column(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Text(todaysAttendance.secondIn),
        //                       Text(todaysAttendance.secondOut)
        //                     ],
        //                   )),
        //                   // DataCell(Text(todaysAttendance.secondOut)),
        //                 ],
        //               );
        //             }).toList(),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // );

        Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '    Name',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'IN',
                style: TextStyle(color: Colors.green, fontSize: 18),
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
                  attLoad = true;
                });
                todaysAttendance.clear();
                await getAttendance();
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: todaysAttendance.length,
                  // reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    // var items = todaysAttendance[index];
                    var items = todaysAttendance[todaysAttendance.length - index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: ListTile(
                        leading: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Text(
                            items.name,
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
                              // const SizedBox(height: 5,),
                              // Text(
                              //   items.secondIn,
                              //   style: const TextStyle(
                              //       fontSize: 14,),
                              // ),
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
                              // const SizedBox(height: 5,),
                              // Text(
                              //   items.secondOut,
                              //   style: const TextStyle(
                              //       fontSize: 14,),
                              // ),
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
    } else if (!attLoad && todaysAttendance.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            attLoad = true;
          });
          todaysAttendance.clear();
          await getAttendance();
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
}
