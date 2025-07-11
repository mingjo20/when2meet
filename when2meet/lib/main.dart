import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/logoConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/screens/mainScreen.dart';

void main() {
  //AppBar 색상을 흰색으로 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white70,
      systemNavigationBarDividerColor: Colors.white70,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const Wheen2Meet());
}

class Wheen2Meet extends StatelessWidget {
  const Wheen2Meet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sync_Calendar',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        fontFamily: 'KCC-Ganpan',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ScreenConfig sc = ScreenConfig.instance;
  //초기화
  @override
  void initState() {
    super.initState();
    // 일정 시간 후 MainScreen으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  //새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //변화하는 스크린 사이즈에 맞춰서 변하는 변수
    final size = MediaQuery.of(context).size;
    sc.updateScreenVariables(size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF424242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: LogoConfig.mainLogo["width"]! * sc.screenWidth,
              height: LogoConfig.mainLogo["height"]! * sc.screenWidth,
              child: Image.asset(LogoConfig.mainLogoPath),
            ),
            SizedBox(height: sc.h / 10),
            CircularProgressIndicator(
              color: const Color(0xFFE9435A),
            ), // 로딩 애니메이션
          ],
        ),
      ),
    );
  }
}
