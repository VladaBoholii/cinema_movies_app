import 'package:cinema_movies_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  var favoriteBox = await Hive.openBox('favoriteMovies');
  var countryBox = await Hive.openBox('country');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.purple.shade100,
        tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.purple,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(
              color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.purple.shade300,
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple[300],
            titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
      home: const MainPage(),
    );
  }
}
