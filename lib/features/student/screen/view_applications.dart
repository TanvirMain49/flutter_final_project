import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/application_card.dart';
import 'package:flutter/material.dart';

class ViewApplicationScreen extends StatefulWidget {
  final String postId;
  const ViewApplicationScreen({super.key, required this.postId});

  @override
  State<ViewApplicationScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ViewApplicationScreen> {
  final _con = GetTuitionController();
  @override
  void initState() {
    super.initState();
    _con.getAllAppliedPost(widget.postId, () {
      if (mounted) setState(() {});
    });
  }

  void _handleHire(Map<String, dynamic> application) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${application['name']} hired successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
  }

  void _handleReject(Map<String, dynamic> application) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${application['name']} rejected.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Tutor Applications', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        elevation: 2,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: AppColors.white,)),
      ),
      body: _con.applicationTuition.isEmpty
          ? Center(
        child: GradientBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'No applications',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: _con.applicationTuition.length,
        itemBuilder: (context, index) {
          return ApplicationCard(
            application: _con.applicationTuition[index],
            onHire: () => _handleHire(_con.applicationTuition[index]),
            onReject: () => _handleReject(_con.applicationTuition[index]),
          );
        },
      ),
    );
  }
}