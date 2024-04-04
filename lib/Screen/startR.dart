import 'package:flutter/material.dart';
import 'package:toonrecommendation/widget/homebotton.dart';

class startR extends StatelessWidget {
  const startR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '추천 받고 싶은 웹툰의\n취향을 골라주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'pretendard_semibold',
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 480,
                child: ListView(
                  children: const [
                    // Add your ListView items here
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF80DD2E),
                  minimumSize: const Size(150, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeBotton()),
                  );
                },
                child: const Text(
                  '항목 선택 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
