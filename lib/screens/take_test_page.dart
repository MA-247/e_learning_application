import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatefulWidget {
  final String testId;

  TestPage({required this.testId});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<List<dynamic>> _testData;

  @override
  void initState() {
    super.initState();
    _testData = _fetchTest();
  }

  Future<List<dynamic>> _fetchTest() async {
    final doc = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
    if (doc.exists) {
      return List.from(doc.data()!['fields'] ?? []);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("reached the test page");
    return Scaffold(
        appBar: AppBar(
        title: Text('Test Page'),
        backgroundColor: Colors.blue[300],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _testData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No test data available.'));
          } else {
            final fields = snapshot.data!;
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                // Build your field widget based on the field type
                return _buildField(field);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'text':
        return Text(field['content'] ?? '');
      case 'heading':
        return Text(
          field['content'] ?? '',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      case 'image':
        return Image.network(field['url']);
      case 'mcq':
        return _buildMCQField(field);
      default:
        return Container();
    }
  }

  Widget _buildMCQField(Map<String, dynamic> field) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(field['question'] ?? 'Question'),
        subtitle: Column(
          children: [
            ...List.generate(4, (index) {
              final optionKey = 'option${index + 1}';
              return RadioListTile(
                title: Text(field[optionKey] ?? 'Option ${index + 1}'),
                value: optionKey,
                groupValue: _answers[field['question']],
                onChanged: (value) {
                  setState(() {
                    _answers[field['question']] = value;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _answers = {};
}
