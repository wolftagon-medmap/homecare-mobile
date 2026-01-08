import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/presentation/widgets/star_rating.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_event.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_state.dart';
import 'package:m2health/i18n/translations.g.dart';

class SearchProfessionalPage extends StatefulWidget {
  final String role;
  final List<int> serviceIds;
  final bool isHomeScreeningAuthorized;
  final Function(ProfessionalEntity) onProfessionalSelected;

  const SearchProfessionalPage({
    super.key,
    required this.role,
    this.serviceIds = const [],
    this.isHomeScreeningAuthorized = false,
    required this.onProfessionalSelected,
  });

  @override
  State<SearchProfessionalPage> createState() => _SearchProfessionalPageState();
}

class _SearchProfessionalPageState extends State<SearchProfessionalPage> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfessionals();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchProfessionals({String query = ''}) {
    context.read<ProfessionalBloc>().add(
          GetProfessionalsEvent(
            widget.role,
            name: query,
            serviceIds: widget.serviceIds,
            isHomeScreeningAuthorized: widget.isHomeScreeningAuthorized,
          ),
        );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchProfessionals(query: query);
    });
  }

  String getTitle(BuildContext context, String role) {
    switch (role) {
      case 'nurse':
        return context.t.booking.professional_search.title.nurse;
      case 'pharmacist':
        return context.t.booking.professional_search.title.pharmacist;
      case 'radiologist':
        return context.t.booking.professional_search.title.radiologist;
      case 'caregiver':
        return context.t.booking.professional_search.title.caregiver;
      default:
        return context.t.booking.professional_search.title.kDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(context, widget.role),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: getTitle(context, widget.role),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            if (widget.serviceIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      context.t.booking.professional_search
                          .filter_text(count: widget.serviceIds.length),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
                builder: (context, state) {
                  if (state is ProfessionalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfessionalLoaded) {
                    final professionals = state.professionals;
                    if (professionals.isEmpty) {
                      return Center(
                          child: Text(
                              context.t.booking.professional_search.empty));
                    }
                    return ListView.builder(
                      itemCount: professionals.length,
                      itemBuilder: (context, index) {
                        final professional = professionals[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: Colors.grey[200]!,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.grey[300],
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                professional.avatar ?? '',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Colors.grey[600],
                                                  );
                                                },
                                              )),
                                        ),
                                        const Positioned(
                                          top: -6,
                                          right: -6,
                                          child: Icon(
                                            Icons.circle,
                                            color: Color(0xFF8EF4BC),
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        if (professional.rating != null)
                                          StarRating(
                                            rating: professional.rating!,
                                            color: const Color(0xFF8EF4BC),
                                          ),
                                        const SizedBox(width: 4),
                                        Text(professional.rating.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        professional.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        professional.jobTitle ?? 'N/A',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              widget.onProfessionalSelected(
                                                  professional);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.grey[200],
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              context
                                                  .t
                                                  .booking
                                                  .professional_search
                                                  .appointment_button,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              professional.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                            ),
                                            color: const Color(0xFF35C5CF),
                                            onPressed: () {
                                              context
                                                  .read<ProfessionalBloc>()
                                                  .add(
                                                    ToggleFavoriteEvent(
                                                      professional.id,
                                                      !professional.isFavorite,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ProfessionalError) {
                    return Center(
                        child: Text(context.t.global
                            .error_message(error: state.message)));
                  } else {
                    return const Center(
                        child: Text('Failed to load professionals'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
