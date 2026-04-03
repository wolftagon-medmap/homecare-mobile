import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/bloc/second_opinion_imaging_flow_bloc.dart';
import 'package:m2health/i18n/translations.g.dart';

class TeleradiologyPage extends StatefulWidget {
  const TeleradiologyPage({super.key});

  @override
  State<TeleradiologyPage> createState() => _TeleradiologyPageState();
}

class _TeleradiologyPageState extends State<TeleradiologyPage> {
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _diseaseHistoryController =
      TextEditingController();
  final TextEditingController _biomarkerController = TextEditingController();

  final List<SecondOpinionImageFile?> _pickedImages = List.filled(3, null);

  @override
  void dispose() {
    _diseaseNameController.dispose();
    _diseaseHistoryController.dispose();
    _biomarkerController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_diseaseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter disease name")),
      );
      return;
    }

    final images = _pickedImages.whereType<SecondOpinionImageFile>().toList();

    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please provide at least one radiology image")),
      );
      return;
    }

    context.read<SecondOpinionImagingFlowBloc>().add(
          FlowFormSubmitted(
            diseaseName: _diseaseNameController.text,
            diseaseHistory: _diseaseHistoryController.text,
            biomarker: _biomarkerController.text,
            images: images,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.teleradiology_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.teleradiology_patient_info,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Divider(color: Colors.grey.shade100),
            Text(
              context.l10n.teleradiology_disease_name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _diseaseNameController,
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_disease_hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_disease_history,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _diseaseHistoryController,
              maxLines: 5,
              minLines: 2,
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_history_hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_other_biomarkers,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _biomarkerController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_biomarker_hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_radiology_images,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Divider(color: Colors.grey.shade100),
            RadiologyImagePicker(
              label: context.l10n.teleradiology_ct_scan,
              imageType: 'CT_SCAN',
              onImageSelected: (file) {
                _pickedImages[0] = file != null
                    ? SecondOpinionImageFile(file: file, imageType: 'CT_SCAN')
                    : null;
              },
            ),
            const SizedBox(height: 16),
            RadiologyImagePicker(
              label: context.l10n.teleradiology_mri_scan,
              imageType: 'MRI_SCAN',
              onImageSelected: (file) {
                _pickedImages[1] = file != null
                    ? SecondOpinionImageFile(file: file, imageType: 'MRI_SCAN')
                    : null;
              },
            ),
            const SizedBox(height: 16),
            RadiologyImagePicker(
              label: context.l10n.teleradiology_mammogram,
              imageType: 'MAMMOGRAM',
              onImageSelected: (file) {
                _pickedImages[2] = file != null
                    ? SecondOpinionImageFile(file: file, imageType: 'MAMMOGRAM')
                    : null;
              },
            ),
            const SizedBox(height: 40),
            Text(
              context.l10n.teleradiology_medical_opinion,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const Divider(),
            Text(
              context.l10n.teleradiology_professional_only_info,
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.teleradiology_diagnostic_opinion,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Write your diagnostic opinion here...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.teleradiology_recommendation_opinion,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Write your recommendation here...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: context.t.global.submit,
          onPressed: _onNext,
        ),
      ),
    );
  }
}

class RadiologyImagePicker extends StatefulWidget {
  final String label;
  final String imageType;
  final Function(File?) onImageSelected;

  const RadiologyImagePicker({
    super.key,
    required this.label,
    required this.imageType,
    required this.onImageSelected,
  });

  @override
  State<RadiologyImagePicker> createState() => _RadiologyImagePickerState();
}

class _RadiologyImagePickerState extends State<RadiologyImagePicker> {
  bool isChecked = false;
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      if (!isChecked) {
                        selectedFile = null;
                        widget.onImageSelected(null);
                      }
                    });
                  },
                  activeColor: Const.aqua,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.info_outline, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (isChecked) ...[
          const SizedBox(height: 10),
          ImagePreview(
            imageFile: selectedFile,
            onChooseImage: (image) {
              setState(() {
                selectedFile = image;
              });
              widget.onImageSelected(image);
            },
          ),
        ],
      ],
    );
  }
}
