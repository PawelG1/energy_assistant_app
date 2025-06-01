import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'weather_provider.dart';

class TimerNotifier extends StateNotifier<DateTime> {
  Timer? _timer;

  TimerNotifier() : super(DateTime.now()) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      state = DateTime.now();
    });
  }

  void forceUpdate() {
    state = DateTime.now();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, DateTime>((ref) {
  return TimerNotifier();
});

// Provider który nasłuchuje zmian co minutę
final autoRefreshProvider = Provider<DateTime>((ref) {
  return ref.watch(timerProvider);
});

// Osobny provider do obsługi auto-refresh weather - BEZ cyklicznej zależności
final weatherAutoRefreshProvider = Provider<void>((ref) {
  // Obserwuj timer
  ref.watch(timerProvider);

  // Używaj ref.read aby nie tworzyć zależności podczas watch
  Future.microtask(() {
    ref.read(weatherProvider.notifier).refreshWeather();
  });
});
