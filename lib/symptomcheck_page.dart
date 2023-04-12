import 'package:flutter/material.dart';
import 'search_result_page.dart';

class SymptomCheckPage extends StatefulWidget {
  final String selectedPart;

  const SymptomCheckPage({Key? key, required this.selectedPart}) : super(key: key);

  @override
  _SymptomCheckPageState createState() => _SymptomCheckPageState();
}

class _SymptomCheckPageState extends State<SymptomCheckPage> {
  final List<String> symptoms = [
    '증상 1',
    '증상 2',
    '증상 3',
    '증상 4',
    '증상 5',
    '증상 6',
    '증상 7',
    '증상 8',
  ];

  final List<bool> isChecked = List<bool>.generate(8, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedPart} 관련 증상'),
      ),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              symptoms[index],
              style: TextStyle(fontSize: 20),
            ),
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value!;
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
            bool isCheckedSymptomExist = isChecked.contains(true);

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
            final selectedPart = widget.selectedPart;
            final selectedSymptoms = symptoms.where((symptom) => isChecked[symptoms.indexOf(symptom)]).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultPage(
                  selectedPart: selectedPart,
                  selectedSymptoms: selectedSymptoms,
                ),
              ),
            );
          },
          child: Text(
            '검색',
            style: TextStyle(fontSize: 20),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
          ),
        ),
      ),
    );
  }
}