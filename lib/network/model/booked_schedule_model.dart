import 'package:flutter/material.dart';

class BookedScheduleModel {
  final String? bookedId;
  final String? userId;
  final String? doctorId;
  DateTime bookedDate;
  TimeOfDay bookedTime;

  BookedScheduleModel({
    required this.bookedId,
    required this.userId,
    required this.doctorId,
    required this.bookedDate,
    required this.bookedTime,
  });

  factory BookedScheduleModel.fromJson(Map<String, dynamic> json) {
    return BookedScheduleModel(
      bookedId: json['booked_id'],
      userId: json['id_user'],
      doctorId: json['doctor_id'],
      bookedDate: DateTime.parse(json['booked_date']),
      bookedTime: TimeOfDay(
        hour: int.parse(json['booked_time'].split(':')[0]),
        minute: int.parse(json['booked_time'].split(':')[1]),
      ),
    );
  }
}
