import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {

  final String label;
  final List<String> items;
  final ValueChanged<String> onChange;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
   required this.onChange,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;
  @override
  void initState(){
    super.initState();
    if (widget.items.isNotEmpty) {
      selectedValue = widget.items[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the dropdown
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.items.contains(selectedValue)? selectedValue : null,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.white60,
              ),
              dropdownColor: AppColors.inputBackground,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
                widget.onChange(newValue!);
              },
              items: widget.items.map((String item)=> DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              )).toList()
            ),
          ),
        ),
      ],
    );
  }
}
