import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toonrecommendation/models/webtoon_detail__kakao_model.dart';
import 'package:toonrecommendation/models/webtoon_detail_model.dart';
import 'package:toonrecommendation/models/webtoon_episode_model.dart';
import 'package:toonrecommendation/models/webtoon_kakao_model.dart';
import 'package:toonrecommendation/models/webtoon_naver_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String baseKakaoUrl = "https://korea-webtoon-api.herokuapp.com";
  static const String today = "today";

  static Future<List<WebtoonNaverModel>> getTodaysNaverToons() async {
    try {
      final url = Uri.parse('$baseUrl/$today');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body);
        return webtoons
            .map((webtoon) => WebtoonNaverModel.fromJson(webtoon))
            .toList();
      } else {
        throw Exception('오늘의 네이버 웹툰을 가져오는것에 실패하였습니다.');
      }
    } catch (e) {
      throw Exception('서버에 연결을 실패하였습니다.');
    }
  }

  static Future<List<WebtoonKakaoModel>> getTodaysKakaoToons(
      String service) async {
    try {
      final now = DateTime.now();
      final updateDay =
          DateFormat('EEEE').format(now).substring(0, 3).toLowerCase();

      final url =
          Uri.parse('$baseKakaoUrl/?service=$service&updateDay=$updateDay');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body)["webtoons"];
        return webtoons.map((webtoon) {
          if (webtoon["img"].startsWith('//')) {
            webtoon["img"] = webtoon["img"].replaceRange(0, 2, 'https://');
          }
          return WebtoonKakaoModel.fromJson(webtoon);
        }).toList();
      } else {
        throw Exception('오늘의 카카오 웹툰을 가져오는것에 실패하였습니다.');
      }
    } catch (e) {
      throw Exception('서버에 연결을 실패하였습니다.');
    }
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    try {
      final url = Uri.parse("$baseUrl/$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final webtoon = jsonDecode(response.body);
        return WebtoonDetailModel.fromJson(webtoon);
      } else {
        throw Exception('Failed to load toon by id');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    try {
      final url = Uri.parse("$baseUrl/$id/episodes");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> episodes = jsonDecode(response.body);
        return episodes
            .map((episode) => WebtoonEpisodeModel.fromJson(episode))
            .toList();
      } else {
        throw Exception('Failed to load latest episodes by id');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<WebtoonDetailKakaoModel> getKakaoToonById(String title) async {
    try {
      final url = Uri.parse('$baseKakaoUrl/search?keyword=$title');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final webtoon = jsonDecode(response.body);
        return WebtoonDetailKakaoModel.fromJson(webtoon['webtoons'][0]);
      } else {
        throw Exception('Failed to load kakao toon by id');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<WebtoonKakaoModel> getRandomKakaoToon(String service) async {
    try {
      final now = DateTime.now();
      final updateDay =
          DateFormat('EEEE').format(now).substring(0, 3).toLowerCase();

      final url =
          Uri.parse('$baseKakaoUrl/?service=$service&updateDay=$updateDay');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body)["webtoons"];

        if (webtoons.isEmpty) {
          throw Exception('No webtoons available');
        }

        // 랜덤으로 인덱스 선택
        final randomIndex = Random().nextInt(webtoons.length);

        var selectedWebtoon = webtoons[randomIndex];

        if (selectedWebtoon["img"].startsWith('//')) {
          selectedWebtoon["img"] =
              selectedWebtoon["img"].replaceRange(0, 2, 'https://');
        }

        return WebtoonKakaoModel.fromJson(selectedWebtoon);
      } else {
        throw Exception('Failed to load todays kakao toons');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<WebtoonNaverModel> getRandomNaverToon() async {
    try {
      final url = Uri.parse('$baseUrl/$today');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body);

        if (webtoons.isEmpty) {
          throw Exception('No webtoons available');
        }

        // 랜덤으로 인덱스 선택
        final randomIndex = Random().nextInt(webtoons.length);

        var selectedWebtoon = webtoons[randomIndex];

        return WebtoonNaverModel.fromJson(selectedWebtoon);
      } else {
        throw Exception('Failed to load todays naver toons');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
