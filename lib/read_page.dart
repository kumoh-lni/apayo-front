import 'package:flutter/material.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강일지 목록'),
      ),
      body: Container(
        // 건강일지 목록 페이지의 내용을 작성
      ),
    );
  }
}