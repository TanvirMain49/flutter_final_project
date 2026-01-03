import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/custom_dropdown.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/input_field.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/core/widgets/selected_group.dart';
import 'package:_6th_sem_project/features/profile/controller/complete_profile_controller.dart';
import 'package:flutter/material.dart';

class CompleteTutorProfileScreen extends StatefulWidget {
  const CompleteTutorProfileScreen({super.key});

  @override
  State<CompleteTutorProfileScreen> createState() => _CompleteTutorProfileScreenState();
}

class _CompleteTutorProfileScreenState extends State<CompleteTutorProfileScreen> {
  // Senior Tip: The logic class handles all internal state and controllers
  final CompleteProfileController _controller = CompleteProfileController();

  @override
  void initState() {
    super.initState();
    _controller.fetchSubjects(() => ifMounted(() => setState(() {})));
  }

  @override
  void dispose() {
    // Centralized disposal to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  /// Helper to safely call setState only if the widget is still in the tree
  void ifMounted(VoidCallback fn) {
    if (mounted) fn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Tutor Profile'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Teaching Information'),
                const SizedBox(height: 20),

                _buildSubjectDropdown(),
                const SizedBox(height: 16),

                _buildFormFields(),
                const SizedBox(height: 16),

                _buildAvailabilitySelection(),
                const SizedBox(height: 40),

                // Senior Tip: Use a PrimaryButton that handles its own loading state
                PrimaryButton(
                  text: 'Save Profile',
                  isLoading: _controller.isSubmitting,
                  onPressed: () => _controller.handleSave(
                    context,
                        () => ifMounted(() => setState(() {})),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.white));
    }

    return CustomDropdown(
      label: 'Subject',
      items: _controller.subjects.map((s) => s['name'].toString()).toList(),
      icon: Icons.book_outlined,
      onChange: (value) => _controller.handleSubjectSelection(
        value,
            () => ifMounted(() => setState(() {})),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomInputField(
          label: 'Experienced At',
          hint: 'e.g. thermodynamics, linear algebra',
          icon: Icons.psychology_outlined,
          controller: _controller.experienceAtController,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Hourly Salary',
          hint: 'e.g., ৳500', // Bangladeshi Taka format
          icon: Icons.payments_outlined,
          controller: _controller.salaryController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Education At',
          hint: 'e.g., University of Dhaka',
          icon: Icons.school_outlined,
          controller: _controller.educationAtController,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Years of Experience',
          hint: 'e.g., 3',
          icon: Icons.history_toggle_off,
          controller: _controller.experienceYearController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildAvailabilitySelection() {
    return SelectedGroup(
      label: "Available Days",
      options: ["M", "T", "W", "Th", "F", "S", "Su"],
      selectedOptions: _controller.mySelectedDays,
      isMultiple: true,
      onSelected: (value) {
        setState(() {
          if (_controller.mySelectedDays.contains(value)) {
            _controller.mySelectedDays.remove(value);
          } else {
            _controller.mySelectedDays.add(value);
          }
        });
      },
    );
  }
}