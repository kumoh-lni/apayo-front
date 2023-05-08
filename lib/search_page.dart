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
  final String uri = 'http://10.0.2.2:8081/api/parts';

  List<Map<String, dynamic>> _bodyParts = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        final data = utf8.decode(response.bodyBytes);
        final parts = json.decode(data)['data'] as List<dynamic>;
        setState(() {
          _bodyParts = parts.map<Map<String, dynamic>>((p) => {
            'id': p['id'] as int,
            'name': p['name'].toString(),
          }).toList();
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
        title: Text('부위 선택'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _bodyParts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final part = _bodyParts[index];
          return SizedBox(
            width: 100,
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SymptomCheckPage(
                      selectedPartId: part['id'],
                      selectedPartName: part['name'],
                    ),
                  ),
                );
              },
              child: Text(
                part['name'],
                style: TextStyle(fontSize: 22.0),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
