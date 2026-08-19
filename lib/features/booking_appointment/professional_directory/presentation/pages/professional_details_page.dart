import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/public_profile_body.dart';
import 'package:m2health/i18n/translations.g.dart';

class ProfessionalDetailsPage extends StatefulWidget {
  final int professionalId;
  final String role;
  final Function onButtonPressed;

  const ProfessionalDetailsPage({
    super.key,
    required this.professionalId,
    required this.role,
    required this.onButtonPressed,
  });

  @override
  State<ProfessionalDetailsPage> createState() =>
      _ProfessionalDetailsPageState();
}

class _ProfessionalDetailsPageState extends State<ProfessionalDetailsPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProfessionalDetailCubit>()
        .fetchProfessionalDetail(widget.professionalId);
  }

  String getTitle(BuildContext context) {
    switch (widget.role) {
      case 'nursing':
        return context.t.booking.professional_detail.title.nurse;
      case 'pharmacist':
        return context.t.booking.professional_detail.title.pharmacist;
      case 'radiologist':
        return context.t.booking.professional_detail.title.radiologist;
      default:
        return context.t.booking.professional_detail.title.kDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(context),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
        builder: (context, state) {
          if (state is ProfessionalDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfessionalDetailError) {
            return Center(child: Text(state.message));
          } else if (state is ProfessionalDetailLoaded) {
            final professional = state.professional;
            return _buildProfessionalBody(context, professional);
          }
          return const Center(child: Text('Failed to load details.'));
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
        builder: (context, state) {
          if (state is ProfessionalDetailLoaded) {
            return _buildBottomButton(context, state.professional);
          }
          return _buildBottomButton(context, null, disabled: true);
        },
      ),
    );
  }

  Widget _buildProfessionalBody(
      BuildContext context, ProfessionalEntity professional) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: PublicProfileBody(professional: professional),
    );
  }

  Widget _buildBottomButton(
      BuildContext context, ProfessionalEntity? professional,
      {bool disabled = false}) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: ElevatedButton(
        onPressed: (disabled || professional == null)
            ? null
            : () {
                widget.onButtonPressed();

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => BookAppointmentPage(
                //       professional: professional,
                //     ),
                //   ),
                // );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          context.t.booking.professional_detail.schedule_button,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
