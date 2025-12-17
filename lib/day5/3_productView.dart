import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../day6/Payment.dart';

class ProductView extends StatefulWidget {
  final String docId ;
  const ProductView({super.key, required this.docId});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  Map<String, dynamic> product = {};

  Future<void> getProduct() async {
    final snap = await fs.collection("product").doc(widget.docId).get();
    if(snap.exists){
      setState(() {
        product = snap.data()!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("제품명 : ${product["pName"]}"),
            Text("가격 : ${product["price"]}"),
            ElevatedButton(
                onPressed: () async {
                  bool flg=await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Payment (
                        pName: product["pName"] ,
                        price: int.tryParse(product["price"].toString()) ?? 0 ,
                      )
                    )
                  );

                  if(flg){
                    _ProductViewState;
                    print("결제 성공!");
                    getProduct();  // 重新加载产品数据

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('결제가 완료되었습니다!')),
                    );
                  }
                },
                child: Text("구매하기"))

          ],
        ),
      ),
    );
  }
}