import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:vibration/vibration.dart';

class RestTimerSheet extends StatefulWidget {
  const RestTimerSheet({super.key});

  @override
  State<RestTimerSheet> createState() => _RestTimerSheetState();
}

class _RestTimerSheetState extends State<RestTimerSheet> {
  final _controller = CountDownController();
  int _selectedSeconds = 90;
  bool _isRunning = true;
  bool _finished = false;

  static const _options = [60, 90, 120];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Descanso',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Time selector chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _options.map((s) {
              final selected = _selectedSeconds == s;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ChoiceChip(
                  label: Text('${s}s'),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedSeconds = s;
                      _finished = false;
                      _isRunning = true;
                    });
                    _controller.restart(duration: s);
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Countdown circle
          CircularCountDownTimer(
            duration: _selectedSeconds,
            initialDuration: 0,
            controller: _controller,
            width: 160,
            height: 160,
            ringColor: Colors.white12,
            fillColor: _finished
                ? Colors.red.withValues(alpha: 0.4)
                : const Color(0xFF4361EE).withValues(alpha: 0.4),
            backgroundColor: const Color(0xFF2A2A3E),
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.MM_SS,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onComplete: _onComplete,
          ),
          const SizedBox(height: 28),

          if (_finished)
            const Text(
              '¡Listo!',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pause / Resume
                OutlinedButton.icon(
                  onPressed: _togglePause,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pausar' : 'Reanudar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 12),
                // Reset
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Resetear'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _togglePause() {
    if (_isRunning) {
      _controller.pause();
    } else {
      _controller.resume();
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _reset() {
    setState(() {
      _finished = false;
      _isRunning = true;
    });
    _controller.restart(duration: _selectedSeconds);
  }

  Future<void> _onComplete() async {
    setState(() => _finished = true);
    final canVibrate = await Vibration.hasVibrator() ?? false;
    if (canVibrate) {
      Vibration.vibrate(pattern: [0, 400, 200, 400]);
    }
  }
}
