// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TestPage extends StatefulWidget {
//   final String testId;
//
//   TestPage({required this.testId});
//
//   @override
//   _TestPageState createState() => _TestPageState();
// }
//
// class _TestPageState extends State<TestPage> {
//   final Map<String, dynamic> _answers = {};
//
//   Future<Map<String, dynamic>> _fetchTest() async {
//     final doc = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
//     return doc.data()!['fields'];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take Test'),
//         backgroundColor: Colors.blue[300],
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _fetchTest(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final fields = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: fields.length,
//             itemBuilder: (context, index) {
//               final field = fields[index];
//
//               return field['type'] == 'mcq'
//                   ? _buildMCQField(field)
//                   : Container(); // Add other field types as needed
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle submission
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
//
//   Widget _buildMCQField(Map<String, dynamic> field) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: ListTile(
//         title: Text(field['question']),
//         subtitle: Column(
//           children: [
//             ...List.generate(4, (index) {
//               final optionKey = 'option${index + 1}';
//               return RadioListTile(
//                 title: Text(field[optionKey]),
//                 value: optionKey,
//                 groupValue: _answers[field['question']],
//                 onChanged: (value) {
//                   setState(() {
//                     _answers[field['question']] = value;
//                   });
//                 },
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
