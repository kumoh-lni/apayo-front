import 'dart:convert';

import 'package:apayo/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SymptomCheckPage extends StatefulWidget {
  final String username; // username 추가
  final int selectedPartId;
  final String selectedPartName;

  const SymptomCheckPage({
    Key? key,
    required this.username, // username 추가
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
    final String uri = 'https://apayo-vcos.run.goorm.site/part/${widget.selectedPartId}';
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        final data = utf8.decode(response.bodyBytes);
        final decodedData = json.decode(data);
        final symptoms = decodedData as List<dynamic>; // 'data' 키는 없으므로 수정
        setState(() {
          _symptoms = symptoms.map((s) => {
            'korean_description': s['korean_description'].toString(),
            'english_description': s['english_description'].toString(),
          }).toList();
          _isChecked = List<bool>.generate(_symptoms.length, (index) => false);
        });
      } else {
        throw Exception('서버 연결 오류');
      }
    } catch (e) {
      throw Exception('서버 연결 오류');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '증상 선택',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView.builder(
          itemCount: _symptoms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  title: Text(
                    _symptoms[index]['korean_description']!,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked[index] = value!;
                    });
                  },
                  activeColor: Color(0xff5CCFD4),
                  controlAffinity: ListTileControlAffinity.leading,
                  checkColor: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SizedBox(
          height: 56.0,
          child: ElevatedButton(
            onPressed: () {
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
                return;
              }

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
                    username: widget.username, // Pass the username
                    selectedPart: selectedPart.toString(),
                    selectedSymptoms: selectedSymptoms,
                  ),
                ),
              );
            },
            child: Text(
              '결과 확인',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff5CCFD4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

