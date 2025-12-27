import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SelectedGroup extends StatelessWidget {

  final List<String> options;
  final List<String> selectedOptions;
  final Function(String) onSelected;
  final String label;
  final bool isMultiple;

  const SelectedGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelected,
    required this.label,
    this.isMultiple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8,),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: options.map((option){
              final isSelected = selectedOptions.contains(option);
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: ()=> onSelected(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected? const Color(0xFF00FF7F) : AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF00FF7F) : Colors.white24,
                        width: 1,
                      )
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
