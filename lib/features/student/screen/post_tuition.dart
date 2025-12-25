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
  // --- 1. State Variables ---
  String? selectedGradeLevel;
  int currentStep = 1;
  final int totalSteps = 2;

  TimeOfDay startTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 0);
  List<String> mySelectedDays = [];

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // --- 2. Lifecycle Methods ---
  @override
  void dispose() {
    subjectController.dispose();
    locationController.dispose();
    budgetController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  // --- 3. Business Logic & Validation ---
  void goToNextStep() {
    if (_validateForm() && currentStep < totalSteps) {
      setState(() => currentStep++);
    }
  }

  bool _validateForm() {
    // Basic field check
    if (subjectController.text.trim().isEmpty ||
        selectedGradeLevel == null ||
        mySelectedDays.isEmpty ||
        locationController.text.trim().isEmpty ||
        budgetController.text.trim().isEmpty) {
      _showError("Please fill in all details");
      return false;
    }

    // budget cheek
    if(!RegExp(r'^\d+$').hasMatch(budgetController.text)){
      _showError("Budget must be a number");
      return false;
    }
    if(int.parse(budgetController.text) < 0 || int.parse(budgetController.text) <= 1000){
      _showError("Minimum budget is 2000 and also budget can't be negative");
      return false;
    }

    // At lest two class in a week
    if( mySelectedDays.length < 3){
      _showError("At least three days are required");
      return false;
    }

    // Time logic check
    double start = startTime.hour + startTime.minute / 60.0;
    double end = endTime.hour + endTime.minute / 60.0;
    if (start >= end) {
      _showError("End time must be after start time");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- 4. State Update Handlers --
  void gradeLevelSelectedValues(String value) {
    setState(() {
      selectedGradeLevel = (selectedGradeLevel == value) ? null : value;
    });
  }

  void daysSelectedValues(String value) {
    setState(() {
      mySelectedDays.contains(value)
          ? mySelectedDays.remove(value)
          : mySelectedDays.add(value);
    });
  }

  // --- Extra. formate the days for preview card->days -----
  String formateDays(List<String> days){
    if (days.length == 7) return "Daily (Mon-Sun)";
    return days.join(", ");
  }

// --- 5. Main Build Method ---
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
                //Custom progress bar
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


  // Step 1:  data collect or form section method
  Widget _buildInformationMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Text
        const Text(
          "What do you need help with?",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        // Sub header text
        const Text(
          "Fill the details below so that we can match you with perfect tutor",
          style: TextStyle(color: AppColors.white60, fontSize: 14),
        ),
        const SizedBox(height: 30),

        // Subject -> selected Group
        CustomDropdown(
          label: "Subject",
          items: const [
            "Computer Science",
            "Physics",
            "Mathematics",
            "Chemistry",
            "Business",
          ],
          onChange: (value) {
            subjectController.text = value;
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
          keyboardType: TextInputType.number,
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
          "Please review the details below to ensure everything is correct before posting",
          style: TextStyle(color: AppColors.white60, fontSize: 14),
        ),
        const SizedBox(height: 30),

        // Subject and Grade
        _postReviewCart(
          "Subject & Grade",
          Icons.school_rounded,
          {
            "Subject": subjectController.text,
            "Grade": selectedGradeLevel ?? "N/A",
          },
        ),
        const SizedBox(height: 30),

        // Location Budget days time
        _postReviewCart(
          "Logistic",
          Icons.access_time_filled,
            {
              "Budget": "${budgetController.text} /month",
              // Use .join to turn the array into a comma-separated string
              "Days": formateDays(mySelectedDays),
              "Time": "${startTime.format(context)} - ${endTime.format(context)}",
            },
        ),
        const SizedBox(height: 30),

        !detailsController.text.isEmpty?
            _postReviewCart(
            "Additional details",
            Icons.description,
            {
              "Details": detailsController.text,
            }
            ): const SizedBox(),
        const SizedBox(height: 20),

        Center(
          child: TextButton.icon(
            onPressed: () => setState(() => currentStep = 1),
            icon: const Icon(Icons.edit_note, color: AppColors.accent, size: 20),
            label: const Text(
              "Edit Details",
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        PrimaryButton(
          text: "Confirm & Post",
          icon: Icons.check_circle_rounded,
          onPressed: () {
            // Logic for API call
          },
        ),
      ],
    );
  }


  // ---------- custom method--------------
  // Post review Cart method
  Widget _postReviewCart(String title,IconData icons, Map<String, String> details) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            // header text
            children: [
              Icon(icons, size: 24, color: AppColors.white60,),
              const SizedBox(width: 10,),
              Text(title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 8,),
          const Divider(color: AppColors.inputBackground,),
          const SizedBox(height: 10,),

          ...details.entries.map((entry){
            if (entry.key == "Details") {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '" ${entry.value} "', // Wraps the value in double quotes
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: AppColors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic, // Makes the text italic
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: AppColors.white60,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ]
              ),
            );
          })
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
