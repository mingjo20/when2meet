
/*

  Positioned hidingWidget() {
    return Positioned.fill(
      child: IgnorePointer(
        // 터치 이벤트 방지
        child: heightGap > 0
            ? Column(
                children: [
                  Expanded(child: Container(color: Colors.black)), // 상단 덮기
                  SizedBox(
                    height: screenHeight, // 애니메이션 비율 맞춰 조정
                  ),
                  Expanded(child: Container(color: Colors.black)), // 하단 덮기
                ],
              )
            : SizedBox(
                height: screenHeight, // 애니메이션 비율 맞춰 조정
              ),
      ),
    );
  }
 */