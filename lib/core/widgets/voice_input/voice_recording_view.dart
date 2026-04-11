import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/widgets/voice_input/voice_wave_animation.dart';

class VoiceRecordingView extends StatefulWidget {
  final VoiceInputCubit cubit;
  final Color? activeColor;

  const VoiceRecordingView({
    super.key,
    required this.cubit,
    this.activeColor,
  });

  @override
  State<VoiceRecordingView> createState() => _VoiceRecordingViewState();
}

class _VoiceRecordingViewState extends State<VoiceRecordingView> {
  Timer? _refreshTimer;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _handleState(widget.cubit.state);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _handleState(VoiceInputState state) {
    state.whenOrNull(
      recording: (_) {
        if (!_stopwatch.isRunning) {
          _stopwatch.start();
          _startRefreshTimer();
        }
      },
      paused: (_) {
        _stopwatch.stop();
        _stopRefreshTimer();
      },
      idle: () => _resetTimer(),
      success: (_) => _resetTimer(),
      error: (_) => _resetTimer(),
    );
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) {
      // Just trigger a rebuild to update the timer and wave animationF
      if (mounted) setState(() {});
    });
  }

  void _stopRefreshTimer() {
    _refreshTimer?.cancel();
    if (mounted) setState(() {});
  }

  void _resetTimer() {
    _stopwatch.stop();
    _stopwatch.reset();
    _stopRefreshTimer();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceInputCubit, VoiceInputState>(
      bloc: widget.cubit,
      listener: (context, state) => _handleState(state),
      child: BlocBuilder<VoiceInputCubit, VoiceInputState>(
        bloc: widget.cubit,
        builder: (context, state) {
          final isRecording = state.maybeWhen(
            recording: (_) => true,
            orElse: () => false,
          );
          final isPaused = state.maybeWhen(
            paused: (_) => true,
            orElse: () => false,
          );
          final amplitude = state.maybeWhen(
            recording: (amp) => amp,
            paused: (amp) => amp,
            orElse: () => 0.0,
          );

          final activeColor = widget.activeColor ?? Const.aqua;

          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Cancel Button
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => widget.cubit.cancelRecording(),
                ),
                const SizedBox(width: 8),
                // Timer
                Text(
                  _formatDuration(_stopwatch.elapsed),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 12),
                // Wave Animation
                Expanded(
                  child: VoiceWaveAnimation(
                    amplitude: amplitude,
                    isAnimating: isRecording,
                    color: activeColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Pause/Resume Button
                IconButton(
                  icon: Icon(
                    isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: activeColor,
                  ),
                  onPressed: () {
                    if (isPaused) {
                      widget.cubit.resumeRecording();
                    } else {
                      widget.cubit.pauseRecording();
                    }
                  },
                ),
                // Stop/Done Button
                CircleAvatar(
                  backgroundColor: activeColor,
                  radius: 20,
                  child: IconButton(
                    icon:
                        const Icon(Icons.check, color: Colors.white, size: 20),
                    onPressed: () => widget.cubit.stopRecording(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
