import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomHomeNavbar extends StatelessWidget {
  final String displayName;
  const CustomHomeNavbar({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //   header part
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.supervised_user_circle_rounded,
                    size: 33,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),

                /// User and welcome message
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning,",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      displayName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white60,
                    minimumSize: Size(35, 35),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                  child: Icon(Icons.notifications, color: Colors.white, size: 23),
                ),
              ],
            ),
          ],
        ),
      );
  }
}
