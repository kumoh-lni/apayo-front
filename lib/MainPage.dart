import 'package:apayo/read_page.dart';
import 'package:apayo/search_page.dart';
import 'package:apayo/write_page.dart';
import 'package:flutter/material.dart';

import 'alarm_page.dart';
import 'main.dart';

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
      home: const MainPage(username: '',),
    );
  }
}
class MainPage extends StatelessWidget {
  final String username; // username 추가

  const MainPage({required this.username, Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '아파요',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/apayo_ico.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 32),
            Text(
              '안녕하세요 $username 님',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  context,
                  '병명 검색',
                  SearchPage(username: username), // username 전달
                  Icon(Icons.search, size: 40, color: Colors.blue),
                ),
                _buildButton(
                  context,
                  '약 알림',
                  SearchPage(username: username),
                  Icon(Icons.notifications, size: 40, color: Colors.orange),
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
                  Icon(Icons.edit, size: 40, color: Colors.green),
                ),
                _buildButton(
                  context,
                  '건강일지 목록',
                  ReadPage(),
                  Icon(Icons.list, size: 40, color: Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _logout(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 40, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '로그아웃',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      Widget page,
      Icon icon,
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
        icon: icon,
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

