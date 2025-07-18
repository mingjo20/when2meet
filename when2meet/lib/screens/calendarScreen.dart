import 'package:flutter/material.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/functions/calendarMonth.dart'; // 해당 위젯은 이전에 구현한 MonthView용 위젯입니다.

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final int totalMonths = 100 * 12 + 12; // 100년 + 1년
  final int currentIndex = 12; // 기준월: index = 12 -> 현재 날짜
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 주어진 index로부터 DateTime을 계산하는 함수
  DateTime getTargetDate(int index) {
    final monthDiff = index - currentIndex;
    return DateTime(DateTime.now().year, DateTime.now().month + monthDiff, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColorBackground,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        title: Text(
          'Sync_Calendar',
          style: TextStyle(
            color: ColorConfig.iconColor,
            fontSize: SizeConfig.size20,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: ColorConfig.iconColor),
            onPressed: () {
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: ColorConfig.iconColor),
            onPressed: () {
              if (_pageController.page! < totalMonths - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: totalMonths,
        itemBuilder: (context, index) {
          final targetDate = getTargetDate(index);
          return CalendarMonthWidget(date: targetDate);
        },
      ),
    );
  }
}
