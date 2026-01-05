import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Custom_avatar.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/card_details_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/profile/screen/personal_information.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/profile/screen/user_profile.dart';
import 'package:_6th_sem_project/features/student/screen/view_applications.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:_6th_sem_project/features/tutor/screen/apply_tuition.dart';
import 'package:_6th_sem_project/utils/Student.utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TuitionDetails extends StatefulWidget {
  final String tuitionId;
  final bool? isProfileComplete;
  const TuitionDetails({
    super.key,
    required this.tuitionId,
    this.isProfileComplete,
  });

  @override
  State<TuitionDetails> createState() => _TuitionDetailsState();
}

class _TuitionDetailsState extends State<TuitionDetails> {
  final _controller = GetTuitionController();
  final _tutorCon = TutorDataController();
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _controller.getTuitionDetails(widget.tuitionId, () {
      if (mounted) setState(() {});
    });
    _controller.initRole();
    _tutorCon.cheekIfApplied(widget.tuitionId, () {
      if (mounted) setState(() {});
    });
  }

  void _handleMenuAction(String value, String postId) async {
    switch (value) {
      case 'share':
        // Trigger share logic
        break;
      case 'save':
        final String? result = await _tutorCon.toggleSave(
          postId,
          () => setState(() {}),
        );
        if (!mounted) return;
        if (result == null) {
          _showSnack("Connection error. Please try again.", isError: true);
        } else {
          _showSnack(result);
        }
        break;
      case 'edit':
        // Navigator.push to your Edit Screen
        break;
      case 'delete':
        _showDeleteDialog(postId);
        break;
      case 'report':
        // Show report dialog
        break;
    }
  }

  void _showDeleteDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          "Delete Post?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This action cannot be undone.",
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Add your delete logic here via controller
              // await _controller.deletePost(postId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : AppColors.inputBackground,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _controller.tuitionDetails;

    debugPrint("is profile complete Details: ${widget.isProfileComplete}");


    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          "Request Details",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.white),
        ),
        actions: [
          if (data != null) // Only show menu if data is loaded
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              color: AppColors.primaryDark,
              onSelected: (value) =>
                  _handleMenuAction(value, data['id'].toString()),
              itemBuilder: (BuildContext context) {
                // Compare current logged-in user ID with the Post's owner ID
                final String? currentUserId = _supabase.auth.currentUser?.id;
                final bool isOwner = data['users']?['id'] == currentUserId;

                return [
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(
                        Icons.share,
                        color: AppColors.white,
                        size: 20,
                      ),
                      title: Text(
                        'Share',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'save',
                    child: ListTile(
                      leading: Icon(
                        Icons.bookmark_outline,
                        color: AppColors.white,
                        size: 20,
                      ),
                      title: Text(
                        'Save',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),

                  // Conditional Owner Options
                  if (isOwner) ...[
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue, size: 20),
                        title: Text(
                          'Edit Post',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        title: Text(
                          'Delete Post',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],

                  if (!isOwner)
                    const PopupMenuItem(
                      value: 'report',
                      child: ListTile(
                        leading: Icon(
                          Icons.report_problem,
                          color: Colors.orange,
                          size: 20,
                        ),
                        title: Text(
                          'Report',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                ];
              },
            ),
        ],
      ),
      body: GradientBackground(
        child:
            _controller.isLoading ||
                data ==
                    null // Check if still loading or data is missing
            ? const CardDetailsSkeleton()
            : Builder(
                builder: (context) {
                  final timeAgo = StudentUtils.formatTimeAgo(
                    data['created_at'],
                  );
                  final startTime = StudentUtils.formatToBDTime(
                    data['start_time'],
                  );
                  final endTime = StudentUtils.formatToBDTime(data['end_time']);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Teacher Profile Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomAvatar(
                                    photoUrl: data['user']?['profile_photo'],
                                  ),

                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['users']?['full_name'] ??
                                              'Unknown',
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '4.9 • Reputation',
                                              style: TextStyle(
                                                color: AppColors.textMuted,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          timeAgo,
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Title Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['post_title'] ?? 'Tuition Request',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 2. Subject Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.accent.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  data['subjects']?['name']?.toUpperCase() ??
                                      'N/A',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              // const Divider(color: AppColors.accent,),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${data['salary']?.toString() ?? '0'} /hr',
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'ONLINE',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tags Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Grade',
                                  data['grade'] ?? 'N/A',
                                  Icons.school,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  'Duration',
                                  '$startTime - $endTime',
                                  Icons.book,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Frequency and Location Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Frequency',
                                  _formatDays(data['preferred_day']),
                                  Icons.calendar_today,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  'Location',
                                  data['student_location'] ?? 'N/A',
                                  Icons.location_on,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Description Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data['description'] ??
                                      'No description provided',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: data == null
          ? const SizedBox.shrink() // Show nothing while loading
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Builder(
                builder: (context) {
                  // Logic calculated safely after data is confirmed not null
                  final isOwner =
                      data['users']['id'] == _supabase.auth.currentUser?.id;
                  final userRole = _controller.role ?? 'Guess';
                  return _buildRoleBasedActions(
                    isOwner,
                    userRole,
                    widget.isProfileComplete ?? false,
                    _tutorCon.hasApplied,
                    data['id'],
                  );
                },
              ),
            ),
    );
  }

  // Bottom navigation button
  Widget _buildRoleBasedActions(
    bool isOwner,
    String userRole,
    bool isProfileComplete,
    bool hasApplied,
    postId,
  ) {
    // Logic to determine if current user owns the post
    debugPrint('userRole: $userRole');

    if (isOwner) {
      return PrimaryButton(
        text: "View Applications",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewApplicationScreen(postId: postId)),
          );
        },
      );
    }

    // Handle other roles
    switch (userRole.toLowerCase()) {
      case 'tutor':
        return Row(
          children: [
            Expanded(flex: 2, child: _messageButton()),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: PrimaryButton(
                text: hasApplied
                    ? "Applied"
                    : !isProfileComplete ? "Complete Profile" : "Apply Now",

                onPressed: hasApplied
                    ? null
                    : () {
                  if (!isProfileComplete) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonalProfileScreen()),
                    );
                    _showSnack("Please complete your profile to apply!");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyForTuitionScreen(postId: postId),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );

      case 'Guess':
      default:
        return SizedBox(width: double.infinity, child: _messageButton());
    }
  }

  // Reusable Message Button to keep the switch case clean
  Widget _messageButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
      label: const Text('Message'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: const BorderSide(color: AppColors.accent, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // card information builder
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // form the days
  String _formatDays(String? days) {
    if (days == null) return 'N/A';
    final dayList = days.split(',');
    final dayMap = {
      'M': 'Mon,',
      'T': 'Tue,',
      'W': 'Wed,',
      'R': 'Thu,',
      'F': 'Fri,',
      'S': 'Sat,',
      'U': 'Sun,',
    };
    return dayList.map((d) => dayMap[d.trim()] ?? d).join(' ');
  }
}
