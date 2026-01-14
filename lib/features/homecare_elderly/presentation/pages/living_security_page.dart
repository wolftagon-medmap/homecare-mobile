import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/homecare_task.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/homecare_appointment_flow_page.dart';

const Color _mainColor = Color.fromRGBO(178, 140, 255, 1);

class LivingSecurityPage extends StatefulWidget {
  const LivingSecurityPage({super.key});

  @override
  State<LivingSecurityPage> createState() => _LivingSecurityPageState();
}

class _LivingSecurityPageState extends State<LivingSecurityPage> {
  List<String> _selectedTasks = [];

  void _onTasksChanged(List<String> tasks) {
    setState(() {
      _selectedTasks = tasks;
    });
  }

  void _onRequestServices() {
    if (_selectedTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.homecare_select_at_least_one_task),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomecareAppointmentFlowPage(
          selectedTasks: _selectedTasks,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homecare_living_security_safety,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const _FeatureCard(),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.common_description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.homecare_living_security_safety_desc,
                  style: const TextStyle(fontSize: 12, height: 1.65),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _TaskList(onChanged: _onTasksChanged),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: PrimaryButton(
          text: context.l10n.homecare_request_services_btn,
          onPressed: _onRequestServices,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _mainColor),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -16,
            right: -16,
            child: Image.asset(
              'assets/illustration/living_security_n_safety.png',
              width: 160,
              height: 100,
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.homecare_feature_name,
                style: const TextStyle(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.homecare_living_security_safety,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.homecare_frequency,
                style: const TextStyle(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.homecare_monthly,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskList extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  const _TaskList({required this.onChanged});

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  List<HomecareTask> get tasks => [
        const HomecareTask(id: 1, name: 'Remove floor hazards'),
        const HomecareTask(id: 2, name: 'Check lighting in hallways'),
        const HomecareTask(id: 3, name: 'Check night lights'),
        const HomecareTask(id: 4, name: 'Test smoke/CO alarms'),
        const HomecareTask(id: 5, name: 'Organize medications'),
        const HomecareTask(id: 6, name: 'Verify mobility aids'),
        const HomecareTask(id: 7, name: 'Check safe footwear'),
      ];

  final List<String> selectedTasks = [];

  void toggleSelection(HomecareTask task, bool? value) {
    setState(() {
      if (value == true) {
        if (!selectedTasks.contains(task.name)) {
          selectedTasks.add(task.name);
        }
      } else {
        selectedTasks.remove(task.name);
      }
      widget.onChanged(selectedTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.homecare_task_list_title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            bool isSelected = selectedTasks.contains(task.name);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CheckboxListTile(
                title: Text(
                  task.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                value: isSelected,
                onChanged: (val) => toggleSelection(task, val),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                activeColor: _mainColor,
                side: const BorderSide(color: _mainColor, width: 1.5),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
