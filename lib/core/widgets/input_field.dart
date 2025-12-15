import 'package:flutter/material.dart';
import '../constants/colors.dart';


class CustomInputField extends StatelessWidget{

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //label
        Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8,),
        
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12)
          ),

          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.white60,
              ),
              prefixIcon: Icon(
                  icon,
                  color: AppColors.white60,
              ),
              contentPadding:
                const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
    );
  }
}