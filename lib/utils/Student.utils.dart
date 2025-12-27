class StudentUtils {
  // Made static so you can call it as StudentUtils.formatTimeAgo(...)
  static String formatTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Unknown time";

    try {
      final postDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(postDate);

      if (difference.inDays >= 30) {
        return "${(difference.inDays / 30).floor()}mo ago"; // Added months for older posts
      } else if (difference.inDays >= 7) {
        return "${(difference.inDays / 7).floor()}w ago";
      } else if (difference.inDays >= 1) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours >= 1) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      // If parsing fails (e.g. invalid format), return a fallback
      return "Recently";
    }
  }

  static String formatToBDTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "TBD";

    try {
      // Split "19:00:00" into ["19", "00", "00"]
      List<String> parts = timeStr.split(':');
      int hour = int.parse(parts[0]);
      String minute = parts[1];

      // Determine AM or PM
      String period = hour >= 12 ? "PM" : "AM";

      // Convert 24h to 12h
      int hour12 = hour % 12;
      if (hour12 == 0) hour12 = 12; // Handle Midnight (00) and Noon (12)

      // Return in BD standard format
      return "$hour12:$minute $period";
    } catch (e) {
      return timeStr; // Fallback to original if something fails
    }
  }
}