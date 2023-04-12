import 'package:apayo/KakaoLoginPage.dart';
import 'package:apayo/MainPage.dart';
import 'package:apayo/SignUpPage.dart';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '로그인 회원가입 테스트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80.0,
            ),
            Image.asset(
              'assets/apayo_logo.png',
              height: 150.0,
            ),
            SizedBox(
              height: 48.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KakaoLoginPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                width: double.infinity,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(
                  'assets/kakao_login_large_wide.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}