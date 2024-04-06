import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:toonrecommendation/Screen/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonrecommendation/widget/homebotton.dart';
import 'package:toonrecommendation/widget/loading.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const App());
  FlutterNativeSplash.remove();
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<bool>? _isFirstRunFuture;

  Future<bool> checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
    }
    return isFirstRun;
  }

  @override
  void initState() {
    super.initState();
    _isFirstRunFuture = checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isFirstRunFuture,
        builder: (context, snapshot) {
          // 데이터가 아직 도착하지 않았을 때 로딩 인디케이터를 표시할 수 있습니다.
          if (!snapshot.hasData) {
            return const Center(child: LoadingIndicator());
          }
          // 데이터가 도착하면 isFirstRun에 따라 StartScreen 또는 HomeBotton을 표시합니다.
          final isFirstRun = snapshot.data ?? true;
          return isFirstRun ? const StartScreen() : const HomeBotton();
        },
      ),
    );
  }
}
