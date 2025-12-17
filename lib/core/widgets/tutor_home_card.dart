import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class TutorHomeCard extends StatelessWidget{
  final String name;
  final String subject;
  final double price;
  final double rating;
  final String imageUrl;

  const TutorHomeCard({
    super.key,
    required this.name,
    required this.subject,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      width: 260,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark, // dark blue-gray Color(0xFF1F2937)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imageUrl), fit:BoxFit.cover),
              borderRadius: BorderRadius.circular(12)
            )
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$subject • \$${price.toStringAsFixed(0)}/hr',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),

                    SizedBox(width: 4),

                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          )

        ],
      )
    );
  }

}