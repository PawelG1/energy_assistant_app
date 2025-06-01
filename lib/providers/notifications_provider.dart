import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      description: description,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super([]) {
    _generateNotifications();
  }

  void _generateNotifications() {
    final now = DateTime.now();
    state = [
      NotificationItem(
        id: '1',
        title: 'Optymalna pogoda dla PV',
        description: 'Dziś przewidywane jest pełne słońce - świetny dzień dla produkcji energii!',
        type: 'weather',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
      NotificationItem(
        id: '2',
        title: 'Miesięczny raport gotowy',
        description: 'Wygenerowaliśmy raport z produkcji energii za ostatni miesiąc',
        type: 'report',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  void markAsRead(String id) {
    state = state.map((notification) {
      if (notification.id == id) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((notification) => notification.copyWith(isRead: true)).toList();
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
});
