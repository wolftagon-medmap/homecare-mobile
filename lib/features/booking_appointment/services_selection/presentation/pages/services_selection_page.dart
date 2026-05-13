import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/services_selection/presentation/bloc/services_selection_cubit.dart';
import 'package:m2health/features/booking_appointment/services_selection/presentation/bloc/services_selection_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

class ServicesSelectionPage extends StatelessWidget {
  final String serviceCategory;
  final String? serviceSubCategory;
  final Function(List<ServiceEntity>) onComplete;
  final List<ServiceEntity>? initialSelectedServices;

  const ServicesSelectionPage({
    super.key,
    required this.serviceCategory,
    this.serviceSubCategory,
    required this.onComplete,
    this.initialSelectedServices,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesSelectionCubit(
        sl(),
        initialSelectedServices: initialSelectedServices ?? [],
      ),
      child: ServicesSelectionView(
        serviceCategory: serviceCategory,
        serviceSubCategory: serviceSubCategory,
        onComplete: onComplete,
      ),
    );
  }
}

class ServicesSelectionView extends StatefulWidget {
  final String serviceCategory;
  final String? serviceSubCategory;
  final Function(List<ServiceEntity>) onComplete;

  const ServicesSelectionView({
    super.key,
    required this.serviceCategory,
    this.serviceSubCategory,
    required this.onComplete,
  });

  @override
  State<ServicesSelectionView> createState() => ServicesSelectionViewState();
}

class ServicesSelectionViewState extends State<ServicesSelectionView> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesSelectionCubit>().loadServices(
          category: widget.serviceCategory,
          subCategory: widget.serviceSubCategory,
        );
  }

  @override
  Widget build(BuildContext context) {
    String getTitle(BuildContext context, String serviceCategory,
        {String? subCategory}) {
      if (serviceCategory.toLowerCase() == 'nursing') {
        if (subCategory != null && subCategory.toLowerCase() == 'specialized') {
          return context.t.booking.addon.title.specialized_nursing;
        } else {
          return context.t.booking.addon.title.nursing;
        }
      } else if (serviceCategory.toLowerCase() == 'pharmacy') {
        return context.t.booking.addon.title.pharmacy;
      } else {
        return context.t.booking.addon.title.kDefault;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            getTitle(context, widget.serviceCategory,
                subCategory: widget.serviceSubCategory),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _buildAddOnList(context),
              ),
              const SizedBox(height: 10),
              _buildBudgetSection(context),
              const SizedBox(height: 10),
              _buildBookButton(context),
            ],
          ),
        ));
  }

  Widget _buildAddOnList(BuildContext context) {
    Future<void> refreshAddOnServices() async {
      context.read<ServicesSelectionCubit>().loadServices(
            category: widget.serviceCategory,
            subCategory: widget.serviceSubCategory,
          );
    }

    return RefreshIndicator(
      onRefresh: refreshAddOnServices,
      child: BlocBuilder<ServicesSelectionCubit, ServicesSelectionState>(
        builder: (context, state) {
          if (state.status == ServicesSelectionStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ServicesSelectionStateStatus.error) {
            return Center(
                child: Text(state.errorMessage ?? "Unexpected error occurred"));
          }

          if (state.status == ServicesSelectionStateStatus.loaded) {
            if (state.services.isEmpty) {
              return Center(child: Text(context.t.booking.addon.empty));
            }

            final availableServices = state.services;
            return ListView.builder(
              itemCount: availableServices.length,
              itemBuilder: (context, index) {
                final service = availableServices[index];
                final isSelected =
                    state.selectedServices.any((s) => s.id == service.id);

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        context
                            .read<ServicesSelectionCubit>()
                            .toggleAddOnServiceSelection(service);
                      },
                      activeColor: const Color(0xFF35C5CF),
                    ),
                    title: Text(
                      service.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF35C5CF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.info_outline_rounded,
                        color: Colors.grey),
                  ),
                );
              },
            );
          }

          // Fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBudgetSection(BuildContext context) {
    final estimatedBudget =
        context.watch<ServicesSelectionCubit>().state.estimatedBudget;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.t.booking.addon.estimated_budget,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${estimatedBudget.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    final state = context.watch<ServicesSelectionCubit>().state;
    final isButtonEnabled = state.selectedServices.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isButtonEnabled
            ? () => widget.onComplete(state.selectedServices)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          context.t.booking.book_appointment,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
