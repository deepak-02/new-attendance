// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

List<Attendance> attendanceFromJson(String str) =>
    List<Attendance>.from(json.decode(str).map((x) => Attendance.fromJson(x)));

String attendanceToJson(List<Attendance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attendance {
  Attendance({
    required this.id,
    required this.firstIn,
    required this.firstOut,
    required this.secondIn,
    required this.secondOut,
    required this.name,
    required this.email,
    required this.count,
    required this.para,
    required this.last,
    required this.date,
    required this.time,
    required this.month,
    required this.batch,
  });

  int id;
  String firstIn;
  String firstOut;
  String secondIn;
  String secondOut;
  String name;
  String email;
  int count;
  String para;
  String last;
  DateTime date;
  String time;
  String month;
  String batch;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        firstIn: json["first_In"],
        firstOut: json["first_out"],
        secondIn: json["second_In"],
        secondOut: json["second_out"],
        name: json["name"],
        email: json["email"],
        count: json["count"],
        para: json["para"],
        last: json["last"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        month: json["month"],
        batch: json["batch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_In": firstIn,
        "first_out": firstOut,
        "second_In": secondIn,
        "second_out": secondOut,
        "name": name,
        "email": email,
        "count": count,
        "para": para,
        "last": last,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "month": month,
        "batch": batch,
      };
}
