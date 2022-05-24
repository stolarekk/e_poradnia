import 'dart:ui';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isFree;

  final String doctorId;
  final String doctorName;
  final String doctorLastName;
  final String patientId;
  final String patientName;
  final String patientLastName;

  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = const Color(0xFF700CB8),
    this.isFree = true,

    required this.doctorId,
    required this.doctorName,
    required this.doctorLastName,
    required this.patientId,
    required this.patientName,
    required this.patientLastName,

    this.isAllDay = false,
});
}