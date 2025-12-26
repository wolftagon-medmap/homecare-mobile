import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/wellness_genomics/domain/usecases/delete_wellness_genomic.dart';
import 'package:m2health/features/wellness_genomics/domain/usecases/get_wellness_genomics.dart';
import 'package:m2health/features/wellness_genomics/domain/usecases/store_wellness_genomics.dart';
import 'package:m2health/features/wellness_genomics/presentation/bloc/wellness_genomics_cubit.dart';
import 'package:m2health/features/wellness_genomics/presentation/widgets/wellness_genomics_report_form.dart';

class WellnessGenomicsProfilePage extends StatelessWidget {
  const WellnessGenomicsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WellnessGenomicsCubit(
        getWellnessGenomics: GetIt.instance<GetWellnessGenomics>(),
        storeWellnessGenomics: GetIt.instance<StoreWellnessGenomics>(),
        deleteWellnessGenomic: GetIt.instance<DeleteWellnessGenomic>(),
      )..fetchWellnessGenomics(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.wellness_genomics_profile_title,
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
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const WellnessGenomicsReportForm(), //
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
      ),
    );
  }
}
