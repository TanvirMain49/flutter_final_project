import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class TuitionDetails extends StatelessWidget {
  final String tuitionId;
  const TuitionDetails({super.key, required this.tuitionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Text(
            tuitionId,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
