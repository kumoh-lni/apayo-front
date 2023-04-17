import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchResultPage extends StatelessWidget {
  final String selectedPart;
  final List<String> selectedSymptoms;

  const SearchResultPage({
    Key? key,
    required this.selectedPart,
    required this.selectedSymptoms,
  }) : super(key: key);

  final String _apiKey = 'bbde03096c0e6e24fa444625d507ae1d';

  Future<String> _fetchData() async {
    final String url = 'https://api.infermedica.com/v3/parse';
    final Map<String, dynamic> requestBody = {
      "text": "${selectedSymptoms.join(", ")}",
      "age": {"value": 30}
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'App-Id': '7807e737',
        'App-Key': _apiKey,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 통신'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}