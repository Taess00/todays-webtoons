import 'package:flutter/material.dart';
import 'package:toonrecommendation/tab/home_screens.dart';
import 'package:toonrecommendation/tab/startM.dart';
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
    const recommendscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 현재 선택된 페이지 표시
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex, // 현재 선택된 인덱스
        onTap: _onItemTapped, // 탭을 눌렀을 때 실행할 함수
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: '오늘의 웹툰보기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '좋아요한 웹툰',
          ),
        ],
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
    return const StartM();
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
    return const recommendscreen();
  }
}
