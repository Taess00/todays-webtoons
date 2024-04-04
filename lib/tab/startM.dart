import 'package:flutter/material.dart';
import 'package:toonrecommendation/Screen/start.dart';

class StartM extends StatelessWidget {
  const StartM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              '오늘의 웹툰',
              style: TextStyle(
                fontFamily: 'pretendard_black',
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '웹툰내용 간단요약',
              style: TextStyle(
                fontFamily: 'pretendard_black',
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 250,
              height: 280,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    Colors.white, // You may replace it with any color or image
              ),
              // You may place your ImageView here
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                const StartScreen();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                '웹툰 다시 고르기',
                style: TextStyle(
                  fontFamily: 'pretendard_bold',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF82B1FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(120, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
