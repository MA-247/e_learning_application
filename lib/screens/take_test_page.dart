import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TakeTestPage extends StatefulWidget {
  final QueryDocumentSnapshot testData;

  TakeTestPage({required this.testData});

  @override
  _TakeTestPageState createState() => _TakeTestPageState();
}

class _TakeTestPageState extends State<TakeTestPage> {
  final _formKey = GlobalKey<FormState>();
  Map<int, dynamic> _answers = {};

  void _submitAnswers() async {
    if (_formKey.currentState!.validate()) {
      // Store the student's answers to Firestore (optional)
      await FirebaseFirestore.instance.collection('test_results').add({
        'testId': widget.testData.id,
        'answers': _answers,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Test submitted successfully!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.testData['fields'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Take Test'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final field = fields[index];

              switch (field['type']) {
                case 'text':
                  return ListTile(
                    title: Text(field['content']),
                  );
                case 'image':
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(field['url']),
                  );
                case 'mcq':
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(field['question']),
                      ...List.generate(4, (optionIndex) {
                        final option = field['options'][optionIndex];
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _answers[index],
                          onChanged: (value) {
                            setState(() {
                              _answers[index] = value;
                            });
                          },
                        );
                      }),
                    ],
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAnswers,
        child: Icon(Icons.check),
        backgroundColor: Colors.blue[300],
      ),
    );
  }
}
