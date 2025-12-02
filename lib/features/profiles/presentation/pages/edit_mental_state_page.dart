import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';
import 'package:m2health/features/profiles/presentation/bloc/mental_health_state_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/mental_health_state_state.dart';

class EditMentalStatePage extends StatefulWidget {
  const EditMentalStatePage({super.key});

  @override
  State<EditMentalStatePage> createState() => _EditMentalStatePageState();
}

class _EditMentalStatePageState extends State<EditMentalStatePage> {
  MentalHealthState? _formData;
  MentalHealthState? _initialData;

  @override
  void initState() {
    super.initState();
    context.read<MentalHealthStateCubit>().loadMentalHealthState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental State",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<MentalHealthStateCubit, MentalHealthStateState>(
        listener: (context, state) {
          if (state is MentalHealthStateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).pop();
          }
          if (state is MentalHealthStateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
          if (state is MentalHealthStateLoaded && _formData == null) {
            setState(() {
              _formData = state.mentalHealthState;
              _initialData = state.mentalHealthState;
            });
          }
        },
        builder: (context, state) {
          if (state is MentalHealthStateLoading && _formData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_formData == null && state is MentalHealthStateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<MentalHealthStateCubit>()
                        .loadMentalHealthState(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          if (_formData == null && state is MentalHealthStateInitial) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Waiting for load to start/finish
          }

          // Fallback for weird states or if loaded but _formData somehow null (should rely on listener)
          if (_formData == null) {
            if (state is MentalHealthStateLoaded) {
              _formData = state.mentalHealthState;
              _initialData = state.mentalHealthState;
            } else {
              return const SizedBox(); // Should not happen often
            }
          }

          final bool isSaving = state is MentalHealthStateSaving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mental State (Current)",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Divider(),
                MentalStateSlider(
                  label: "Overall Mood:",
                  value: _formData!.overallMood,
                  initialValue: _initialData?.overallMood,
                  icon: Image.asset('assets/icons/ic_overall_mood.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(overallMood: v));
                  },
                ),
                MentalStateSlider(
                  label: "Anxiety Level:",
                  value: _formData!.anxietyLevel,
                  initialValue: _initialData?.anxietyLevel,
                  icon: Image.asset('assets/icons/ic_anxiety_level.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(anxietyLevel: v));
                  },
                ),
                MentalStateSlider(
                  label: "Stress Level:",
                  value: _formData!.stressLevel,
                  initialValue: _initialData?.stressLevel,
                  icon: Image.asset('assets/icons/ic_stress_level.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(stressLevel: v));
                  },
                ),
                MentalStateSlider(
                  label: "Energy Level:",
                  value: _formData!.energyLevel,
                  initialValue: _initialData?.energyLevel,
                  icon: Image.asset('assets/icons/ic_energy_level.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(energyLevel: v));
                  },
                ),
                MentalStateSlider(
                  label: "Focus Level:",
                  value: _formData!.focusLevel,
                  initialValue: _initialData?.focusLevel,
                  icon: Image.asset('assets/icons/ic_focus_level.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(focusLevel: v));
                  },
                ),
                MentalStateSlider(
                  label: "Sleep Quality:",
                  value: _formData!.sleepQuality,
                  initialValue: _initialData?.sleepQuality,
                  icon: Image.asset('assets/icons/ic_sleep_quality.png'),
                  onChanged: (v) {
                    setState(
                        () => _formData = _formData!.copyWith(sleepQuality: v));
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Image.asset('assets/icons/ic_mood_notes.png',
                        width: 30, height: 30),
                    const SizedBox(width: 10),
                    const Text("Notes/Events affecting your mood:",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _formData!.note,
                  decoration: const InputDecoration(
                      hintText: 'Additional notes',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
                  maxLines: 3,
                  onChanged: (v) {
                    _formData = _formData!.copyWith(note: v);
                  },
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: isSaving ? 'Saving...' : 'Save',
                  isLoading: isSaving,
                  onPressed: () {
                    if (_formData != null) {
                      context
                          .read<MentalHealthStateCubit>()
                          .saveMentalHealthState(_formData!);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MentalStateSlider extends StatelessWidget {
  final String label;
  final int? value;
  final int? initialValue;
  final ValueChanged<int> onChanged;
  final Widget? icon;

  const MentalStateSlider({
    super.key,
    required this.label,
    required this.value,
    this.initialValue,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Default to 1 if null
    double sliderValue = (value ?? 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              SizedBox(width: 30, height: 30, child: icon),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
            ),
            Text("${value ?? '-'}/10",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor)),
          ],
        ),
        Row(
          children: [
            const Text("1",
                style: TextStyle(fontSize: 12, color: Colors.black87)),
            Expanded(
              child: Slider(
                value: sliderValue,
                secondaryTrackValue: initialValue?.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: sliderValue.round().toString(),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                onChanged: (v) => onChanged(v.round()),
                activeColor: primaryColor,
                secondaryActiveColor: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            const Text("10",
                style: TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
