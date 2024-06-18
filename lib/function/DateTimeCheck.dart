import 'package:flutter/cupertino.dart';

class DateTimeCheck{
  bool isBetween(DateTime selectedDate, DateTime afterDate, DateTime beforeDate){
    debugPrint('selectedDate: $selectedDate, openTime: $afterDate, closeTime: $beforeDate');

    return selectedDate.isAfter(afterDate) && selectedDate.isBefore(beforeDate);
  }

  bool isBeforeOrSame(DateTime selectedDate, DateTime beforeDate){
    return selectedDate.isBefore(beforeDate) || selectedDate.isAtSameMomentAs(beforeDate);
  }

  bool isAfterOrSame(DateTime selectedDate, DateTime afterDate){
    return selectedDate.isAfter(afterDate) || selectedDate.isAtSameMomentAs(afterDate);
  }
}