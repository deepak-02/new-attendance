// import 'package:attendance/api.dart';
// import 'package:attendance/ui/bigButton.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChangeApi extends StatefulWidget {
//   const ChangeApi({Key? key}) : super(key: key);
//
//   @override
//   _ChangeApiState createState() => _ChangeApiState();
// }
//
// class _ChangeApiState extends State<ChangeApi> {
//
//   final TextEditingController apiController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     apiController.text = api;
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_outlined)),
//         title: Text("Change API"),
//       ),
//
//
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Spacer(),
//             Text(
//               "Current Api: ${api}"
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: apiController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   hintText: 'API',
//                   labelText: 'API',
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16.0),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: BigButton(
//                 title: "Update",
//                 onPressed: (){
//                   setState(() {
//                     api=apiController.text;
//                   });
//                 },
//               ),
//             ),
//             Spacer(),
//           ],
//         ),
//       ),
//
//     );
//   }
// }
