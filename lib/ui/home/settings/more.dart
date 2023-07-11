import 'package:flutter/material.dart';
import 'package:get/get.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              tooltip: "back",
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Spacer(),
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 26.0,
                      ),
                    ),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'An app to manage the attendence\n of PTF trainees',
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            //color: Color.fromRGBO(255, 255, 255, 0.5),
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          Text(
                            'Developed by:\n ',
                            style: TextStyle(
                              // color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontSize: 22.0,
                            ),
                          ),
                          Text(
                            'Flutter :          Deepak, Niketh\n',
                            style: TextStyle(
                              //  color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            'Spring boot :   Akhil, Sreehari\n',
                            style: TextStyle(
                              // color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            'Vue js :          Binil, Kanishma\n',
                            style: TextStyle(
                              //color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(
                        'Co-ordinated by\n   Sreeda Manoj\n',
                        style: TextStyle(
                          // color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
