import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class MyTuitionPosts extends StatefulWidget {
  const MyTuitionPosts({super.key});

  @override
  State<MyTuitionPosts> createState() => _MyTuitionPostsState();
}

class _MyTuitionPostsState extends State<MyTuitionPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Tuition Posts',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Section
                const Text(
                  'Overview',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Total Posts Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  color: AppColors.accent,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Total Posts',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '5',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Hired Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Hired',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '2',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Posts List
                const Text(
                  'Posts',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Active Post - Physics
                _buildPostCard(
                  status: 'Active',
                  statusColor: AppColors.accent,
                  title: 'Need a physic teacher for primary school',
                  subject: 'Physic',
                  days: 'W, T, Th',
                  startTime:'7.00 PM',
                  endTime: '8,00 PM',
                  rate: '25',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                // Pending Post - Mathematics
                _buildPostCard(
                  status: 'Closed • Hired',
                  statusColor:  const Color(0xFF6C757D),
                  title: 'Need a Math teacher for primary school',
                  subject: 'Mathetics',
                  days: 'T, Th, F',
                  startTime:'7.00 PM',
                  endTime: '8,00 PM',
                  rate: '20',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                // Closed/Hired Post - Chemistry
                _buildPostCard(
                  status: 'Closed • Hired',
                  statusColor: const Color(0xFF6C757D),
                  title: 'Need a Chemistry teacher',
                  subject: 'Chemistry',
                  days: 'F, S, Su',
                  startTime:'7.00 PM',
                  endTime: '8,00 PM',
                  rate: '',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {},
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildPostCard({
    required String status,
    required Color statusColor,
    required String title,
    required String subject,
    required String days,
    required String rate,
    required String startTime,
    required String endTime,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: Status Badge and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge (Active/Inactive)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Price Tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text('৳ ', style: TextStyle(color: AppColors.accent, fontSize: 16)),
                  Text(
                    rate,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(' / mth', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // TITLE
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: AppColors.border, thickness: 1),
          const SizedBox(height: 8),

          // DETAILS: Location and Preferred Days
          // Subject Row
          Row(
            children: [
              const Icon(Icons.book_rounded, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(
                subject,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Preferred Days (Using 'grade' parameter as requested)
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(
                days, // Use this for preferred days (e.g., S, Su, M)
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Preferred Days (Using 'grade' parameter as requested)
          Row(
            children: [
              const Icon(Icons.watch_later, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(
                "$startTime - $endTime", // Use this for preferred days (e.g., S, Su, M)
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ACTION BUTTONS
          PrimaryButton(
              text: "View Applicants",
              onPressed: (){
                onPressed;
              },
          )
        ],
      ),
    );
  }
}