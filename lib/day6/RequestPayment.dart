import 'package:flutter/material.dart';
import 'Payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async  {
  //dotenev相关
  await dotenv.load(fileName:'.env');
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:ReqPayment(

        )
    );
  }
}

class ReqPayment extends StatefulWidget {
  const ReqPayment({super.key});

  @override
  State<ReqPayment> createState() => _ReqPayment();
}

class _ReqPayment extends State<ReqPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Payment()),  // 👈 跳转到支付页面
                  );
                },
                child: Text("결제하기")
            )
          ],
        )
      )
    );
  }
}
