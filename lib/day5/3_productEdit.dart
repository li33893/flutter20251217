// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import '../firebase_options.dart';
//
// class ProductEdit extends StatefulWidget {
//   final int? id;
//   const ProductEdit({super.key, this.id});
//
//   @override
//   State<ProductEdit> createState() => _ProductEdit();
// }
//
// class _ProductEdit extends State<ProductEdit> {
//   final FirebaseFirestore fs=FirebaseFirestore.instance;
//   final TextEditingController _pName = TextEditingController(); // 이름 입력 컨트롤러
//   final TextEditingController _price = TextEditingController(); // 나이 입력 컨트롤러
//   final TextEditingController _category = TextEditingController(); // 나이 입력 컨트롤러
//   final TextEditingController _info = TextEditingController(); // 나이 입력 컨트롤러
//
//
//   void _updateProduct() async {
//     FirebaseFirestore fs = FirebaseFirestore.instance;
//
//     await fs.collection("product").doc(id).update({
//       'pName': _pName.text,
//       'price': int.tryParse(_price.text) ?? 0, // 如果解析失败返回0
//       'category': _category.text,
//     });
//
//     Navigator.pop(context, true); // 返回 true 表示更新成功
//   }
//
//
//   Future<void> _updateproduct(int id, String title, String content) async {
//     await DB.updateMemo(id, title, content);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.id != null) {
//       _selectMemo(widget.id!);
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFFF8BBD0),
//               Color(0xFFBBDEFB),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Container(
//             width: 340,
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.95),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// 헤더
//                 Row(
//                   children: [
//                     Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Icon(
//                         Icons.edit_note,
//                         color: Colors.blue,
//                         size: 26,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       '메모 수정',  // ✅ 改成"修改"
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 28),
//
//                 /// 제목
//                 Text(
//                   '제목',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 TextField(
//                   controller: titleCtrl,
//                   decoration: InputDecoration(
//                     hintText: '제목을 입력하세요',
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 20),
//
//                 /// 내용
//                 Text(
//                   '내용',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 TextField(
//                   controller: contentCtrl,
//                   maxLines: 6,
//                   decoration: InputDecoration(
//                     hintText: '내용을 입력하세요',
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     contentPadding: EdgeInsets.all(16),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 28),
//
//                 /// 저장 버튼
//                 GestureDetector(
//                   onTap: () async {
//                     if (widget.id == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('메모 ID가 없습니다')),
//                       );
//                       return;
//                     }
//
//                     String title = titleCtrl.text;
//                     String content = contentCtrl.text;
//
//                     if (title.isEmpty || content.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('제목과 내용을 입력하세요')),
//                       );
//                       return;
//                     }
//
//                     // ✅ 参数顺序正确：id, title, content
//                     await _updateMemo(widget.id!, title, content);
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('메모가 수정되었습니다')),
//                     );
//
//                     Navigator.pop(context, true);
//                   },
//                   child: Container(
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '수정하기',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }