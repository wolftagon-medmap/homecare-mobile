import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';

class TeleradiologyDetail extends StatefulWidget {
  const TeleradiologyDetail({super.key});

  @override
  State<TeleradiologyDetail> createState() => _TeleradiologyDetailState();
}

class _TeleradiologyDetailState extends State<TeleradiologyDetail> {
  bool ctScanChecked = false;
  bool mriScanChecked = false;
  bool mammogramScanChecked = false;

  final List<File?> _images = List.filled(3, null);

  Future<void> setImageAt(int index, File? image) async {
    setState(() {
      _images[index] = image;
    });
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
              context.l10n.teleradiology_disease_name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.grey),
            Text(
              context.l10n.teleradiology_disease_history,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_disease_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_other_biomarkers,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_history_hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_patient_info,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_biomarker_hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_radiology_images,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: ctScanChecked,
                      onChanged: (value) {
                        setState(() {
                          ctScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.teleradiology_ct_scan,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[0],
              onChooseImage: (image) => setImageAt(0, image),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: mriScanChecked,
                      onChanged: (value) {
                        setState(() {
                          mriScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.teleradiology_mri_scan,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[1],
              onChooseImage: (image) => setImageAt(1, image),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: mammogramScanChecked,
                      onChanged: (value) {
                        setState(() {
                          mammogramScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.teleradiology_mammogram,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[2],
              onChooseImage: (image) => setImageAt(2, image),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              context.l10n.teleradiology_medical_opinion,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Text(
              context.l10n.teleradiology_professional_only_info,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.teleradiology_diagnostic_opinion,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_disease_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              context.l10n.teleradiology_recommendation_opinion,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: context.l10n.teleradiology_disease_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 350, // Ubah ukuran sesuai kebutuhan
              height: 50, // Ubah ukuran sesuai kebutuhan
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                ),
                child: Text(
                  context.l10n.common_submit,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
