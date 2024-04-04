import 'package:flutter/material.dart';
import 'package:toonrecommendation/Screen/list.dart';
import 'package:toonrecommendation/models/webtoon_kakao_model.dart';
import 'package:toonrecommendation/models/webtoon_model.dart';
import 'package:toonrecommendation/services/api_service.dart';
import 'package:toonrecommendation/widget/main_thumb.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreens extends StatelessWidget {
  HomeScreens({super.key});

  final List<String> servicesNameKr = ['네이버 웹툰', '카카오페이지 웹툰', '카카오 웹툰'];
  final List<String> servicesNameEng = ['naver', 'kakaoPage', 'kakao'];

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListBetweenSizeBox(),
                mainNaver(),
                ListBetweenSizeBox(),
                webtoonKakao(webtoonsKakaoPage, servicesNameKr[1]),
                ListBetweenSizeBox(),
                webtoonKakao(webtoonsKakao, servicesNameKr[2]),
              ],
            ),
          ),
        ));
  }

  FutureBuilder<List<WebtoonModel>> mainNaver() {
    return FutureBuilder(
      future: webtoons,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return allListButton(
              context, snapshot, servicesNameKr[0], makeNaverList);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  FutureBuilder<List<WebtoonKakaoModel>> webtoonKakao(
      Future<List<WebtoonKakaoModel>> webtoon, String txt) {
    return FutureBuilder(
      future: webtoon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return allListButton(context, snapshot, txt, makeKakaoList);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget allListButton(BuildContext context, snapshot, String txt, homeList) {
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
        homeList(snapshot),
      ],
    );
  }

  dynamic makeNaverList(snapshot) {
    return SizedBox(
      height: 330,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return MainThumbWidget(
            title: webtoon.title,
            thumb: webtoon.thumb,
            id: webtoon.id,
            service: servicesNameEng[0],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }

  dynamic makeKakaoList(AsyncSnapshot<List<WebtoonKakaoModel>> snapshot) {
    return SizedBox(
      height: 500,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return MainThumbWidget(
            title: webtoon.title,
            thumb: webtoon.img,
            id: webtoon.id,
            service: webtoon.service,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }
}
