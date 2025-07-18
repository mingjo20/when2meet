import 'package:flutter/material.dart';
import 'package:when2meet/screens/calendarScreen.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //screen configuration object
  ScreenConfig sc = ScreenConfig.instance;
  //초기화
  @override
  void initState() {
    super.initState();
  }

  //새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //변화하는 스크린 사이즈에 맞춰서 변하는 변수
    final size = MediaQuery.of(context).size;
    sc.updateScreenVariables(size);
  }

  //functions
  void onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF424242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => onTap(),
              child: Container(
                color: const Color(0xFFE9435A),
                child: SizedBox(
                  width: sc.screenWidth * 0.8,
                  height: sc.screenHeight * 0.1,
                ),
              ),
            ),
            SizedBox(height: sc.h / 10),
          ],
        ),
      ),
    );
  }
}
