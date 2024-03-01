import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<int> calculateTotal({lastOpenDate = DateTime}) async {
  // This function calculates the amount of money to be added and subtracted, in total, using the last open date as the start date.
  /* For weekly, we use Monday as the start of the week.
  For monthly, we use the first day of the month as the start of the month.
  For yearly, we use the first day of the year as the start of the year.
  */
  // start by getting the intervals
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringedIntervals = prefs.getString("intervals");
  if (stringedIntervals != null) {
    List<Map<String, String>> intervals = List<Map<String, String>>.from(jsonDecode(stringedIntervals).map((item) => Map<String, String>.from(item)));
    // get the last open date
    DateTime lastOpenDate = DateTime.parse(prefs.getString("last_open_date")!);
    // get the current date
    DateTime currentDate = DateTime.now();
    // get the difference in days
    int differenceInDays = currentDate.difference(lastOpenDate).inDays;
    // get the difference in weeks
    int differenceInWeeks = differenceInDays ~/ 7;
    // get the difference in months
    int differenceInMonths = currentDate.month - lastOpenDate.month + 12 * (currentDate.year - lastOpenDate.year);
    // get the difference in years
    int differenceInYears = currentDate.year - lastOpenDate.year;
    // calculate the total amount to be added and subtracted
    int totalAmount = 0;
    for (var interval in intervals) {
      int amount = int.parse(interval["amount"]!);
      switch (interval["recurrance"]) {
        case "Every Day":
          totalAmount += amount * differenceInDays;
          break;
        case "Every Week":
          totalAmount += amount * differenceInWeeks;
          break;
        case "Every Month":
          totalAmount += amount * differenceInMonths;
          break;
        case "Every Year":
          totalAmount += amount * differenceInYears;
          break;
      }
    }
    // add the total amount to the balance
    int balance = prefs.getInt("balance")!;
    balance += totalAmount;
    //prefs.setInt("balance", balance);
    // if the balance is not null, return it
    return balance;
  } else {
    // if the balance is null, return 0
    return 0;
  }
}