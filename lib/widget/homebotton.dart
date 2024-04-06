import 'package:flutter/material.dart';
import 'package:toonrecommendation/tab/home_screens.dart';
import 'package:toonrecommendation/tab/recommend_screens.dart';
import 'package:toonrecommendation/widget/recommend.dart';

class HomeBotton extends StatelessWidget {
  const HomeBotton({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // 각 인덱스에 따른 페이지 목록
  final List<Widget> _pages = [
    const HomeScreen(),
    const WebtoonScreen(),
    const Loveddscreen(),
    const RecommendScreens(),
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // '취소하기' 선택
                child: const Text('취소하기'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // '종료하기' 선택
                child: const Text('종료하기'),
              ),
            ],
          ),
        );

        return shouldPop ?? false; // showDialog가 null을 반환할 경우를 대비하여 false 반환
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor:
              Colors.white.withOpacity(0.5), // 선택되지 않았을 때 아이콘의 투명도 조정
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0
                  ? Icons.home
                  : Icons.home_outlined), // 조건부 아이콘
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? Icons.chrome_reader_mode
                  : Icons.chrome_reader_mode_outlined),
              label: '오늘의 웹툰보기',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 2 ? Icons.favorite : Icons.favorite_border),
              label: '좋아요한 웹툰',
            ),
          ],
        ),
      ),
    );
  }

  // 탭을 눌렀을 때 실행할 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스 변경
    });
  }
}

// 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecommendScreens();
  }
}

// 웹툰 화면
class WebtoonScreen extends StatelessWidget {
  const WebtoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreens();
  }
}

//좋아요 누른 화면
class RecommendScreen extends StatelessWidget {
  const RecommendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Loveddscreen();
  }
}
