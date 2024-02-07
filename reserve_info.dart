import 'package:time_range_picker/time_range_picker.dart';

class ReserveInfo {
  ReserveInfo(
    this.id,
    this.name,
    this.place,
    this.date,
    this.selectTime,
    this.totalNum,
    this.wantNum,
    this.currentNum,
    this.isWant,
  );

  final String id;
  final String name;
  final String place;
  final DateTime date;
  final TimeRange selectTime;
  final int totalNum;
  final int wantNum;
  final int currentNum;
  final String isWant;
}