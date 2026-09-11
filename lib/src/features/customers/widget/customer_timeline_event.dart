class CustomerTimelineEvent {
  final String date;
  final String title;
  final String badgeText;
  final String? statusColor;

  const CustomerTimelineEvent({
    required this.date,
    required this.title,
    required this.badgeText,
    this.statusColor,
  });
}
