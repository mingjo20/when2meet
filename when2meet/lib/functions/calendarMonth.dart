import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/weekScreen.dart';

class CalendarMonthWidget extends StatefulWidget {
  final DateTime date;
  const CalendarMonthWidget({super.key, required this.date});

  @override
  State<CalendarMonthWidget> createState() => _CalendarMonthWidgetState();
}

class _CalendarMonthWidgetState extends State<CalendarMonthWidget> {
  void onTap(DateTime day) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeekScreen(startDate: day)),
    );
  }

  List<Widget> buildDays() {
    final List<Widget> widgets = [];
    final DateTime firstDay = DateTime(widget.date.year, widget.date.month, 1);
    final int weekdayOffset = firstDay.weekday % 7; // Sunday = 0

    // 빈 칸 채우기
    for (int i = 0; i < weekdayOffset; i++) {
      widgets.add(const SizedBox.shrink());
    }

    final int daysInMonth = DateTime(
      widget.date.year,
      widget.date.month + 1,
      0,
    ).day;

    for (int i = 1; i <= daysInMonth; i++) {
      final current = DateTime(widget.date.year, widget.date.month, i);
      widgets.add(
        GestureDetector(
          onTap: () => onTap(current),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: ColorConfig.iconColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$i',
              style: TextStyle(
                color: ColorConfig.iconColor,
                fontSize: SizeConfig.size28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat.yMMMM('ko').format(widget.date);
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        title: Text(
          monthLabel,
          style: TextStyle(
            color: ColorConfig.iconColor,
            fontSize: SizeConfig.size20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.size10),
        child: GridView.count(crossAxisCount: 7, children: buildDays()),
      ),
    );
  }
}
