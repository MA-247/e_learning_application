import 'package:e_learning_application/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/screens/topic_detail.dart';
import 'package:e_learning_application/screens/learning_section.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Topic topic;

  const CustomListTile({Key? key, required this.title, required this.subtitle, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1), // Adjust the opacity and color as needed
        borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius for rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional: Adjust margins
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TopicDetail(topic: topic))
          );
        },
      ),
    );
  }
}