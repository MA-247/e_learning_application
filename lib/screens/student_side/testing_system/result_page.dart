import 'package:flutter/material.dart';
import 'package:e_learning_application/screens/student_side/student_home_page.dart';

class ResultPage extends StatelessWidget {
  final int score;

  ResultPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal.shade300, Colors.teal.shade900],
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Trophy or success icon
                Icon(
                  Icons.emoji_events_outlined,
                  size: 100,
                  color: Colors.amberAccent.shade400,
                ),
                SizedBox(height: 30),

                // Score Title
                Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Animated score display
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score),
                  duration: Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent.shade400,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black45,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 50),

                // Back to Home button
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    backgroundColor: Colors.amberAccent.shade400,
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
