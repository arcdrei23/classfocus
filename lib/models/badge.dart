class Badge {
  final String id;
  final String name;
  final String icon;
  final String description;
  final int requiredXP;
  final int requiredStreak;
  bool unlocked;

  Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.requiredXP,
    required this.requiredStreak,
    this.unlocked = false,
  });
}
