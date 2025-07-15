import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekScreen extends StatefulWidget {
  final DateTime startDate;
  const WeekScreen({super.key, required this.startDate});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  late List<DateTime> weekDates;
  late List<String> timeSlots;
  final Set<String> selectedKeys = {};

  bool isSelecting = false;
  bool selectMode = true;
  final GlobalKey _gridKey = GlobalKey();
  double cellWidth = 80;
  double cellHeight = 50;

  @override
  void initState() {
    super.initState();
    weekDates = List.generate(
      7,
      (i) => widget.startDate.add(Duration(days: i)),
    );
    timeSlots = List.generate(48, (i) {
      final hour = i ~/ 2;
      final min = (i % 2) * 30;
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    });
  }

  String _key(int row, int col) {
    final date = weekDates[col];
    final time = timeSlots[row];
    return '${DateFormat('yyyy-MM-dd').format(date)}_$time';
  }

  void _applyKey(String key) {
    setState(() {
      if (selectMode) {
        selectedKeys.add(key);
      } else {
        selectedKeys.remove(key);
      }
    });
  }

  void _handleDrag(Offset globalPosition) {
    final renderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPos = renderBox.globalToLocal(globalPosition);
    final col = (localPos.dx / cellWidth).floor();
    final row = (localPos.dy / cellHeight).floor();

    if (row >= 0 && row < 48 && col >= 0 && col < 7) {
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
      appBar: AppBar(
        title: Text(
          '${DateFormat.yMMMMd('ko').format(widget.startDate)} ~ '
          '${DateFormat.yMMMMd('ko').format(weekDates.last)}',
        ),
      ),
      body: Column(
        children: [
          // 요일 헤더
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 60),
                ...weekDates.map((date) {
                  final label = DateFormat('E\ndd').format(date);
                  return Container(
                    width: cellWidth,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(label, textAlign: TextAlign.center),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 시간 라벨
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: timeSlots
                        .map(
                          (time) => Container(
                            width: 60,
                            height: cellHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey[200],
                            ),
                            child: Text(
                              time,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) {
                          final box =
                              _gridKey.currentContext?.findRenderObject()
                                  as RenderBox?;
                          if (box == null) return;
                          final local = box.globalToLocal(
                            details.globalPosition,
                          );
                          final col = (local.dx / cellWidth).floor();
                          final row = (local.dy / cellHeight).floor();
                          if (row >= 0 && row < 48 && col >= 0 && col < 7) {
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
                        onLongPressStart: (details) {
                          isSelecting = true;
                          _handleDrag(details.globalPosition);
                        },
                        onLongPressMoveUpdate: (details) {
                          if (isSelecting) _handleDrag(details.globalPosition);
                        },
                        onLongPressEnd: (_) {
                          isSelecting = false;
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              key: _gridKey,
                              width: cellWidth * 7,
                              height: cellHeight * 48,
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 7 * 48,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      childAspectRatio: cellWidth / cellHeight,
                                    ),
                                itemBuilder: (context, index) {
                                  final row = index ~/ 7;
                                  final col = index % 7;
                                  final key = _key(row, col);
                                  final isSelected = selectedKeys.contains(key);
                                  return Container(
                                    margin: const EdgeInsets.all(0.5),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
