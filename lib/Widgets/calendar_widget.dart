import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DatePickerController _controller = DatePickerController();
  DateTime _selectedDayValue = DateTime.now();
  DateTime _selectedMonthValue = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  // Function to get total days in a month
  int daysInMonth(DateTime date) {
    var firstDayThisMonth = firstDayOfMonth(date);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // Function to get the first day of the month
  DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Glassmorphism container
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Semi-transparent background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withOpacity(0.3)), // Optional border
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                  children: [
                    Text(
                      'Calendar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left, // Align text to left
                    ),
                    SizedBox(height: 10),
                    DatePicker(
                      firstDayOfMonth(_selectedMonthValue),
                      width: 60,
                      height: 90,
                      controller: _controller,
                      initialSelectedDate: _selectedDayValue,
                      selectionColor: Colors.tealAccent,
                      selectedTextColor: Colors.black,
                      daysCount: daysInMonth(_selectedMonthValue),
                      locale: "en_US", // Set locale to U.S. English
                      onDateChange: (date) {
                        setState(() {
                          _selectedDayValue = date;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
