import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_plan.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_plan_cubit.dart';

class NutritionPlanFormPage extends StatefulWidget {
  final int appointmentId;

  const NutritionPlanFormPage({super.key, required this.appointmentId});

  @override
  State<NutritionPlanFormPage> createState() => _NutritionPlanFormPageState();
}

class _NutritionPlanFormPageState extends State<NutritionPlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController();
  final _strategyController = TextEditingController();
  final _caloriesController = TextEditingController();

  // Food guidance
  final List<String> _recommendedFoods = [];
  final List<String> _foodsToLimit = [];

  // Supplements: list of {name, dosage}
  final List<Map<String, TextEditingController>> _supplements = [];

  // Lifestyle adjustments: list of {title, description}
  final List<Map<String, TextEditingController>> _lifestyleAdjustments = [];

  // Weekly meal plan: day → meal type → list of food items
  final Map<String, Map<String, List<Map<String, TextEditingController>>>>
      _weeklyPlan = {};

  final List<String> _days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner'];

  @override
  void initState() {
    super.initState();
    for (final day in _days) {
      _weeklyPlan[day] = {
        'breakfast': [],
        'lunch': [],
        'dinner': [],
      };
    }
  }

  @override
  void dispose() {
    _goalController.dispose();
    _strategyController.dispose();
    _caloriesController.dispose();
    for (final s in _supplements) {
      s['name']!.dispose();
      s['dosage']!.dispose();
    }
    for (final a in _lifestyleAdjustments) {
      a['title']!.dispose();
      a['description']!.dispose();
    }
    for (final day in _weeklyPlan.values) {
      for (final meal in day.values) {
        for (final item in meal) {
          for (final c in item.values) {
            c.dispose();
          }
        }
      }
    }
    super.dispose();
  }

  List<FoodItem> _buildFoodItems(
      List<Map<String, TextEditingController>> items) {
    return items
        .map((item) => FoodItem(
              name: item['name']!.text.trim(),
              imageUrl: '',
              calories: int.tryParse(item['calories']!.text) ?? 0,
              grams: int.tryParse(item['grams']!.text) ?? 0,
              protein: int.tryParse(item['protein']!.text) ?? 0,
              carbs: int.tryParse(item['carbs']!.text) ?? 0,
              fat: int.tryParse(item['fat']!.text) ?? 0,
            ))
        .toList();
  }

  NutritionPlan _buildPlan() {
    final dietaryPlan = DietaryPlan(
      goal: _goalController.text.trim(),
      strategy: _strategyController.text.trim(),
      dailyCaloryTarget: int.tryParse(_caloriesController.text) ?? 0,
      recommendedFoods: List.from(_recommendedFoods),
      foodsToLimit: List.from(_foodsToLimit),
    );

    final supplements = _supplements
        .map((s) => Supplement(
              name: s['name']!.text.trim(),
              dosage: s['dosage']!.text.trim(),
            ))
        .toList();

    final lifestyleAdjustments = _lifestyleAdjustments
        .map((a) => LifestyleAdjustment(
              title: a['title']!.text.trim(),
              description: a['description']!.text.trim(),
            ))
        .toList();
    final weeklyMealPlan = {
      for (final day in _days)
        day: DailyMealPlan(
          breakfast: _buildFoodItems(_weeklyPlan[day]!['breakfast']!),
          lunch: _buildFoodItems(_weeklyPlan[day]!['lunch']!),
          dinner: _buildFoodItems(_weeklyPlan[day]!['dinner']!),
        ),
    };
    return NutritionPlan(
      dietaryPlan: dietaryPlan,
      supplements: supplements,
      lifestyleAdjustments: lifestyleAdjustments,
      weeklyMealPlan: weeklyMealPlan,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context
        .read<NutritionPlanCubit>()
        .submitNutritionPlan(widget.appointmentId, _buildPlan());
  }

  void _addFoodChip(List<String> list, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    setState(() => list.add(trimmed));
  }

  void _addSupplement() {
    setState(() => _supplements.add({
          'name': TextEditingController(),
          'dosage': TextEditingController(),
        }));
  }

  void _removeSupplement(int index) {
    _supplements[index]['name']!.dispose();
    _supplements[index]['dosage']!.dispose();
    setState(() => _supplements.removeAt(index));
  }

  void _addLifestyleAdjustment() {
    setState(() => _lifestyleAdjustments.add({
          'title': TextEditingController(),
          'description': TextEditingController(),
        }));
  }

  void _removeLifestyleAdjustment(int index) {
    _lifestyleAdjustments[index]['title']!.dispose();
    _lifestyleAdjustments[index]['description']!.dispose();
    setState(() => _lifestyleAdjustments.removeAt(index));
  }

  void _addFoodItem(String day, String meal) {
    setState(() => _weeklyPlan[day]![meal]!.add({
          'name': TextEditingController(),
          'calories': TextEditingController(),
          'grams': TextEditingController(),
          'protein': TextEditingController(),
          'carbs': TextEditingController(),
          'fat': TextEditingController(),
        }));
  }

  void _removeFoodItem(String day, String meal, int index) {
    final item = _weeklyPlan[day]![meal]![index];
    for (final c in item.values) {
      c.dispose();
    }
    setState(() => _weeklyPlan[day]![meal]!.removeAt(index));
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutritionPlanCubit, NutritionPlanState>(
      listenWhen: (prev, curr) =>
          curr.status == NutritionPlanStatus.submitted ||
          (curr.status == NutritionPlanStatus.failure &&
              prev.status == NutritionPlanStatus.submitting),
      listener: (context, state) {
        if (state.status == NutritionPlanStatus.submitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nutrition plan submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == NutritionPlanStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  state.errorMessage ?? 'Failed to submit plan. Try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == NutritionPlanStatus.submitting;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Create Nutrition Plan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  title: 'Dietary Overview',
                  icon: Icons.flag_outlined,
                  color: const Color(0xFF5782F1),
                  children: [
                    _buildTextField(
                      controller: _goalController,
                      label: 'Dietary Goal',
                      hint: 'e.g. Weight management, blood sugar control',
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _strategyController,
                      label: 'Dietary Strategy',
                      hint:
                          'Describe the overall dietary approach for this patient…',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _caloriesController,
                      label: 'Daily Calorie Target (kcal)',
                      hint: 'e.g. 1800',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Food Guidance',
                  icon: Icons.restaurant_outlined,
                  color: const Color(0xFF56AB2F),
                  children: [
                    _ChipInputField(
                      label: 'Recommended Foods',
                      chips: _recommendedFoods,
                      chipColor: Colors.green.shade100,
                      onAdd: (value) => _addFoodChip(_recommendedFoods, value),
                      onRemove: (index) =>
                          setState(() => _recommendedFoods.removeAt(index)),
                    ),
                    const SizedBox(height: 12),
                    _ChipInputField(
                      label: 'Foods to Limit',
                      chips: _foodsToLimit,
                      chipColor: Colors.red.shade100,
                      onAdd: (value) => _addFoodChip(_foodsToLimit, value),
                      onRemove: (index) =>
                          setState(() => _foodsToLimit.removeAt(index)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Supplements',
                  icon: Icons.medication_outlined,
                  color: const Color(0xFFF79E1B),
                  children: [
                    ..._supplements.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return _SupplementRow(
                        nameController: s['name']!,
                        dosageController: s['dosage']!,
                        onRemove: () => _removeSupplement(i),
                      );
                    }),
                    const SizedBox(height: 8),
                    _AddButton(
                      label: 'Add Supplement',
                      onTap: _addSupplement,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Lifestyle Adjustments',
                  icon: Icons.self_improvement_outlined,
                  color: Const.aqua,
                  children: [
                    ..._lifestyleAdjustments.asMap().entries.map((entry) {
                      final i = entry.key;
                      final a = entry.value;
                      return _LifestyleRow(
                        titleController: a['title']!,
                        descriptionController: a['description']!,
                        onRemove: () => _removeLifestyleAdjustment(i),
                      );
                    }),
                    const SizedBox(height: 8),
                    _AddButton(
                      label: 'Add Adjustment',
                      onTap: _addLifestyleAdjustment,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Weekly Meal Plan',
                  icon: Icons.calendar_today_outlined,
                  color: const Color(0xFF9B59B6),
                  children: [
                    ..._days.map((day) => _DaySection(
                          day: _capitalize(day),
                          mealTypes: _mealTypes,
                          items: _weeklyPlan[day]!,
                          onAddItem: (meal) => _addFoodItem(day, meal),
                          onRemoveItem: (meal, index) =>
                              _removeFoodItem(day, meal, index),
                        )),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.aqua,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Submit Plan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// --- Chip Input Field ---

class _ChipInputField extends StatefulWidget {
  final String label;
  final List<String> chips;
  final Color chipColor;
  final void Function(String) onAdd;
  final void Function(int) onRemove;

  const _ChipInputField({
    required this.label,
    required this.chips,
    required this.chipColor,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_ChipInputField> createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<_ChipInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    widget.onAdd(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type and press Add',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _add,
              style: TextButton.styleFrom(
                foregroundColor: Const.aqua,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        if (widget.chips.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.chips.asMap().entries.map((entry) {
              return Chip(
                label: Text(entry.value, style: const TextStyle(fontSize: 12)),
                backgroundColor: widget.chipColor,
                deleteIconColor: Colors.grey.shade600,
                onDeleted: () => widget.onRemove(entry.key),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// --- Supplement Row ---

class _SupplementRow extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final VoidCallback onRemove;

  const _SupplementRow({
    required this.nameController,
    required this.dosageController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. Vitamin D3',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: dosageController,
                  decoration: InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 1000 IU daily',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

// --- Lifestyle Row ---

class _LifestyleRow extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onRemove;

  const _LifestyleRow({
    required this.titleController,
    required this.descriptionController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. Sleep Hygiene',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the adjustment…',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

// --- Day Section (for weekly meal plan) ---

class _DaySection extends StatefulWidget {
  final String day;
  final List<String> mealTypes;
  final Map<String, List<Map<String, TextEditingController>>> items;
  final void Function(String meal) onAddItem;
  final void Function(String meal, int index) onRemoveItem;

  const _DaySection({
    required this.day,
    required this.mealTypes,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  @override
  State<_DaySection> createState() => _DaySectionState();
}

class _DaySectionState extends State<_DaySection> {
  bool _expanded = false;

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          title: Text(
            widget.day,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          trailing: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.grey,
          ),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          children: widget.mealTypes.map((meal) {
            final mealItems = widget.items[meal]!;
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _capitalize(meal),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => widget.onAddItem(meal),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Food',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: Const.aqua,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                      ),
                    ],
                  ),
                  ...mealItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _FoodItemRow(
                      controllers: item,
                      onRemove: () => widget.onRemoveItem(meal, index),
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// --- Food Item Row ---

class _FoodItemRow extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final VoidCallback onRemove;

  const _FoodItemRow({required this.controllers, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controllers['name'],
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    hintText: 'e.g. Brown Rice',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Nutritional Info',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          _NumField(
              controller: controllers['calories']!, label: 'Calories (kcal)'),
          const SizedBox(height: 6),
          _NumField(controller: controllers['grams']!, label: 'Grams (g)'),
          const SizedBox(height: 6),
          _NumField(controller: controllers['protein']!, label: 'Protein (g)'),
          const SizedBox(height: 6),
          _NumField(controller: controllers['carbs']!, label: 'Carbs (g)'),
          const SizedBox(height: 6),
          _NumField(controller: controllers['fat']!, label: 'Fat (g)'),
        ],
      ),
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _NumField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}

// --- Add Button ---

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Const.aqua,
        side: BorderSide(color: Const.aqua.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 40),
      ),
    );
  }
}
