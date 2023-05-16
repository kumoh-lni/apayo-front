import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedGender;
  int? _selectedBirthYear;

  final _apiUrl = 'https://apayo-vcos.run.goorm.site/register'; // 서버 API 주소

  final _birthYearList = List.generate(100, (index) => 2022 - index);

  Future<void> registerUser() async {
    final username = _idController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final birthYear = _selectedBirthYear;
    final gender = _selectedGender;

    // 요청에 필요한 데이터를 JSON 형태로 변환
    final jsonData = {
      'username': username,
      'password': password,
      'name': name,
      'birth_year': birthYear,
      'gender': gender,
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      final responseData = json.decode(response.body);

      // 회원가입 성공 메시지 출력
      if (responseData['message'] == 'User registered successfully') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('회원가입 성공'),
            content: Text('회원가입이 성공적으로 완료되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/'); // main.dart로 이동
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // 오류 처리
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('오류 발생'),
          content: Text('회원가입 중 오류가 발생했습니다.'),
          actions: [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '아이디를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '비밀번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '비밀번호 확인을 입력하세요';
                      }
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '이름을 입력하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    value: _selectedBirthYear,
                    items: _birthYearList.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year년'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBirthYear = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '출생년도',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '출생년도를 선택하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ['남성', '여성']
                        .map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '성별',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '성별을 선택하세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff5CCFD4), // 버튼 색상 설정
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          // 회원가입 로직 처리
                          registerUser();
                        }
                      },
                      child: Text('회원가입'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}