import 'dart:convert';

import 'package:apayo/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'symptomcheck_page.dart';


class SearchPage extends StatelessWidget {
  final List<String> bodyParts = const [
    '등/허리',
    '다리',
    '골반(생식기)',
    '손',
    '발',
    '목',
    '머리',
    '팔',
    '배',
    '코',
    '귀',
    '입',
    '피부',
  ];

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("병명 검색"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[0]),
                  _buildButton(context, bodyParts[1]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[2]),
                  _buildButton(context, bodyParts[3]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[4]),
                  _buildButton(context, bodyParts[5]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[6]),
                  _buildButton(context, bodyParts[7]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[8]),
                  _buildButton(context, bodyParts[9]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(context, bodyParts[10]),
                  _buildButton(context, bodyParts[11]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, bodyParts[12]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    final String serverIP = '168.126.63.1';
    final String apiPath = '/api/parts';

    final String uri = "http://$serverIP$apiPath";
    final client = http.Client(); // http.Client() 객체 생성

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 100,
        child: TextButton(
          onPressed: () async {
            try {
              final response = await client.get(
                  Uri.parse(uri)); // http.Client() 객체를 사용하여 요청 보내기
              if (response.statusCode == 200) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('성공'),
                        content: Text('병명 검색에 성공했습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('오류'),
                        content: Text('병명 검색 중 오류가 발생했습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                );
              }
            } catch (e) {
              print(e); // 오류 발생 시 에러 메시지 출력
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text('오류'),
                      content: Text('서버와 연결 중 오류가 발생했습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('확인'),
                        ),
                      ],
                    ),
              );
            } finally {
              client.close(); // http.Client() 객체 닫기
            }
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

}