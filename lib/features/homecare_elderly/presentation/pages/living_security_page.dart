import 'package:flutter/material.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/features/homecare_elderly/domain/entity/homecare_task.dart';

const Color _mainColor = Color.fromRGBO(178, 140, 255, 1);

class LivingSecurityPage extends StatelessWidget {
  const LivingSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Living Security & Safety',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: const [
            _FeatureCard(),
            SizedBox(height: 24),
            Column(
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
                  'Safety checks and organization to reduce risks and create a secure living environment.',
                  style: TextStyle(fontSize: 12, height: 1.65),
                ),
              ],
            ),
            SizedBox(height: 24),
            _TaskList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: PrimaryButton(text: 'Request Services', onPressed: () {}),
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
                'Living Security & Safety',
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
                'Monthly',
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
  const _TaskList();

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

  List<HomecareTask> selectedTasks = [];

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
            bool isSelected = selectedTasks.contains(task);
            void toggleSelection(bool? value) {
              setState(() {
                if (value == true) {
                  selectedTasks.add(task);
                } else {
                  selectedTasks.remove(task);
                }
              });
            }

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
                onChanged: toggleSelection,
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
