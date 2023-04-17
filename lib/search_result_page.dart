import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchResultPage extends StatefulWidget {
  final String selectedPart;
  final List<String> selectedSymptoms;

  const SearchResultPage({
    Key? key,
    required this.selectedPart,
    required this.selectedSymptoms,
  }) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final String _apiKey = 'bbde03096c0e6e24fa444625d507ae1d';
  List<Mention> mentions = [];

  Future<List<Mention>> _fetchData() async {
    final String url = 'https://api.infermedica.com/v3/parse';
    final Map<String, dynamic> requestBody = {
      "text": "${widget.selectedSymptoms.join(", ")}",
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
      final responseBody = jsonDecode(response.body);
      final List<dynamic> mentionsList = responseBody['mentions'];
      mentions = mentionsList.map((e) => Mention.fromJson(e)).toList();
      return mentions;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과'),
      ),
      body: Center(
        child: FutureBuilder<List<Mention>>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].commonName),
                  );
                },
              );
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

class Mention {
  final String id;
  final String name;
  final String commonName;

  Mention({
    required this.id,
    required this.name,
    required this.commonName,
  });

  factory Mention.fromJson(Map<String, dynamic> json) {
    return Mention(
      id: json['id'],
      name: json['name'],
      commonName: json['common_name'],
    );
  }
}
