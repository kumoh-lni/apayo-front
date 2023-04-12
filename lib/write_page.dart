import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강일지 작성'),
      ),
      body: Container(
        // 건강일지 작성 페이지의 내용을 작성
      ),
    );
  }
}