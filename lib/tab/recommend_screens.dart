import 'dart:math';
import 'package:flutter/material.dart';
import 'package:toonrecommendation/models/webtoon_kakao_model.dart';
import 'package:toonrecommendation/models/webtoon_naver_model.dart';
import 'package:toonrecommendation/services/api_service.dart';
import 'package:toonrecommendation/tab/detail_screen.dart'; // 경로 확인 필요
import 'package:toonrecommendation/widget/homebotton.dart';
import 'package:toonrecommendation/widget/loading.dart';

class RecommendScreens extends StatelessWidget {
  const RecommendScreens({super.key});

  Future<dynamic> _fetchRandomWebtoon() async {
    try {
      if (Random().nextBool()) {
        final naverWebtoons = await ApiService.getTodaysNaverToons();
        final randomIndex = Random().nextInt(naverWebtoons.length);
        return naverWebtoons[randomIndex];
      } else {
        final kakaoWebtoons = await ApiService.getTodaysKakaoToons("kakao");
        final randomIndex = Random().nextInt(kakaoWebtoons.length);
        return kakaoWebtoons[randomIndex];
      }
    } catch (e) {
      throw Exception('Failed to fetch random webtoon: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              '오늘의 추천 웹툰',
              style: TextStyle(
                fontFamily: 'pretendard_black',
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.all(30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 355,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withOpacity(0.3), // 검은색 배경 컨테이너
                    ),
                  ),
                  Positioned.fill(
                    child: FutureBuilder<dynamic>(
                      future: _fetchRandomWebtoon(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          var webtoon = snapshot.data;
                          String imageUrl = '';
                          String title = '';
                          String webtoonId = ''; // 가정: webtoon 객체에 ID 필드가 있음
                          String service = ''; // 가정: 서비스 타입 결정 필요

                          if (webtoon is WebtoonKakaoModel) {
                            imageUrl = webtoon.img;
                            title = webtoon.title;
                            webtoonId = webtoon.id.toString(); // id 필드가 있다고 가정
                            service = 'kakao';
                          } else if (webtoon is WebtoonNaverModel) {
                            imageUrl = webtoon.thumb;
                            title = webtoon.title;
                            webtoonId = webtoon.id.toString(); // id 필드가 있다고 가정
                            service = 'naver';
                          }

                          return _buildThumbnailContainer(
                              context,
                              Colors.transparent,
                              imageUrl,
                              title,
                              webtoonId,
                              service);
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeBotton()),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                '다시 고르기',
                style: TextStyle(
                  fontFamily: 'pretendard_bold',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF80DD2E),
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

  Widget _buildThumbnailContainer(BuildContext context, Color backgroundColor,
      String imageUrl, String title, String webtoonId, String service) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailScreen2(
              title: title,
              img: imageUrl,
              webtoonId: webtoonId,
              service: service,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = 0.0;
              var end = 1.0;
              var curve = Curves.easeInOut; // 애니메이션의 가속도를 조절합니다.

              var tween = Tween<double>(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return ScaleTransition(
                scale: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration:
                const Duration(milliseconds: 500), // 전환 지속 시간 조정
          ),
        );
      },
      child: Container(
        width: 260,
        height: 355,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 썸네일을 위로 정렬
          children: [
            if (imageUrl.isNotEmpty)
              Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      imageUrl,
                      headers: const {
                        "User-Agent":
                            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                      },
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (title.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
