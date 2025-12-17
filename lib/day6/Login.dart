import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';//让 Flutter 可以操作 Firestore 数据库
import 'package:firebase_core/firebase_core.dart';//用来 初始化 Firebase
import 'package:flutter/material.dart';//Flutter 的 UI 组件库（Scaffold / AppBar / TextField 等）
import '../firebase_options.dart';//Firebase 自动生成的配置文件
import 'Join.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//告诉 Flutter：“我在 runApp 之前要干点系统级别的事情（比如 Firebase）”
  await Firebase.initializeApp(//await：等 Firebase 初始化完成;
    options: DefaultFirebaseOptions.currentPlatform, //options:使用你当前平台（Android / iOS / Web）的配置
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  ///五、状态变量（页面持有的数据）
  final FirebaseFirestore fs=FirebaseFirestore.instance;

  ///TextEditingController（四个输入框）
  final TextEditingController _memberId = TextEditingController(); // 이름 입력 컨트롤러
  final TextEditingController _pwd = TextEditingController(); // 나이 입력 컨트롤러


  Future <void> _logIn() async {
    final snapshot=await fs.collection("member").where("memberId",isEqualTo:_memberId.text.trim()).where("pwd",isEqualTo:_pwd.text.trim()).get();

    if (_memberId.text.trim().isEmpty || _pwd.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디와 비밀번호를 입력해주세요')),
      );
      return;
    }
    if (snapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 성공!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),

                // 아이디
                TextField(
                  controller:_memberId,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 16),

                // 비밀번호
                TextField(
                  obscureText: true,
                  controller: _pwd,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 30),

                // 로그인 버튼

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      elevation: 2,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 20),

                // 하단 안내 텍스트
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니셈?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(width: 6),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}