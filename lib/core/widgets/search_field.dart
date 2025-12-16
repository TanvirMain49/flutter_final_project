import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final VoidCallback? onTap;

  const SearchField({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.white60),
            const SizedBox(width: 10),
            Text(
              "What subject do you need help with?",
              style: TextStyle(
                color: AppColors.white60,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
