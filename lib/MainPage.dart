import 'package:apayo/read_page.dart';
import 'package:apayo/search_page.dart';
import 'package:apayo/write_page.dart';
import 'package:flutter/material.dart';

import 'alarm_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff2E3B62);
    final accentColor = Color(0xff64A1D6);
    final scaffoldBackgroundColor = Color(0xffF5F5F5);
    final ThemeData theme = ThemeData();

    return MaterialApp(
      title: '아파요',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: accentColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            primary: accentColor,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/apayo_ico.png',
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                context,
                '병명 검색',
                SearchPage(),
                Icon(Icons.search, size: 40),
              ),
              _buildButton(
                context,
                '약 알림',
                SearchPage(),
                Icon(Icons.notifications, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                context,
                '건강일지 작성',
                WritePage(),
                Icon(Icons.edit, size: 40),
              ),
              _buildButton(
                context,
                '건강일지 목록',
                ReadPage(),
                Icon(Icons.list, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      Widget page,
      Icon icon
      ) {
    return SizedBox(
      width: 180,
      height: 120,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        icon: Icon(
          icon.icon,
          size: 40,
          color: Color(0xff5CCFD4),
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
          textAlign: TextAlign.center, // 가운데 정렬 추가
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // 동그란 모서리로 변경
          ),
          padding: EdgeInsets.symmetric(vertical: 16), // 버튼 높이 조정
        ),
      ),
    );
  }
}