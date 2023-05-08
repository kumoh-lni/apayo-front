import 'dart:convert';
import 'package:apayo/hospital_search.dart';
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

      final List<Map<String, dynamic>> evidence = mentionsList
          .map((e) => {'id': e['id'], 'choice_id': 'present'})
          .toList();

      final recommendSpecialistUrl =
          'https://api.infermedica.com/v3/recommend_specialist';
      final recommendSpecialistRequestBody = {
        'sex': 'male',
        'age': {'value': 30},
        'evidence': evidence,
      };

      final recommendSpecialistResponse = await http.post(
        Uri.parse(recommendSpecialistUrl),
        headers: {
          'Content-Type': 'application/json',
          'App-Id': '7807e737',
          'App-Key': _apiKey,
        },
        body: jsonEncode(recommendSpecialistRequestBody),
      );

      if (recommendSpecialistResponse.statusCode == 200) {
        final recommendSpecialistResponseBody =
            jsonDecode(recommendSpecialistResponse.body);
        final specialistName =
            recommendSpecialistResponseBody['recommended_specialist']['name'];

        for (var mention in mentions) {
          mention.recommendedSpecialistName = specialistName;
        }
      }

      // 파파고 API 를 이용하여 name, commonName, recommendedSpecialistName 한글 변환
      final String papagoClientId = "w4lp2Y2UYyYG96qVmqhY";
      final String papagoClientSecret = "gLer4YYvvo";
      final String contentType =
          "application/x-www-form-urlencoded; charset=UTF-8";
      final String papagoUrl = "https://openapi.naver.com/v1/papago/n2mt";

      final futures = mentions.map((mention) async {
        final name = await _translateTextUsingPapago(mention.name, 'en', 'ko',
            papagoUrl, papagoClientId, papagoClientSecret, contentType);
        final commonName = await _translateTextUsingPapago(
            mention.commonName,
            'en',
            'ko',
            papagoUrl,
            papagoClientId,
            papagoClientSecret,
            contentType);
        final recommendedSpecialistName = await _translateTextUsingPapago(
            mention.recommendedSpecialistName,
            'en',
            'ko',
            papagoUrl,
            papagoClientId,
            papagoClientSecret,
            contentType);
        mention.name = name;
        mention.commonName = commonName;
        mention.recommendedSpecialistName = recommendedSpecialistName;

        return mention;
      });

      final results = await Future.wait(futures);
      return results;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> _translateTextUsingPapago(
      String text,
      String source,
      String target,
      String url,
      String clientId,
      String clientSecret,
      String contentType) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': contentType,
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
      body: {'source': source, 'target': target, 'text': text},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final translatedText =
          responseBody['message']['result']['translatedText'];
      return translatedText;
    } else {
      throw Exception('Failed to translate text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과'),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Mention> mentions = snapshot.data as List<Mention>;
            return ListView.builder(
              itemCount: mentions.length,
              itemBuilder: (context, index) {
                final mention = mentions[index];
                return ListTile(
                  title: Text(mention.name),
                  subtitle: Text(mention.commonName),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitalSearchPage(
                            recommendedSpecialistName: mention.recommendedSpecialistName, //유심히 볼만한 내용
                          ),
                        ),
                      );
                    },
                    child: Text('병원 찾기'),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Mention {
  final String id;
  String name;
  String commonName;
  String recommendedSpecialistName;

  Mention({
    required this.id,
    required this.name,
    required this.commonName,
    required this.recommendedSpecialistName,
  });

  factory Mention.fromJson(Map<String, dynamic> json) {
    return Mention(
      id: json['id'],
      name: json['name'],
      commonName: json['common_name'],
      recommendedSpecialistName: '',
    );
  }
}
