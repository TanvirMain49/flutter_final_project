import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/core/widgets/Custom_avatar.dart';
import 'package:_6th_sem_project/core/widgets/Skeleton/card_details_skeleton.dart';
import 'package:_6th_sem_project/core/widgets/gradient_background.dart';
import 'package:_6th_sem_project/core/widgets/primary_button.dart';
import 'package:_6th_sem_project/features/profile/screen/personal_information.dart';
import 'package:_6th_sem_project/features/student/controller/get_tuition_controller.dart';
import 'package:_6th_sem_project/features/student/screen/post_tuition.dart';
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
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _controller.getTuitionDetails(widget.tuitionId, _safeSetState),
      _controller.initRole(),
      _tutorCon.isSavedTuitionPost(widget.tuitionId, _safeSetState),
      _tutorCon.cheekIfApplied(widget.tuitionId, _safeSetState),
    ]);
  }

  void _safeSetState() {
    if (mounted) setState(() {});
  }

  void _handleMenuAction(String value, Map<String, dynamic> tuition) async {
    switch (value) {
      case 'share':
        break;
      case 'save':
        final result = await _tutorCon.toggleSave(
          tuition['id'].toString(),
          () => setState(() {}),
        );
        if (!mounted) return;
        _showSnack(
          result ?? "Connection error. Please try again.",
          isError: result == null,
        );
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostTuitionScreen(initialData: tuition),
          ),
        ).then((_) => _loadAllData());
        break;
      case 'delete':
        _showDeleteDialog(tuition['id'].toString());
        break;
      case 'report':
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
              await _controller.deletePost(postId, _safeSetState);
              if (!mounted) return;
              _showSnack('Post deleted successfully');
              Navigator.pop(context);
              Navigator.pop(context);
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

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: _buildAppBar(data),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        child: GradientBackground(
          child: _controller.isLoading || data == null
              ? const CardDetailsSkeleton()
              : _buildContent(data),
        ),
      ),
      bottomNavigationBar: data == null
          ? const SizedBox.shrink()
          : _buildBottomBar(data),
    );
  }

  PreferredSizeWidget _buildAppBar(Map<String, dynamic>? data) {
    return AppBar(
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
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_outlined, color: AppColors.white),
      ),
      actions: [
        if (data != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            color: AppColors.primaryDark,
            onSelected: (value) => _handleMenuAction(value, data),
            itemBuilder: (_) => _buildMenuItems(data),
          ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(Map<String, dynamic> data) {
    final currentUserId = _supabase.auth.currentUser?.id;
    final isOwner = data['users']?['id'] == currentUserId;

    return [
      const PopupMenuItem(
        value: 'share',
        child: ListTile(
          leading: Icon(Icons.share, color: AppColors.white, size: 20),
          title: Text('Share', style: TextStyle(color: AppColors.white)),
        ),
      ),
      PopupMenuItem(
        value: 'save',
        child: ListTile(
          leading: _tutorCon.isSavedPost
              ? Icon(Icons.bookmark, color: AppColors.accent, size: 20)
              : Icon(Icons.bookmark_outline, color: AppColors.white, size: 20),
          title: Text(
            _tutorCon.isSavedPost ? 'Saved' : 'Save',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
      if (isOwner) ...[
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.white, size: 20),
            title: Text('Edit Post', style: TextStyle(color: Colors.white)),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red, size: 20),
            title: Text('Delete Post', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      if (!isOwner)
        const PopupMenuItem(
          value: 'report',
          child: ListTile(
            leading: Icon(Icons.report_problem, color: Colors.orange, size: 20),
            title: Text('Report', style: TextStyle(color: Colors.orange)),
          ),
        ),
    ];
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final timeAgo = StudentUtils.formatTimeAgo(data['created_at']);
    final startTime = StudentUtils.formatToBDTime(data['start_time']);
    final endTime = StudentUtils.formatToBDTime(data['end_time']);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTeacherHeader(data, timeAgo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildPostTitle(data),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoGrid(data, startTime, endTime),
          ),
          const SizedBox(height: 20),
          data['description'] == ""
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDescriptionSection(data['description']),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTeacherHeader(Map<String, dynamic> data, String timeAgo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(photoUrl: data['user']?['profile_photo']),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['users']?['full_name'] ?? 'Unknown',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostTitle(Map<String, dynamic> data) {
    return Column(
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            (data['subjects']?['name'] ?? 'N/A').toUpperCase(),
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '৳${data['salary']?.toString() ?? '0'} /hr',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    );
  }

  Widget _buildInfoGrid(
    Map<String, dynamic> data,
    String startTime,
    String endTime,
  ) {
    return Column(
      children: [
        Row(
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
        const SizedBox(height: 12),
        Row(
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
      ],
    );
  }

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
          const SizedBox(height: 8),
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

  Widget _buildDescriptionSection(String? description) {
    return Column(
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
            description ?? 'No description provided',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: _buildRoleBasedActions(
        data['users']['id'] == _supabase.auth.currentUser?.id,
        _controller.role ?? 'Guest',
        widget.isProfileComplete ?? false,
        _tutorCon.hasApplied,
        data['id'],
      ),
    );
  }

  Widget _buildRoleBasedActions(
    bool isOwner,
    String userRole,
    bool isProfileComplete,
    bool hasApplied,
    String postId,
  ) {
    if (isOwner) {
      return PrimaryButton(
        text: "View Applications",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewApplicationScreen(postId: postId),
            ),
          );
        },
      );
    }

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
                    : !isProfileComplete
                    ? "Complete Profile"
                    : "Apply Now",
                onPressed: hasApplied
                    ? null
                    : () {
                        if (!isProfileComplete) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PersonalProfileScreen(),
                            ),
                          );
                          _showSnack("Please complete your profile to apply!");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyForTuitionScreen(postId: postId),
                            ),
                          ).then((_) {
                            // Example: Refresh the saved status or post details
                            _loadAllData();
                          });
                        }
                      },
              ),
            ),
          ],
        );

      default:
        return SizedBox(width: double.infinity, child: _messageButton());
    }
  }

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

  String _formatDays(String? days) {
    if (days == null) return 'N/A';
    final dayMap = {
      'M': 'Mon,',
      'T': 'Tue,',
      'W': 'Wed,',
      'R': 'Thu,',
      'F': 'Fri,',
      'S': 'Sat,',
      'U': 'Sun,',
    };
    return days.split(',').map((d) => dayMap[d.trim()] ?? d).join(' ').trim();
  }
}
