import 'package:flutter/material.dart';

class AddMedicationPage extends StatefulWidget {
  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  String name = '';
  String time = '';
  String days = '';
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약 추가'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Icon(
              Icons.local_hospital,
              size: 80.0,
              color: Color(0xff5CCFD4),
            ),
            SizedBox(height: 16.0),
            Text(
              '새로운 약 추가',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                labelText: '약 이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  time = value;
                });
              },
              decoration: InputDecoration(
                labelText: '시간',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  days = value;
                });
              },
              decoration: InputDecoration(
                labelText: '매일/요일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            SwitchListTile(
              title: Text(
                '알림 On/Off',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && time.isNotEmpty && days.isNotEmpty) {
                  Medication medication = Medication(name, time, days, isOn);
                  Navigator.pop(context, medication);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('입력 오류'),
                        content: Text('모든 필드를 입력해주세요.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff5CCFD4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                '약 추가하기',
                style: TextStyle(
                  fontSize:21.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Medication {
  String name;
  String time;
  String days;
  bool isOn;

  Medication(this.name, this.time, this.days, this.isOn);
}
