import 'dart:async';
import 'dart:io'; // 앱 종료용
import 'package:flutter/material.dart';
import 'package:when2meet/dimensions/configs/colorConfig.dart';
import 'package:when2meet/dimensions/configs/logoConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';
import 'package:when2meet/screens/account/signupIntroScreen.dart';
import 'package:when2meet/screens/mainScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ScreenConfig sc = ScreenConfig.instance;
  bool _networkConnected = false;
  bool _timeoutOccurred = false;

  // 초기 설정
  @override
  void initState() {
    super.initState();
    _checkConnectionWithTimeout();
  }

  //새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //변화하는 스크린 사이즈에 맞춰서 변하는 변수
    final size = MediaQuery.of(context).size;
    sc.updateScreenVariables(size);
  }

  // 인터넷 연결 확인은 최대 20초까지. 이걸 위한 함수.
  Future<void> _checkConnectionWithTimeout() async {
    final completer = Completer<void>();

    Timer(const Duration(seconds: 20), () {
      if (!_networkConnected) {
        _timeoutOccurred = true;
        if (mounted) _showTimeoutDialog();
        completer.complete();
      }
    });

    while (!_networkConnected && !_timeoutOccurred) {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();

      final resultList = connectivityResult is List
          ? connectivityResult
          : [connectivityResult];

      if (resultList.contains(ConnectivityResult.mobile) ||
          resultList.contains(ConnectivityResult.wifi)) {
        final internetAvailable = await hasInternetConnection();

        if (internetAvailable) {
          _networkConnected = true;
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpIntroScreen(),
              ),
            );
          }
          completer.complete();
          break;
        }
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    return completer.future;
  }

  // 인터넷 연결 확인하는 함수. response가 204일 경우 연결이 된 것이다.
  Future<bool> hasInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.gstatic.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // 다시 시도 버튼 눌렀을 때의 행동.
  void tryAgain() {
    if (!_networkConnected) {
      setState(() {
        _timeoutOccurred = false;
      });
      Navigator.pop(context);
      _checkConnectionWithTimeout(); // 재시도
    }
  }

  // 인터넷 연결 실패시 뜨는 창
  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConfig.primaryColorBackground,
        title: Text(
          "인터넷 연결 없음",
          style: TextStyle(
            color: ColorConfig.iconColor,
            fontSize: SizeConfig.size28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "인터넷에 연결을 확인해주세요.",
              style: TextStyle(
                color: ColorConfig.iconColor,
                fontSize: SizeConfig.size16,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 다시 시도 버튼
                TextButton(
                  onPressed: tryAgain,
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConfig.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeConfig.size20,
                      vertical: SizeConfig.size14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.size8),
                    ),
                  ),
                  child: Text(
                    "다시 시도",
                    style: TextStyle(
                      color: ColorConfig.iconColor,
                      fontSize: SizeConfig.size20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // 확인 버튼
                TextButton(
                  onPressed: () => exit(0),
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConfig.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeConfig.size20,
                      vertical: SizeConfig.size14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.size8),
                    ),
                  ),
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color: ColorConfig.iconColor,
                      fontSize: SizeConfig.size20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF424242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: LogoConfig.mainLogo["width"]! * sc.screenWidth,
              height: LogoConfig.mainLogo["height"]! * sc.screenWidth,
              child: Image.asset(LogoConfig.mainLogoPath),
            ),
            SizedBox(height: sc.screenHeight / 4),
            CircularProgressIndicator(color: ColorConfig.iconColor),
            SizedBox(height: sc.screenHeight / 8),
            Text(
              "네트워크 연결을 확인 중입니다...",
              style: TextStyle(
                color: ColorConfig.iconColor,
                fontSize: SizeConfig.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
