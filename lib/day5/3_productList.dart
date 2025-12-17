import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '3_productView.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {


  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 목록'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue[300],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: '목록',
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

      body: StreamBuilder(
          stream: fs.collection("product").snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return CircularProgressIndicator(); // 로딩 상태 표시
            }
            return ListView(
              children: snap.data!.docs.map((doc) {
                return GestureDetector(
                  onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProductView (docId: doc.id))
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(6),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  doc['pName'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit_outlined),
                                  onPressed: ()  {
                                    // bool flg=await Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) => ProductEdit (id: doc.id))
                                    // );
                                    // if(flg){
                                    //   _productEdit();
                                    // }
                                  },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  // print(doc.id);
                                  await fs.collection("product").doc(doc.id).delete();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.category_outlined, size: 18),
                              SizedBox(width: 6),
                              Text(
                                doc['category'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.payments_outlined, size: 18),
                              SizedBox(width: 6),
                              Text(
                                '₩ ${doc['price']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            doc['info'],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

            );
          }
      ),
    );
  }
}

