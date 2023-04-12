import 'package:flutter/material.dart';

class KakaoLoginPage extends StatefulWidget {
  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('카카오 로그인 페이지'),
      ),
      body: Center(
        child: Text(
          '카카오 로그인 페이지',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}