import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_dropdown.dart';
import 'package:_6th_sem_project/core/widgets/custom_progress_bar.dart';
import 'package:_6th_sem_project/core/widgets/custom_text_field.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/core/widgets/selected_group.dart';
import 'package:flutter/material.dart';

class PostTuitionScreen extends StatefulWidget {
  const PostTuitionScreen({super.key});

  @override
  State<PostTuitionScreen> createState() => _PostTuitionScreenState();
}

class _PostTuitionScreenState extends State<PostTuitionScreen> {
  String? selectedGradeLevel;
  String? category;
  int currentStep = 1;
  final int totalSteps = 2;
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 21, minute: 0);
  List<String> mySelectedDays = [];

  // Controllers to capture user input
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  //function for next step ->button
  void goToNextStep() {
    // validated if all field are filled or not
    if (subjectController.text.isEmpty ||
        selectedGradeLevel == null ||
        mySelectedDays.isEmpty ||
        locationController.text.isEmpty ||
        budgetController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    }
    // cheek if currentStep is not smaller than totalSteps
    if (currentStep < totalSteps) {
      setState(() => currentStep++);
    }
  }


  // function for get the grade level value -> text field
  void gradeLevelSelectedValues(String value) {
    setState(() {
      selectedGradeLevel = (selectedGradeLevel == value) ? null : value;
    });
  }

  // function for get the days value -> text field
  void daysSelectedValues(String value) {
    setState(() {
      if (mySelectedDays.contains(value)) {
        mySelectedDays.remove(value);
      } else {
        mySelectedDays.add(value);
      }
    });
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    subjectController.dispose();
    locationController.dispose();
    budgetController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
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
          onPressed: () {
            if (currentStep > 1) {
              setState(() => currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
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
                //custom progress bar
                CustomProgressBar(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.inputBackground),
                const SizedBox(height: 12),

                // Logic to switch between Form and Preview
                currentStep == 1
                    ? _buildInformationMethod()
                    : _buildPreviewMethod(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header Text
        const Text(
          "What do you need help with?",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        // sub header text
        const Text(
          "Fill the details below so that we can match you with perfect tutor",
          style: TextStyle(color: AppColors.white60, fontSize: 14),
        ),
        const SizedBox(height: 30),

        // Subject -> Text Field
        CustomInputField(
          controller: subjectController,
          label: "Subject",
          hint: 'Select Subject',
          icon: Icons.subject,
        ),
        const SizedBox(height: 20),

        // Broad Category -> selected Group
        CustomDropdown(
          label: "Broad Category",
          items: const [
            "Computer Science",
            "Physics",
            "Mathematics",
            "Chemistry",
            "Business",
          ],
          onChange: (value) {
            category = value;
          },
        ),
        const SizedBox(height: 20),

        // Grade -> selected Group
        SelectedGroup(
          label: "Grade",
          options: ["High School", "University", "Primary", "Other"],
          selectedOptions: selectedGradeLevel != null
              ? [selectedGradeLevel!]
              : [],
          isMultiple: false,
          onSelected: gradeLevelSelectedValues,
        ),
        const SizedBox(height: 20),

        // Location -> Text Field
        CustomInputField(
          controller: locationController,
          label: "Location",
          hint: 'Enter your area',
          icon: Icons.place,
        ),
        const SizedBox(height: 20),

        // Budget -> Text Field
        CustomInputField(
          controller: budgetController,
          label: "Monthly rate budget",
          hint: 'e.g 7000',
          icon: Icons.payments,
        ),
        const SizedBox(height: 20),

        // Days -> selected Group
        SelectedGroup(
          label: "Preferred Days",
          options: ["M", "T", "W", "Th", "F", "S", "Su"],
          selectedOptions: mySelectedDays,
          isMultiple: true,
          onSelected: daysSelectedValues,
        ),
        const SizedBox(height: 20),

        // prefer time ->_buildTimePicker Method
        Row(
          children: [
            Expanded(
              child: _buildTimePicker("Start Time", startTime, (picked) {
                setState(() => startTime = picked);
              }),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTimePicker("End Time", endTime, (picked) {
                setState(() => endTime = picked);
              }),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // additional details -> Text Field
        CustomTextField(
          controller: detailsController,
          label: "Additional Details",
          hintText: "Tell us about your goals...",
        ),
        const SizedBox(height: 20),

        PrimaryButton(
          text: "Review Request",
          icon: Icons.arrow_right_alt,
          onPressed: goToNextStep,
        ),
      ],
    );
  }

  // Step 2 : preview method
  Widget _buildPreviewMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Review Your Post",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Confirm your details before posting",
          style: TextStyle(color: AppColors.white60, fontSize: 14),
        ),
        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Now reading from controllers
              _buildPreviewRow("Subject", subjectController.text),
              _buildPreviewRow("Grade", selectedGradeLevel ?? "Not Selected"),
              _buildPreviewRow(
                "Days",
                mySelectedDays.isEmpty ? "None" : mySelectedDays.join(", "),
              ),
              _buildPreviewRow("Location", locationController.text),
              _buildPreviewRow("Budget", "${budgetController.text} /month"),
            ],
          ),
        ),
        const SizedBox(height: 30),

        PrimaryButton(
          text: "Confirm & Post",
          icon: Icons.check,
          onPressed: () {
            // Logic for API call
          },
        ),

        Center(
          child: TextButton(
            onPressed: () => setState(() => currentStep = 1),
            child: const Text(
              "Edit Details",
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Expanded(
            child: Text(
              value.isEmpty ? "Not provided" : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Time builder Picker method
  Widget _buildTimePicker(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onPick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            TimeOfDay? picker = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picker != null) onPick(picker);
          },
          child: Container(
            padding: const EdgeInsetsGeometry.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppColors.white60,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  time.format(context),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
