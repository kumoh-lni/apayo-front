import 'dart:convert';
import 'package:apayo/hospital_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchResultPage extends StatefulWidget {
  final String selectedPart;
  final List<String> selectedSymptoms;
  final String username; // Add the username parameter

  const SearchResultPage({
    Key? key,
    required this.selectedPart,
    required this.selectedSymptoms,
    required this.username, // Include the username parameter in the constructor
  }) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}
class _SearchResultPageState extends State<SearchResultPage> {
  final String _apiKey = 'bbde03096c0e6e24fa444625d507ae1d';
  List<Mention> mentions = [];

  Future<List<Mention>> _fetchData() async {
    final String url = 'https://api.infermedica.com/v3/parse';

    final userResponse = await http.get(
      Uri.parse('https://apayo-vcos.run.goorm.site/user/${widget.username}'),
    );

    int age = 30; // Default age value
    String sex = 'male'; // Default gender value

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      age = userData['age'] as int? ?? 30;

      final koreanGender = userData['gender'] as String?;
      if (koreanGender != null) {
        if (koreanGender == '남성') {
          sex = 'male';
        } else if (koreanGender == '여성') {
          sex = 'female';
        }
      }
    }
    //print(age);
    //print(sex);
    final Map<String, dynamic> requestBody = {
      "text": "${widget.selectedSymptoms.join(", ")}",
      "age": {"value": age},
      "sex": sex,
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
        'sex': sex,
        'age': {'value': age},
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
        final name = await _translateTextUsingPapago(
            mention.name,
            'en',
            'ko',
            papagoUrl,
            papagoClientId,
            papagoClientSecret,
            contentType);
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

  Future<String> _translateTextUsingPapago(String text,
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '검색 결과',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '!! 경고 !!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '전문 의료진과 상담하지 않은 채로 이 어플을 사용하실 경우 건강에 해를 끼칠 수 있습니다. 상황에 따라 적절한 조치를 취하기 위해서는 반드시 전문 의료진의 조언을 들으시기 바랍니다.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '검색 결과',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    FutureBuilder(
                      future: _fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<Mention> mentions = snapshot.data as List<Mention>;
                          return Column(
                            children: mentions
                                .map(
                                  (mention) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '병명: ${mention.name}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          mention.commonName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '권장 전문의: ${mention.recommendedSpecialistName}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HospitalSearchPage(
                                              recommendedSpecialistName: mention.recommendedSpecialistName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(                                          'assets/hospital.png',
                                            height: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '병원 찾기',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                                .toList(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
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
