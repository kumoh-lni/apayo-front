import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apayo/search_result_page.dart';
import 'package:flutter/material.dart';


import 'symptomcheck_page.dart';

class SearchPage extends StatefulWidget {
  final String username; // username 추가

  const SearchPage({Key? key, required this.username}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String uri = 'https://apayo-vcos.run.goorm.site/part';

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
        final parts = json.decode(data) as List<dynamic>;
        setState(() {
          _bodyParts = parts.map<Map<String, dynamic>>((p) => {
            'part_id': p['part_id'] as int,
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
        title: Text(
          '부위 선택',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _bodyParts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            final part = _bodyParts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SymptomCheckPage(
                      username: widget.username, // username 전달
                      selectedPartId: part['part_id'],
                      selectedPartName: part['name'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.healing,
                      color: Color(0xff5CCFD4),
                      size: 50.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      part['name'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}