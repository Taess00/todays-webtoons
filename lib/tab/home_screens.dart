import 'package:flutter/material.dart';
import 'package:toonrecommendation/Screen/list.dart';
import 'package:toonrecommendation/models/webtoon_kakao_model.dart';
import 'package:toonrecommendation/models/webtoon_naver_model.dart';
import 'package:toonrecommendation/services/api_service.dart';
import 'package:toonrecommendation/widget/loading.dart';
import 'package:toonrecommendation/widget/main_thumb.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreens extends StatelessWidget {
  HomeScreens({super.key});

  final List<String> servicesNameKr = ['네이버 웹툰', '카카오페이지 웹툰', '카카오 웹툰'];
  final List<String> servicesNameEng = ['naver', 'kakaoPage', 'kakao'];

  final Future<List<WebtoonNaverModel>> webtoons =
      ApiService.getTodaysNaverToons();
  late Future<List<WebtoonKakaoModel>> webtoonsKakaoPage;
  late Future<List<WebtoonKakaoModel>> webtoonsKakao;

  void initializeWebtoons() {
    webtoonsKakaoPage = ApiService.getTodaysKakaoToons(servicesNameEng[1]);
    webtoonsKakao = ApiService.getTodaysKakaoToons(servicesNameEng[2]);
  }

  int basicListCount = 5;
  SizedBox ListBetweenSizeBox() => const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    initializeWebtoons();
    initializeDateFormatting('ko_KR', null);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([
              webtoons,
              webtoonsKakaoPage,
              webtoonsKakao,
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<WebtoonNaverModel> naverData =
                    snapshot.data![0] as List<WebtoonNaverModel>;
                List<WebtoonKakaoModel> kakaoPageData =
                    snapshot.data![1] as List<WebtoonKakaoModel>;
                List<WebtoonKakaoModel> kakaoData =
                    snapshot.data![2] as List<WebtoonKakaoModel>;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    mainNaver(context, naverData),
                    ListBetweenSizeBox(),
                    webtoonKakao(context, kakaoPageData, servicesNameKr[1]),
                    ListBetweenSizeBox(),
                    webtoonKakao(context, kakaoData, servicesNameKr[2]),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget mainNaver(BuildContext context, List<WebtoonNaverModel> naverData) {
    return allListButton(context, naverData, servicesNameKr[0], makeNaverList);
  }

  Widget webtoonKakao(
      BuildContext context, List<WebtoonKakaoModel> webtoon, String txt) {
    return allListButton(context, webtoon, txt, makeKakaoList);
  }

  Widget allListButton(
      BuildContext context, List<dynamic> data, String txt, Function homeList) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListScreen2(txt: txt)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  txt,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_forward_ios_outlined)
              ],
            ),
          ),
        ),
        homeList(data),
      ],
    );
  }

  Widget makeNaverList(List<WebtoonNaverModel> snapshot) {
    return SizedBox(
      height: 325,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: MainThumbWidget(
              title: webtoon.title,
              thumb: webtoon.thumb,
              id: webtoon.id,
              service: servicesNameEng[0],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }

  Widget makeKakaoList(List<WebtoonKakaoModel> snapshot) {
    return SizedBox(
      height: 500,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: MainThumbWidget(
              title: webtoon.title,
              thumb: webtoon.img,
              id: webtoon.id,
              service: webtoon.service,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }
}
