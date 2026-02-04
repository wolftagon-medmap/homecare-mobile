import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/reviewer.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';
import 'package:m2health/const.dart';
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(professional),
          const SizedBox(height: 16),
          _buildStatsRow(context, professional),
          const SizedBox(height: 32),
          _buildAboutMe(context, professional),
          const SizedBox(height: 32),
          _buildWorkingInfo(context, professional),
          const SizedBox(height: 32),
          _buildCertificates(context, professional),
          const SizedBox(height: 32),
          _buildReviews(context, professional.reviews ?? []),
          const SizedBox(height: 80), // Padding for bottom nav bar
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfessionalEntity professional) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.assetNetwork(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: 'assets/images/images_budi.png',
                image: professional.avatar ?? '',
                imageErrorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 25,
                    color: Colors.grey[600],
                  );
                },
              ),
            ),
            const Positioned(
              top: -8,
              right: -8,
              child: Icon(
                Icons.circle,
                color: Color(0xFF8EF4BC),
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          professional.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          professional.jobTitle ?? 'Nurse',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, ProfessionalEntity professional) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    '180+', // Example data
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Const.tosca,
                    ),
                  ),
                  Text(context.t.booking.professional_detail.patients_label),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${professional.experience} Y+',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Const.tosca,
                    ),
                  ),
                  Text(context.t.booking.professional_detail.experience_label),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFEEB854),
                      ),
                      Text(
                        professional.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Const.tosca,
                        ),
                      ),
                    ],
                  ),
                  Text(context.t.booking.professional_detail.rating_label),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMe(BuildContext context, ProfessionalEntity professional) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.booking.professional_detail.about_me,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            professional.about ?? 'No description available.',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingInfo(
      BuildContext context, ProfessionalEntity professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.booking.professional_detail.working_info,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                  professional.workingHours ?? context.t.global.not_specified),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                professional.workplace ?? context.t.global.not_specified,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCertificates(
      BuildContext context, ProfessionalEntity professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.t.booking.professional_detail.certificates,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        if (professional.certificates == null ||
            professional.certificates!.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(context.t.booking.professional_detail.no_certificate),
          )
        else
          Column(
            children: professional.certificates!.map((cert) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 112,
                      height: 76,
                      child: Image.network(
                        cert.fileURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // TODO: Replace with actual placeholder image
                          return Image.asset('assets/images/cert1.png');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(context.t.booking.professional_detail
                              .id_number(number: cert.registrationNumber)),
                          Text(context.t.booking.professional_detail
                              .issued_on(date: cert.issuedOn)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildReviews(BuildContext context, List<ReviewEntity> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.t.booking.professional_detail.reviews,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (reviews.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Handle See All click
                },
                child:
                    Text(context.t.booking.professional_detail.see_all_button),
              ),
          ],
        ),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(context.t.booking.professional_detail.no_reviews),
          )
        else
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: review.reviewer.avatar != null
                              ? NetworkImage(review.reviewer.avatar)
                              : null,
                          child: (review.reviewer.avatar == null)
                              ? const Icon(Icons.person,
                                  size: 30, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            review.reviewer.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            Text(review.score.toString()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.description.isNotEmpty
                          ? review.description
                          : 'No comment provided.',
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
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
