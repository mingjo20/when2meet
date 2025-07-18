import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:when2meet/dimensions/configs/ColorConfig.dart';
import 'package:when2meet/dimensions/configs/screenConfig.dart';
import 'package:when2meet/dimensions/configs/sizeConfig.dart';

/// 주간 시간 선택 화면 위젯
class WeekScreen extends StatefulWidget {
  final DateTime startDate; // 시작 날짜
  const WeekScreen({super.key, required this.startDate});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  ScreenConfig sc = ScreenConfig.instance;

  late List<DateTime> weekDates; // 7일치 날짜 목록
  late List<String> timeSlots; // 1시간단위 시간대 목록 (00:00 ~ 23:00 총 24개)
  final Set<String> selectedKeys = {}; // 선택된 셀의 key 저장용

  bool isSelecting = false; // 드래그로 셀 선택 중인지 여부
  bool selectMode = true; // true: 선택 모드, false: 해제 모드
  final GlobalKey _gridKey = GlobalKey(); // Grid 위치 계산용 키

  // 스크롤 컨트롤러
  final ScrollController _verticalScrollController =
      ScrollController(); // 본격 셀 영역 세로 스크롤
  final ScrollController _timeLabelScrollController =
      ScrollController(); // 좌측 시간 레이블 세로 스크롤
  final ScrollController _horizontalScrollController =
      ScrollController(); // 상단 요일 가로 스크롤

  double dayWidth = 80; // = cellWidth
  double dayHeight = 70;

  double timeWidth = 50;
  double timeHeight = 35; // = cellHeight

  double timeFontSize = 8; // 시간 폰트 사이즈
  double dayFontSize = 10; // 요일 폰트 사이즈

  @override
  void initState() {
    super.initState();

    // 주간 날짜 리스트 생성
    weekDates = List.generate(
      7,
      (i) => widget.startDate.add(Duration(days: i)),
    );

    /*
    // 시간대 리스트 생성 (30분 간격으로)
    timeSlots = List.generate(48, (i) {
      final hour = i ~/ 2;
      final min = (i % 2) * 30;
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    });
    */
    // 시간대 리스트 생성 (1시간 간격으로)
    timeSlots = List.generate(24, (i) {
      final hour = i ~/ 1;
      return '${hour.toString().padLeft(2, '0')}:00';
    });

    // 시간 라벨 스크롤은 본 셀 스크롤에 따라 자동 이동
    _verticalScrollController.addListener(() {
      _timeLabelScrollController.jumpTo(_verticalScrollController.offset);
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _verticalScrollController.dispose();
    _timeLabelScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  /// 셀의 고유 key 생성 (예: 2024-01-01_09:30)
  String _key(int row, int col) {
    final date = weekDates[col];
    final time = timeSlots[row];
    return '${DateFormat('yyyy-MM-dd').format(date)}_$time';
  }

  /// 셀 선택/해제 적용
  void _applyKey(String key) {
    setState(() {
      if (selectMode) {
        selectedKeys.add(key);
      } else {
        selectedKeys.remove(key);
      }
    });
  }

  /// 드래그 중 선택 처리
  void _handleDrag(Offset globalPosition) {
    final renderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPos = renderBox.globalToLocal(globalPosition);
    final col = (localPos.dx / dayWidth).floor();
    final row = (localPos.dy / timeHeight).floor();

    // 유효한 범위일 때만 처리
    if (row >= 0 && row < 24 && col >= 0 && col < 7) {
      final key = _key(row, col);
      if (selectMode && !selectedKeys.contains(key)) {
        _applyKey(key);
      } else if (!selectMode && selectedKeys.contains(key)) {
        _applyKey(key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.primaryColorBackground,
      appBar: AppBar(
        backgroundColor: ColorConfig.primaryColor,
        title: Row(
          children: [
            SizedBox(width: SizeConfig.size40),
            Text(
              //달이 넘어가면 월 정보까지 print하기
              widget.startDate.month != weekDates.last.month
                  ? '${widget.startDate.month}월 ${widget.startDate.day}일 - ${weekDates.last.month}월 ${weekDates.last.day}일'
                  : '${widget.startDate.month}월 ${widget.startDate.day}일 - ${weekDates.last.day}일',
              // 20XX년 XX월 XX일 ~ 20XX년 XX월 XX일 형식으로 나타내고 싶다면 아래 방식으로
              /*
            '${DateFormat.yMMMMd('ko').format(widget.startDate)} ~ '
            '${DateFormat.yMMMMd('ko').format(weekDates.last)}',
             */
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.size20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // 좌측 시간 라벨
          Column(
            children: [
              Container(
                height: dayHeight,
                color: ColorConfig.primaryColor,
              ), // 요일 헤더 높이만큼 패딩
              Expanded(
                child: SingleChildScrollView(
                  controller: _timeLabelScrollController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(), // 직접 스크롤 방지
                  child: Column(
                    children: timeSlots
                        .map(
                          (time) => Container(
                            width: timeWidth,
                            height: timeHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorConfig.primaryColorBackground,
                              ),
                              color: ColorConfig.primaryColor,
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.size12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          // 우측 전체 스케줄 테이블
          Expanded(
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // 상단 요일 헤더
                  Row(
                    children: weekDates.map((date) {
                      final label = DateFormat('E\ndd').format(date);
                      return Container(
                        width: dayWidth,
                        height: dayHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorConfig.primaryColorBackground,
                          ),
                          color: ColorConfig.primaryColor,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.size20,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                  // 셀 영역
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: GestureDetector(
                        // 단일 클릭 시 셀 선택/해제
                        onTapDown: (details) {
                          final box =
                              _gridKey.currentContext?.findRenderObject()
                                  as RenderBox?;
                          if (box == null) return;
                          final local = box.globalToLocal(
                            details.globalPosition,
                          );
                          final col = (local.dx / dayWidth).floor();
                          final row = (local.dy / timeHeight).floor();
                          if (row >= 0 && row < 24 && col >= 0 && col < 7) {
                            final key = _key(row, col);
                            setState(() {
                              if (selectedKeys.contains(key)) {
                                selectedKeys.remove(key);
                                selectMode = false;
                              } else {
                                selectedKeys.add(key);
                                selectMode = true;
                              }
                            });
                          }
                        },
                        // 길게 누르면 드래그 시작
                        onLongPressStart: (details) {
                          isSelecting = true;
                          _handleDrag(details.globalPosition);
                        },
                        // 드래그 이동 중 계속 셀 적용
                        onLongPressMoveUpdate: (details) {
                          if (isSelecting) _handleDrag(details.globalPosition);
                        },
                        // 드래그 종료
                        onLongPressEnd: (_) {
                          isSelecting = false;
                        },
                        child: Container(
                          key: _gridKey,
                          width: dayWidth * 7,
                          height: timeHeight * 24,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics:
                                const NeverScrollableScrollPhysics(), // 내 스크롤 사용
                            itemCount: 7 * 24,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  childAspectRatio: dayWidth / timeHeight,
                                ),
                            itemBuilder: (context, index) {
                              final row = index ~/ 7;
                              final col = index % 7;
                              final key = _key(row, col);
                              final isSelected = selectedKeys.contains(key);
                              //셀 영역 렌더링
                              return Container(
                                margin: const EdgeInsets.all(0.5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.red
                                      : ColorConfig.primaryColor,
                                  border: Border.all(
                                    color: ColorConfig.primaryColorBackground,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
