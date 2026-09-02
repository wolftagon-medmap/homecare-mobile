import 'package:flutter/material.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_form.dart';

class SmokingCessationFormPage extends StatefulWidget {
  final SmokingCessationForm? initialForm;
  final Function(SmokingCessationForm) onSubmit;

  const SmokingCessationFormPage({
    super.key,
    this.initialForm,
    required this.onSubmit,
  });

  @override
  State<SmokingCessationFormPage> createState() =>
      _SmokingCessationFormPageState();
}

class _SmokingCessationFormPageState extends State<SmokingCessationFormPage> {
  bool? _isSmoking;
  final List<String> _selectedProductTypes = [];
  int? _sticksPerDay;
  bool? _hasTriedQuitting;

  final TextEditingController _sticksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialForm != null) {
      _isSmoking = widget.initialForm!.isSmoking;
      _selectedProductTypes.addAll(widget.initialForm!.productTypes ?? []);
      _sticksPerDay = widget.initialForm!.sticksPerDay;
      _hasTriedQuitting = widget.initialForm!.hasTriedQuitting;
      _sticksController.text = _sticksPerDay?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _sticksController.dispose();
    super.dispose();
  }

  void _toggleProductType(String type) {
    setState(() {
      if (_selectedProductTypes.contains(type)) {
        _selectedProductTypes.remove(type);
        if (_selectedProductTypes.isEmpty) {
          _isSmoking = null;
        }
      } else {
        _selectedProductTypes.add(type);
        _isSmoking = true; // If any product is selected, they are smoking
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smoking Cessation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current smoking habit:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const _RequiredQuestionText(
                text:
                    'Are you smoking cigarette, other tobacco products (e.g. cigars, pipes) or vaping?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              _CustomCheckbox(
                label: 'Cigarette',
                isSelected: _selectedProductTypes.contains('Cigarette'),
                onTap: () => _toggleProductType('Cigarette'),
              ),
              _CustomCheckbox(
                label: 'Vaping',
                isSelected: _selectedProductTypes.contains('Vaping'),
                onTap: () => _toggleProductType('Vaping'),
              ),
              _CustomCheckbox(
                label: 'Other tobacco products (e.g. cigars, pipes)',
                isSelected: _selectedProductTypes.contains('Other'),
                onTap: () => _toggleProductType('Other'),
              ),
              const Divider(height: 32),
              _CustomCheckbox(
                label: 'I am not currently smoking',
                isSelected:
                    _isSmoking == false && _selectedProductTypes.isEmpty,
                onTap: () {
                  setState(() {
                    _isSmoking = _isSmoking == false ? null : false;
                    _selectedProductTypes.clear();
                  });
                },
              ),
              const SizedBox(height: 24),
              const _RequiredQuestionText(
                text: 'How many sticks do you smoke in a day?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sticksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'E.g. 10',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (val) {
                  setState(() {
                    _sticksPerDay = int.tryParse(val);
                  });
                },
              ),
              const SizedBox(height: 24),
              const _RequiredQuestionText(
                text: 'Have you previously attempted to quit?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _CustomRadioButton(
                    label: 'Yes',
                    isSelected: _hasTriedQuitting == true,
                    onTap: () => setState(() => _hasTriedQuitting = true),
                  ),
                  const SizedBox(width: 32),
                  _CustomRadioButton(
                    label: 'No',
                    isSelected: _hasTriedQuitting == false,
                    onTap: () => setState(() => _hasTriedQuitting = false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: PrimaryButton(
          text: "Book Now",
          onPressed: (_isSmoking == null ||
                  _hasTriedQuitting == null ||
                  _sticksPerDay == null)
              ? null
              : () {
                  widget.onSubmit(SmokingCessationForm(
                    isSmoking: _isSmoking!,
                    productTypes: _selectedProductTypes.isEmpty
                        ? null
                        : List.from(_selectedProductTypes),
                    sticksPerDay: _sticksPerDay,
                    hasTriedQuitting: _hasTriedQuitting!,
                  ));
                },
        ),
      ),
    );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomCheckbox({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFF35C5CF)
                        : const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(6),
                color: isSelected ? const Color(0xFF35C5CF) : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomRadioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomRadioButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected
                      ? const Color(0xFF35C5CF)
                      : const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? const Color(0xFF35C5CF) : Colors.white,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _RequiredQuestionText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _RequiredQuestionText({
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: style,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
