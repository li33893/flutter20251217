import 'package:cloud_firestore/cloud_firestore.dart';//让 Flutter 可以操作 Firestore 数据库
import 'package:firebase_core/firebase_core.dart';//用来 初始化 Firebase
import 'package:flutter/material.dart';//Flutter 的 UI 组件库（Scaffold / AppBar / TextField 等）
import '../firebase_options.dart';//Firebase 自动生成的配置文件


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();//告诉 Flutter：“我在 runApp 之前要干点系统级别的事情（比如 Firebase）”
//   await Firebase.initializeApp(//await：等 Firebase 初始化完成;
//     options: DefaultFirebaseOptions.currentPlatform, //options:使用你当前平台（Android / iOS / Web）的配置
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,//去掉右上角 DEBUG 标志
//       home: SignUpPage(),
//     );
//   }
// }

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String gender = 'M';

  ///五、状态变量（页面持有的数据）
  final FirebaseFirestore fs=FirebaseFirestore.instance;

  ///TextEditingController（四个输入框）
  final TextEditingController _memberId = TextEditingController(); // 이름 입력 컨트롤러
  final TextEditingController _pwd = TextEditingController(); // 나이 입력 컨트롤러
  final TextEditingController _pwd2 = TextEditingController();
  final TextEditingController _name = TextEditingController(); // 나이 입력 컨트롤러

  bool JoinFlg=false;

  ///六、중복체크 (ID重复检查)
  Future <void> _repCheck() async {//因为查一次所以用Future:给“调用这个函数的人”一个“等你完成”的能力
    // 1. 先检查输入框是否为空
    if (_memberId.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디를 입력해주세요')),
      );
      return;
    }

    // 2. 从 Firestore 获取所有 member 数据
    final snapshot = await fs.collection("member").get();
    //底下一大堆过程其实等于: await fs.collection("member").where("memberId",isEqualTo:_memberId.text.trim()).get()

    // 3. 定义一个标志，假设ID可用
    bool isDuplicate = false;

    // 4. 遍历所有文档，检查是否有相同的 memberId
    //什么是doc:
    //     {
    //       "name": "Tom",
    //       "age": 20,
    //       "isMember": true
    //     }

    //snapshot 不是一条数据,里面装的是多条文档
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();//到档案里把doc拿出来

      // 如果找到相同的 memberId
      if (data["memberId"] == _memberId.text.trim()) {
        isDuplicate = true;
        break; // 找到就退出循环
      }
    }

    // 5. 根据结果显示提示
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 사용 중인 아이디입니다')), // ID已存在
      );
    } else {
      setState(() {
        JoinFlg=true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용 가능한 아이디입니다')), // ID可用
      );
    }
  }

  ///八、_insertMember()（真正用的插入函数）
  void _insertMember() async {//没有future是因为持续监听
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference members = fs.collection("member");

    // 1. 检查所有输入框是否为空
    if (_memberId.text.trim().isEmpty ||
        _pwd.text.trim().isEmpty ||
        _pwd2.text.trim().isEmpty ||
        _name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목을 입력해주세요')),
      );
      return;
    }

    if (_pwd.text != _pwd2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 일치하지 않습니다')), // 密码不一致
      );
      return;
    }

    await members.add({
      'memberId': _memberId.text,
      'pwd': _pwd.text,
      'name': _name.text,
      'gender':gender,

      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("회원가입 성공!"))
    );

    print('Member inserted successfully');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),

                // 아이디, 중복체크
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled:!JoinFlg,
                        controller: _memberId,
                        decoration: InputDecoration(
                          labelText: '아이디',
                          hintText: '아이디를 입력하세요',
                          prefixIcon: Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _repCheck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: Text('중복체크'),
                      ),
                    ),
                  ],
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
                SizedBox(height: 16),

                // 비밀번호 확인
                TextField(
                  obscureText: true,
                  controller: _pwd2,
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 다시 입력하세요',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // 이름
                TextField(
                  controller:_name,
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintText: '홍길동',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // 성별
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text('남자'),
                        value: 'M',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('여자'),
                        value: 'F',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        dense: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // 회원가입 버튼
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: JoinFlg?_insertMember:null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}