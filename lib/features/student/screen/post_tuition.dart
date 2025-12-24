import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_progress_bar.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/selected_group.dart';
import 'package:flutter/material.dart';

class PostTuitionScreen extends StatefulWidget {
  const PostTuitionScreen({super.key});

  @override
  State<PostTuitionScreen> createState() => _PostTuitionScreenState();
}

class _PostTuitionScreenState extends State<PostTuitionScreen> {

  String? selectedGradeLevel;
  List<String> selectedDays =[];

  int currentStep = 1;
  final int totalSteps = 2;

  void goToNextStep() {
    if (currentStep < totalSteps) {
      setState(() {
        currentStep++;
      });
    }
  }

  // function for selected Grade level
  void gradeLevelSelectedValues(String value){
    setState(() {
      selectedGradeLevel = (selectedGradeLevel == value)? null : value;

    });
  }

  // function for selected Grade level
  void daysSelectedValues(String value){
    setState(() {
      // if the value or the user touched ui value
      // if the value is present in the selectedDays list then it would be removed
      // and if the value is not present then add into the selectedDays list.
      if(selectedDays.contains(value)){
        selectedDays.remove(value);
      } else{
        selectedDays.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051205),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Post Tuition",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // custom progress bar
                CustomProgressBar(currentStep: currentStep, totalSteps: totalSteps),
                const SizedBox(height: 8,),
                const Divider(color: AppColors.primary),
                const SizedBox(height: 12,),

                // heading text
                Text(
                  "What do you need help with?",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6,),

                //sub heading text
                Text(
                  "Fill the details below so that we can match you with perfect tutor",
                  style: TextStyle(
                    color: AppColors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30,),

               // from information

              //   Subject -> text field
                CustomInputField(
                    label: "Subject",
                    hint: 'Select Subject',
                    icon: Icons.subject
                ),

              const SizedBox(height: 20,),

              //   Grade -> custom selected_Group
                SelectedGroup(
                  label: "Grade",
                  options: ["High School", "University", "Primary", "Other"],
                  selectedOptions: selectedGradeLevel != null? [selectedGradeLevel!] : [],
                  isMultiple: true,
                  onSelected: (value) {
                    gradeLevelSelectedValues(value);
                  },
                ),





              ],
            ),
          ),
        ),
      ),
    );
  }
}
