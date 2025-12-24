import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.inputBackground,
          ),
          child: TextField(
            controller: controller,
            maxLines: 10,
            minLines: 6,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.white60),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
      ],
    );
  }
}