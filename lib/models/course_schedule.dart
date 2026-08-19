enum AttendanceStatus { open, checkedIn, upcoming, closed }

class CourseSchedule {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String lecturer;
  final String time;
  final String room;
  final int credits;
  final AttendanceStatus status;
  final String? checkInTime;

  CourseSchedule({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.lecturer,
    required this.time,
    required this.room,
    required this.credits,
    required this.status,
    this.checkInTime,
  });
}
