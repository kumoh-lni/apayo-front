import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과'),
      ),
      body: Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}