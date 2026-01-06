import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_dropdown.dart';
import 'package:_6th_sem_project/core/widgets/custom_progress_bar.dart';
import 'package:_6th_sem_project/core/widgets/custom_text_field.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/core/widgets/selected_group.dart';
import 'package:_6th_sem_project/features/student/controller/post_tuition_controller.dart';
import 'package:flutter/material.dart';

class PostTuitionScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const PostTuitionScreen({super.key, this.initialData});

  @override
  State<PostTuitionScreen> createState() => _PostTuitionScreenState();
}

class _PostTuitionScreenState extends State<PostTuitionScreen> {
  late PostTuitionController _con;
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    _con = PostTuitionController();
    isEditing = widget.initialData != null;
    if (isEditing) {
      _populateFields();
    }
    _con.loadSubjects(() => setState(() {})); // Fetch data on start
  }

  void _populateFields() {
    final data = widget.initialData!;
    _con.titleController.text = data['post_title'] ?? '';
    _con.locationController.text = data['student_location'] ?? '';
    _con.budgetController.text = data['salary'] ?? '';
    _con.detailsController.text = data['description'] ?? '';
    _con.selectedGradeLevel = data['grade'];

    // Pre-select the subject name for the dropdown
    if (data['subjects'] != null) {
      _con.subjectController.text = data['subjects']['name'];
    }

    // Handle days list
    if (data['preferred_day'] != null) {
      // Assuming it's a comma-separated string like "M, T, W"
      _con.mySelectedDays = (data['preferred_day'] as String).split(', ');
    }
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _goToNext() {
    final error = _con.validateForm();
    if (error != null) {
      _showError(error);
    } else {
      setState(() => _con.currentStep++);
    }
  }

  String _formateDay(List<String> days) {
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
        title: Text(
          isEditing ? "Update Tuition" : "Post Tuition",
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (_con.currentStep > 1) {
              setState(() => _con.currentStep--);
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
                  currentStep: _con.currentStep,
                  totalSteps: _con.totalSteps,
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.inputBackground),
                const SizedBox(height: 12),

                // Logic to switch between Form and Preview
                _con.currentStep == 1
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
        Text(
          isEditing
              ? "Need to change something?"
              : "What do you need help with?",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        // Sub header text
        Text(
          isEditing
              ? "Update your tuition details to keep them accurate."
              : "Fill the details below so that we can match you with the perfect tutor",
          style: TextStyle(color: AppColors.white60, fontSize: 14),
        ),
        const SizedBox(height: 30),

        // Post title
        CustomInputField(
          controller: _con.titleController,
          label: "Title",
          hint: 'Enter your post title',
          icon: Icons.title,
        ),

        const SizedBox(height: 20),

        // Subject -> selected Group
        _con.isLoadingSubjects
            ? CircularProgressIndicator(color: AppColors.accent)
            : CustomDropdown(
                label: "Subject",
                icon: Icons.import_contacts,
                items: _con.subjects.map((s) => s['name'].toString()).toList(),
                onChange: (value) {
                  _con.handleSubjectSelection(value, () => setState(() {}));
                },
              ),

        const SizedBox(height: 20),

        // Grade -> selected Group
        SelectedGroup(
          label: "Grade",
          options: ["High School", "University", "Primary", "Other"],
          selectedOptions: _con.selectedGradeLevel != null
              ? [_con.selectedGradeLevel!]
              : [],
          isMultiple: false,
          onSelected: (value) => setState(() {
            _con.selectedGradeLevel = value;
          }),
        ),
        const SizedBox(height: 20),

        // Location -> Text Field
        CustomInputField(
          controller: _con.locationController,
          label: "Location",
          hint: 'Enter your area',
          icon: Icons.place,
        ),
        const SizedBox(height: 20),

        // Budget -> Text Field
        CustomInputField(
          controller: _con.budgetController,
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
          selectedOptions: _con.mySelectedDays,
          isMultiple: true,
          onSelected: (value) => {
            setState(() {
              if (_con.mySelectedDays.contains(value)) {
                _con.mySelectedDays.remove(value);
              } else {
                _con.mySelectedDays.add(value);
              }
            }),
          },
        ),
        const SizedBox(height: 20),

        // prefer time ->_buildTimePicker Method
        Row(
          children: [
            Expanded(
              child: _buildTimePicker("Start Time", _con.startTime, (picked) {
                setState(() => _con.startTime = picked);
              }),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTimePicker("End Time", _con.endTime, (picked) {
                setState(() => _con.endTime = picked);
              }),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // additional details -> Text Field
        CustomTextField(
          controller: _con.detailsController,
          label: "Additional Details",
          hintText: "Tell us about your goals...",
        ),
        const SizedBox(height: 20),

        PrimaryButton(
          text: "Review Request",
          icon: Icons.arrow_right_alt,
          onPressed: () => {_goToNext()},
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

        // Title, subject and Grade
        _postReviewCart("Title, Subject & Grade", Icons.school_rounded, {
          "Title": _con.titleController.text,
          "Subject": _con.subjectController.text,
          "Grade": _con.selectedGradeLevel ?? "N/A",
        }),
        const SizedBox(height: 30),

        // Location Budget days time
        _postReviewCart("Logistic", Icons.access_time_filled, {
          "Budget": "${_con.budgetController.text} /month",
          "Days": _formateDay(_con.mySelectedDays),
          "Time":
              "${_con.startTime.format(context)} - ${_con.endTime.format(context)}",
        }),
        const SizedBox(height: 30),

        _con.detailsController.text.isNotEmpty
            ? _postReviewCart("Additional details", Icons.description, {
                "Details": _con.detailsController.text,
              })
            : const SizedBox(),
        const SizedBox(height: 20),

        Center(
          child: TextButton.icon(
            onPressed: () => setState(() => _con.currentStep = 1),
            icon: const Icon(
              Icons.edit_note,
              color: AppColors.accent,
              size: 20,
            ),
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
          text: isEditing ? "Confirm Update" : "Confirm & Post",
          icon: isEditing ? Icons.update : Icons.check_circle_rounded,
          isLoading: _con.isLoadingPost,
          onPressed: _con.isLoadingPost ? null : _handleFinalSubmission,
        ),
      ],
    );
  }

  // ---------- custom widget method--------------
  Future<void> _handleFinalSubmission() async {
    // 2. Logic to handle Update vs Create in Controller
    bool success;
    if (isEditing) {
      success = await _con.updateTuition(
        widget.initialData!['id'].toString(),
        () => setState(() {}),
      );
    } else {
      success = await _con.postTuition(() => setState(() {}));
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? "Tuition Updated Successfully"
                : "Post Tuition Successfully",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
    _showError("Operation failed. Please try again.");
    }

  }

  // Post review Cart method
  Widget _postReviewCart(
    String title,
    IconData icons,
    Map<String, String> details,
  ) {
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
              Icon(icons, size: 24, color: AppColors.white60),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.inputBackground),
          const SizedBox(height: 10),

          ...details.entries.map((entry) {
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
                    entry.key, //e.g. subject, Budget
                    style: const TextStyle(
                      color: AppColors.white60,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry
                          .value, //e.g subject, budget etc value -> Accounting, Biology
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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
