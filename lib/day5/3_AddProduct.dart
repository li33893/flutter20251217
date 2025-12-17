///一、import 部分（你在用哪些能力）

import 'package:cloud_firestore/cloud_firestore.dart';//让 Flutter 可以操作 Firestore 数据库
import 'package:firebase_core/firebase_core.dart';//用来 初始化 Firebase
import 'package:flutter/material.dart';//Flutter 的 UI 组件库（Scaffold / AppBar / TextField 等）
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../firebase_options.dart';//Firebase 自动生成的配置文件
import '3_productList.dart';

///二、main 函数（整个程序的起点）
void main() async {
  await dotenv.load(fileName:'.env');
  WidgetsFlutterBinding.ensureInitialized();//告诉 Flutter：“我在 runApp 之前要干点系统级别的事情（比如 Firebase）”
  await Firebase.initializeApp(//await：等 Firebase 初始化完成;
    options: DefaultFirebaseOptions.currentPlatform, //options:使用你当前平台（Android / iOS / Web）的配置
  );
  runApp(const MyApp());//启动 Flutter 应用,整个 UI 从 MyApp 开始
}

///三、MyApp（整个应用的外壳）
class MyApp extends StatelessWidget {//为什么是 StatelessWidget？MyApp 本身不变,只是一个“壳”，真正变化的页面在里面
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//去掉右上角 DEBUG 标志
      home: AddProduct(),//应用一启动就显示“产品注册页面”
    );
  }
}

///四、AddProduct（产品注册页面）
class AddProduct extends StatefulWidget {//为什么是 StatefulWidget？有 输入框|有 文本控制器|有 Firestore 操作|状态会变化（输入 → 清空）
  const AddProduct({super.key});


  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  ///五、状态变量（页面持有的数据）
  final FirebaseFirestore fs=FirebaseFirestore.instance;

  ///TextEditingController（四个输入框）
  final TextEditingController _pName = TextEditingController(); // 이름 입력 컨트롤러
  final TextEditingController _price = TextEditingController(); // 나이 입력 컨트롤러
  final TextEditingController _category = TextEditingController(); // 나이 입력 컨트롤러
  final TextEditingController _info = TextEditingController(); // 나이 입력 컨트롤러

  ///六、_productList() —— 一次性读取数据
  void _productList() async {

    FirebaseFirestore fs = FirebaseFirestore.instance;
    //.collection("product") 👉 product 表
    final snapshot = await fs.collection("product").get();
    //snapshot.docs
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();
      print("제품명: ${data["pName"]}, 가격: ${data["price"]}");
    }
  }

  ///七、_addUser()（⚠️ 这段现在是“废的”）
  // void _addUser() async {
  //   if (_pName.text.isNotEmpty && _price.text.isNotEmpty&& _category.text.isNotEmpty&& _info.text.isNotEmpty) { // 입력 필드가 비어있지 않은지 확인
  //     CollectionReference users = fs.collection("product"); // "users" 컬렉션 참조
  //
  //     await users.add({
  //       '_pName': _pName.text, // 이름 저장
  //       '_price': int.parse(_price.text), // 나이를 정수로 변환하여 저장
  //       '_category':_category.text,
  //       '_info':_info.text
  //
  //     });
  //
  //     _pName.clear(); // 입력 필드 초기화
  //     _price.clear();
  //     _category.clear();
  //     _info.clear();
  //
  //   } else {
  //     print("상품명 또는 가격 입력"); // 입력값이 없을 경우 메시지 출력
  //   }
  // }
  // Firestore에서 특정 사용자의 데이터를 업데이트하는 함수


  ///八、_insertProduct()（真正用的插入函数）
  void _insertProduct() async {
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference products = fs.collection("product");

    // 添加新产品
    //向 product 集合新增一条文档
    //每个 key 就是 Firestore 里的字段名
    //createdAt 用的是服务器时间（推荐写法）
    await products.add({
      'pName': _pName.text,
      'price': _price.text,
      'category': _category.text,
      'info': _info.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('Product inserted successfully');
  }


  // Firestore에서 사용자 목록을 스트림으로 가져와 화면에 표시하는 함수
  Widget _listUser() {
    ///九、_listUser()（实时监听 Firestore）
    return StreamBuilder(
    // .snapshots() 是实时监听
        stream: FirebaseFirestore.instance.collection("product").snapshots(), // 사용자 목록 스트림
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          // 아직 데이터가 로드되지 않았을 경우 빈 리스트 반환
          if (!snap.hasData) {
            return CircularProgressIndicator(); // 로딩 상태 표시
          }

          // 사용자 목록 데이터로 리스트 뷰 생성
          return ListView(
            children: snap.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['_pname']), // 이름 표시
                subtitle: Text('가격: ${doc['price']}'),
              );
            }).toList(),
          );
        });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 등록'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              bool flg=await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductList ())
              );
              if(flg){
                _productList();
              }
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue[300],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 이미지 등록 영역
            Card(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '제품 이미지를 등록해주세요',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            /// 제품 정보 카드
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '제품 정보',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _pName,
                      decoration: InputDecoration(
                        labelText: '제품명',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _category,
                      decoration: InputDecoration(
                        labelText: '카테고리',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '가격',
                        prefixText: '₩ ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            /// 상세 설명 카드
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(

                      '상세 설명',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _info,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '제품에 대한 설명을 입력해주세요',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            /// 등록 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _insertProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '제품 등록하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}