import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:_6th_sem_project/features/student/screen/tuition_details.dart';
import 'package:_6th_sem_project/features/tutor/controller/tutor_data_controller.dart';
import 'package:flutter/material.dart';
import 'apply_tuition.dart';

class TuitionCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final bool profileComplete;
  final String timeAgo;

  const TuitionCard({
    super.key,
    required this.post,
    required this.profileComplete,
    required this.timeAgo,
  });

  @override
  State<TuitionCard> createState() => _TuitionCardState();
}

class _TuitionCardState extends State<TuitionCard> {
  final _con = TutorDataController();

  @override
  void initState() {
    super.initState();
    if(_con.savedPostIds.isEmpty){
      _con.syncSavedPosts();
    }
  }

  void _handleApply() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyForTuitionScreen(postId: widget.post['id']),
      ),
    );
    if (result == true) {
      setState(() {
        _con.appliedPostIds.add(widget.post['id'].toString());
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final String postId = post['id'].toString();
    final bool alreadyApplied = _con.appliedPostIds.contains(postId);

    debugPrint('PostId: $postId, postIdTitle: ${post['post_title']}');
    debugPrint('AppliedPostIds: ${_con.appliedPostIds}');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TuitionDetails(tuitionId: post['id'].toString()),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Saved button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      post['post_title'],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildSaveButton(post),
                ],
              ),
              const SizedBox(height: 12),
              // Subject and Level
              Row(
                children: [
                  _buildInfoChip(Icons.book, post['subjects']['name']),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.school, post['grade']),
                ],
              ),
              const SizedBox(height: 12),
              // Location and Applied count
              _buildLocationAndMeta(),
              const SizedBox(height: 16),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 12),
              // Price and Apply Action
              _buildFooterAction( widget.profileComplete, alreadyApplied ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods to keep build() clean ---

  Widget _buildSaveButton( Map post) {
    return GestureDetector(
      onTap: _con.isSave
          ? null
          : () async {
        final String? result = await _con.toggleSave(
          post['id'].toString(),
              () => setState(() {}),
        );
        if (!mounted) return;
        if (result == null) {
          _showSnack("Connection error. Try again.");
          return;
        }
        _showSnack(result);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.inputBackground,
        ),
        child: Center(
          child: Icon(
            _con.savedPostIds.contains(post['id'].toString())
                ? Icons.bookmark
                : Icons.bookmark_outline,
            color: AppColors.accent,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationAndMeta() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
        const SizedBox(width: 4),
        Text(
          widget.post['student_location'],
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        const Spacer(),
        const Icon(Icons.people_outline, color: AppColors.textMuted, size: 15),
        const SizedBox(width: 4),
        const Text("400 applied", style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        const Text(" • ", style: TextStyle(color: AppColors.textMuted)),
        Text(widget.timeAgo, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
      ],
    );
  }

  Widget _buildFooterAction(bool profileComplete, bool alreadyApplied) {
    bool canApply = widget.profileComplete && !alreadyApplied;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${widget.post['salary']}',
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: canApply ? _handleApply : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canApply ? AppColors.accent : Colors.grey[800],
            disabledBackgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            alreadyApplied ? 'Applied' : 'Apply' ,
            style: TextStyle(
              color: canApply ? AppColors.black : Colors.white38,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.inputBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppColors.white, fontSize: 12)),
        ],
      ),
    );
  }
}