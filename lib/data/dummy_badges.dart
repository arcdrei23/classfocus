import '../models/badge.dart';

List<Badge> dummyBadges = [
  Badge(
    id: "b1",
    name: "Rookie Scholar",
    icon: "assets/badges/rookie.png",
    description: "Earn 100 XP.",
    requiredXP: 100,
    requiredStreak: 0,
  ),
  Badge(
    id: "b2",
    name: "Streak Starter",
    icon: "assets/badges/streak.png",
    description: "Maintain a 5-day streak.",
    requiredXP: 0,
    requiredStreak: 5,
  ),
  Badge(
    id: "b3",
    name: "Top Scorer",
    icon: "assets/badges/trophy.png",
    description: "Score 95 or above on a quiz.",
    requiredXP: 300,
    requiredStreak: 0,
  ),
  Badge(
    id: "b4",
    name: "XP Master",
    icon: "assets/badges/star.png",
    description: "Reach 1000 XP total.",
    requiredXP: 1000,
    requiredStreak: 0,
  ),
];
