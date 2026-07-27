import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/star_rating.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_event.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_state.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/widgets/visit_address_bar.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class SearchProfessionalPage extends StatefulWidget {
  final String role;
  final List<int> serviceIds;
  final bool isHomeScreeningAuthorized;
  final String? serviceSubCategory;
  final Function(ProfessionalEntity) onProfessionalSelected;
  final Widget? leading;

  const SearchProfessionalPage({
    super.key,
    required this.role,
    this.serviceIds = const [],
    this.isHomeScreeningAuthorized = false,
    this.serviceSubCategory,
    required this.onProfessionalSelected,
    this.leading,
  });

  @override
  State<SearchProfessionalPage> createState() => _SearchProfessionalPageState();
}

class _SearchProfessionalPageState extends State<SearchProfessionalPage> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  late final SavedAddressesCubit _addressesCubit;
  Address? _selectedAddress;
  bool _hasPickedDefault = false;

  @override
  void initState() {
    super.initState();
    _addressesCubit = SavedAddressesCubit(
      getAddressesUseCase: sl(),
      createAddressUseCase: sl(),
      updateAddressUseCase: sl(),
      deleteAddressUseCase: sl(),
      setDefaultAddressUseCase: sl(),
    )..loadAddresses();
    _addressesCubit.stream.listen(_onAddressesStateChanged);
    _fetchProfessionals();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _addressesCubit.close();
    super.dispose();
  }

  void _onAddressesStateChanged(SavedAddressesState state) {
    if (_hasPickedDefault || state is! SavedAddressesLoaded) return;
    if (state.addresses.isEmpty) return;
    _hasPickedDefault = true;
    final defaultAddress = state.addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => state.addresses.first,
    );
    setState(() => _selectedAddress = defaultAddress);
    _fetchProfessionals(query: _searchController.text);
  }

  void _onAddressSelected(Address address) {
    Navigator.pop(context);
    setState(() => _selectedAddress = address);
    _fetchProfessionals(query: _searchController.text);
  }

  Future<void> _openAddNewAddress() async {
    Navigator.pop(context);
    await context.push<bool>(AppRoutes.savedAddressForm);
    if (mounted) _addressesCubit.loadAddresses();
  }

  void _showAddressPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: _addressesCubit,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
                builder: (context, state) {
                  final addresses =
                      state is SavedAddressesLoaded ? state.addresses : const <Address>[];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.booking.professional_search.visit_address.picker_title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (state is SavedAddressesLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              final isSelected = address.id == _selectedAddress?.id;
                              return ListTile(
                                leading: Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected ? Const.aqua : Colors.grey,
                                ),
                                title: Text(
                                  address.label?.isNotEmpty == true
                                      ? address.label!
                                      : (address.formattedAddress ?? ''),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: address.formattedAddress != null &&
                                        address.label?.isNotEmpty == true
                                    ? Text(address.formattedAddress!,
                                        maxLines: 1, overflow: TextOverflow.ellipsis)
                                    : null,
                                onTap: () => _onAddressSelected(address),
                              );
                            },
                          ),
                        ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.add, color: Const.aqua),
                        title: Text(
                          context.t.booking.professional_search.visit_address.add_new,
                          style: const TextStyle(
                              color: Const.aqua, fontWeight: FontWeight.w600),
                        ),
                        onTap: _openAddNewAddress,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _fetchProfessionals({String query = ''}) {
    context.read<ProfessionalBloc>().add(
          GetProfessionalsEvent(
            widget.role,
            name: query,
            serviceIds: widget.serviceIds,
            isHomeScreeningAuthorized: widget.isHomeScreeningAuthorized,
            serviceSubCategory: widget.serviceSubCategory,
            latitude: _selectedAddress?.latitude,
            longitude: _selectedAddress?.longitude,
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
        leading: widget.leading,
        title: Text(
          getTitle(context, widget.role),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
              bloc: _addressesCubit,
              builder: (context, state) {
                return VisitAddressBar(
                  selectedAddress: _selectedAddress,
                  isLoading: state is SavedAddressesLoading || state is SavedAddressesInitial,
                  onTap: _showAddressPicker,
                );
              },
            ),
            const SizedBox(height: 16),
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
