import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Medication> medications = [
    Medication('약 이름 1', '10:00', '매일', true),
    Medication('약 이름 2', '14:30', '월,수,금', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '약 목록',
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: medications.isEmpty
          ? Center(
        child: Text(
          '약 목록이 없습니다.',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  medications[index].name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.0),
                    Text(
                      '시간: ${medications[index].time}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '매일/요일: ${medications[index].days}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
                trailing: Switch(
                  value: medications[index].isOn,
                  onChanged: (value) {
                    setState(() {
                      medications[index].isOn = value;
                    });
                  },
                  activeColor: Color(0xff5CCFD4),
                  inactiveThumbColor: Colors.grey,
                ),
                leading: Icon(
                  Icons.local_hospital,
                  size: 36.0,
                  color: Color(0xff5CCFD4),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('약 메뉴'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text('수정'),
                              onTap: () {
                                Navigator.pop(context);
                                _editMedication(index);
                              },
                            ),
                            ListTile(
                              title: Text('삭제'),
                              onTap: () {
                                Navigator.pop(context);
                                _deleteMedication(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: FloatingActionButton(
          onPressed: () async {
            final newMedication = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicationPage())
            );
            if (newMedication != null) {
              _addMedication(newMedication);
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _addMedication(Medication newMedication) {
    setState(() {
      medications.add(newMedication);
    });
  }

  void _editMedication(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String newName = medications[index].name;
        String newTime = medications[index].time;
        String newDays = medications[index].days;
        bool newIsOn = medications[index].isOn;
        return AlertDialog(
          title: Text('약 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: newName,
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(
                  labelText: '약 이름',
                ),
              ),
              TextFormField(
                initialValue: newTime,
                onChanged: (value) {
                  newTime = value;
                },
                decoration: InputDecoration(
                  labelText: '시간',
                ),
              ),
              TextFormField(
                initialValue: newDays,
                onChanged: (value) {
                  newDays = value;
                },
                decoration: InputDecoration(
                  labelText: '매일/요일',
                ),
              ),
              SwitchListTile(
                title: Text('알림 On/Off'),
                value: newIsOn,
                onChanged: (value) {
                  newIsOn = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  medications[index] =
                      Medication(newName, newTime, newDays, newIsOn);
                });
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedication(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('약 삭제'),
          content: Text('약을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  medications.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
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
