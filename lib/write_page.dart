import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  DateTime? selectedDate;
  String? summary;
  String? details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5CCFD4),
        title: Text(
          '건강일지 작성',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff5CCFD4),
              ),
              child: Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : '날짜 선택',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                labelText: '요약',
                labelStyle: TextStyle(
                  color: Color(0xff5CCFD4),
                ),
              ),
              style: TextStyle(
                color: Color(0xff5CCFD4),
              ),
              onChanged: (value) {
                setState(() {
                  summary = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                labelText: '상세 내용',
                labelStyle: TextStyle(
                  color: Color(0xff5CCFD4),
                ),
              ),
              style: TextStyle(
                color: Color(0xff5CCFD4),
              ),
              onChanged: (value) {
                setState(() {
                  details = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && summary != null && details != null) {
                  saveHealthRecord(
                    DateFormat('yyyy-MM-dd').format(selectedDate!),
                    summary!,
                    details!,
                  );
                  Navigator.pop(context); // 페이지 닫기
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('오류'),
                      content: Text('모든 필드를 입력해주세요.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff5CCFD4),
              ),
              child: Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveHealthRecord(String date, String summary, String details) {
    print('저장된 건강 일지:');
    print('날짜: $date');
    print('요약: $summary');
    print('상세 내용: $details');
  }
}
