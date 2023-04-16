import 'dart:convert';

import 'package:apayo/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'symptomcheck_page.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String serverIP = '로컬 호스트 주소';
  final String apiPath = '/api/parts';

  List<String> _bodyParts = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse("http://$serverIP$apiPath"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final parts = data['data'] as List<dynamic>;
        setState(() {
          _bodyParts = parts.map((p) => p['name'].toString()).toList();
        });
      } else {
        // handle error
      }
    } catch (e) {
      // handle error
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('병명 검색'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _bodyParts
              .map(
                (part) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // handle button press
                  },
                  child: Text(part),
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}