import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/features/pharmacogenomics/presentation/widgets/pharmacogenomic_report_form.dart';

class PharmagenomicsProfilePage extends StatefulWidget {
  const PharmagenomicsProfilePage({super.key});

  @override
  _PharmagenomicsProfilePageState createState() =>
      _PharmagenomicsProfilePageState();
}

class _PharmagenomicsProfilePageState extends State<PharmagenomicsProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PharmacogenomicsCubit>().fetchPharmacogenomics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.pharmacogenomics_profile_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.common_full_report_file,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const PharamacogenomicReportForm(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text(context.l10n.common_save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
