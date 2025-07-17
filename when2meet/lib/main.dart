import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
import 'package:when2meet/dimensions/configs/logoConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/screens/mainScreen.dart';
import 'package:intl/date_symbol_data_local.dart';

final ThemeData basicTheme = ThemeData(
  brightness: Brightness.light, // 앱의 전체 밝기 모드 설정 (light 또는 dark)
  primaryColor: Colorconfig.primaryColor, // 앱의 주요 색상, AppBar 및 강조 UI 요소 등에 사용됨
  scaffoldBackgroundColor: Colors.white, // Scaffold의 기본 배경색 (페이지 배경색)
  splashColor: Colors.blue, // 버튼 클릭 시 발생하는 스플래시 효과의 색상 (투명으로 설정하면 없앰)
  highlightColor:
      Colors.purple, // 버튼 등 누를 때의 강조 색상 (보통 회색 하이라이트), 투명으로 설정 시 제거됨
  fontFamily: 'PyeojinGothic', // 앱 전체에 적용될 기본 글꼴

  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 32.0, // 기본 텍스트 크기 (bodyMedium에 한함)
      fontWeight: FontWeight.bold, // 기본 텍스트 두께
      color: Colors.white, // 기본 텍스트 색상
    ),
  ), // 텍스트 스타일 테마 (기본 텍스트 스타일 모음 정의)
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko'); // 한국어 로케일 초기화
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
      locale: const Locale('ko'),
      debugShowCheckedModeBanner: false,
      title: 'Sync_Calendar',
      theme: basicTheme,
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
              color: Colorconfig.secondaryColor,
            ), // 로딩 애니메이션
          ],
        ),
      ),
    );
  }
}
