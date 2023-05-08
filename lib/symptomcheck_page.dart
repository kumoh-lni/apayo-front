import 'dart:convert';

import 'package:apayo/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SymptomCheckPage extends StatefulWidget {
  final int selectedPartId;
  final String selectedPartName;

  const SymptomCheckPage({
    Key? key,
    required this.selectedPartId,
    required this.selectedPartName,
  }) : super(key: key);

  @override
  _SymptomCheckPageState createState() => _SymptomCheckPageState();
}

class _SymptomCheckPageState extends State<SymptomCheckPage> {
  List<Map<String, String>> _symptoms = [];
  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final String uri = 'http://10.0.2.2:8081/api/symptoms/${widget.selectedPartId}';

    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        final data = utf8.decode(response.bodyBytes); // utf8 디코딩 추가
        final decodedData = json.decode(data);
        final symptoms = decodedData['data'] as List<dynamic  >;
        setState(() {
          _symptoms = symptoms.map((s) => {
            'korean_description': s['korean_description'].toString(),
            'english_description': s['english_description'].toString(),
          }).toList();
          _isChecked = List<bool>.generate(_symptoms.length, (index) => false);
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
          title: Text('${widget.selectedPartName} 관련 증상'),
        ),
        body: ListView.builder(
          itemCount: _symptoms.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(
                _symptoms[index]['korean_description']!,
                style: TextStyle(fontSize: 20),
              ),
              value: _isChecked[index],
              onChanged: (bool? value) {
                setState(() {
                  _isChecked[index] = value!;
                });
              },
            );
          },
        ),
        bottomNavigationBar: SizedBox(
            height: 70,
            child: ElevatedButton(
            onPressed: () {
        // 체크된 증상이 있는지 확인
        bool isCheckedSymptomExist = _isChecked.contains(true);

    if (!isCheckedSymptomExist) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('증상 선택 필요'),
            content: Text('적어도 하나 이상의 증상을 선택해주세요.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return; // 체크된 증상이 없으면 더 이상 진행하지 않음
    }

    // 선택한 부위와 증상을 가져와서 SearchResultPage로 전달
    final selectedPart = {
      'id': widget.selectedPartId,
      'name': widget.selectedPartName
    };
    final selectedSymptoms = _symptoms
        .where((symptom) => _isChecked[_symptoms.indexOf(symptom)])
        .map((symptom) => symptom['english_description']!)
        .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              selectedPart: selectedPart.toString(),
              selectedSymptoms: selectedSymptoms,
            ),
          ),
        );
            },
              child: Text(
                '결과 확인',
                style: TextStyle(fontSize: 24),
              ),
            ),
        ),
    );
  }
}
