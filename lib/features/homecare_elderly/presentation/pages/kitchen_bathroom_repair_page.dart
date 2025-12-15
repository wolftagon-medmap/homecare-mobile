import 'package:flutter/material.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/homecare_task.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/homecare_appointment_flow_page.dart';

const Color _mainColor = Color.fromRGBO(132, 215, 251, 1);

class KitchenBathroomRepairPage extends StatefulWidget {
  const KitchenBathroomRepairPage({super.key});

  @override
  State<KitchenBathroomRepairPage> createState() =>
      _KitchenBathroomRepairPageState();
}

class _KitchenBathroomRepairPageState extends State<KitchenBathroomRepairPage> {
  List<String> _selectedTasks = [];

  void _onTasksChanged(List<String> tasks) {
    setState(() {
      _selectedTasks = tasks;
    });
  }

  void _onRequestServices() {
    if (_selectedTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one task.'),
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
        title: const Text(
          'Kitchen & Bathroom Repair',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const _FeatureCard(),
            const SizedBox(height: 24),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'On-demand minor repairs to maintain functionality and safety in key home areas.',
                  style: TextStyle(fontSize: 12, height: 1.65),
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
          text: 'Request Services',
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
              'assets/illustration/kitchen_n_bathroom_repair.png',
              width: 160,
              height: 88,
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FEATURE NAME',
                style: TextStyle(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Kitchen & Bathroom Repair',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'FREQUENCY',
                style: TextStyle(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'As Needed',
                style: TextStyle(
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
        const HomecareTask(id: 1, name: 'Change lighting and socket'),
        const HomecareTask(id: 2, name: 'Replace sponges/dishcloths'),
        const HomecareTask(id: 3, name: 'Check for leaks under sink'),
        const HomecareTask(id: 4, name: 'Repair leaking faucets'),
        const HomecareTask(id: 5, name: 'Unclog drains'),
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
        const Text(
          'Task List',
          style: TextStyle(
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
