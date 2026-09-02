import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class NutritionBookingFlowPage extends StatefulWidget {
  const NutritionBookingFlowPage({super.key});

  @override
  State<NutritionBookingFlowPage> createState() =>
      _NutritionBookingFlowPageState();
}

class _NutritionBookingFlowPageState extends State<NutritionBookingFlowPage> {
  late final ProfessionalBloc _professionalBloc;
  late final ProfessionalDetailCubit _professionalDetailCubit;
  late final ScheduleAppointmentCubit _scheduleAppointmentCubit;

  bool _showDetail = false;
  bool _showSchedule = false;

  @override
  void initState() {
    super.initState();
    _professionalBloc = ProfessionalBloc(
      getProfessionals: sl(),
      toggleFavorite: sl(),
    );
    _professionalDetailCubit = ProfessionalDetailCubit(
      getProfessionalDetail: sl(),
    );
    _scheduleAppointmentCubit = ScheduleAppointmentCubit(
      getAvailableTimeSlots: sl(),
      rescheduleAppointment: sl(),
    );
  }

  @override
  void dispose() {
    _professionalBloc.close();
    _professionalDetailCubit.close();
    _scheduleAppointmentCubit.close();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (_showSchedule) {
      setState(() => _showSchedule = false);
    } else if (_showDetail) {
      setState(() {
        _showDetail = false;
        _showSchedule = false;
      });
    } else {
      context.pop();
    }
  }

  void _onDidRemovePage(Page<Object?> page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (page.key) {
        case const ValueKey('schedule'):
          setState(() => _showSchedule = false);
        case const ValueKey('detail'):
          setState(() {
            _showDetail = false;
            _showSchedule = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _professionalBloc),
        BlocProvider.value(value: _professionalDetailCubit),
        BlocProvider.value(value: _scheduleAppointmentCubit),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _handleBack(context);
        },
        child: BlocConsumer<NutritionFlowBloc, NutritionFlowState>(
          listenWhen: (prev, curr) =>
              prev.createdAppointment != curr.createdAppointment ||
              (prev.errorMessage != curr.errorMessage &&
                  curr.errorMessage != null),
          listener: (context, state) {
            if (state.createdAppointment != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nutrition appointment booked successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.goNamed(
                AppRoutes.appointmentDetail,
                extra: state.createdAppointment!.id!,
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) => Navigator(
            pages: _buildPages(state),
            onDidRemovePage: _onDidRemovePage,
          ),
        ),
      ),
    );
  }

  List<Page<Object?>> _buildPages(NutritionFlowState state) => [
        MaterialPage(
          key: const ValueKey('search'),
          child: SearchProfessionalPage(
            role: 'nutritionist',
            leading: BackButton(onPressed: () => context.pop()),
            onProfessionalSelected: (prof) {
              context
                  .read<NutritionFlowBloc>()
                  .add(NutritionFlowProfessionalSelected(prof));
              setState(() {
                _showDetail = true;
                _showSchedule = false;
              });
            },
          ),
        ),
        if (_showDetail && state.selectedProfessional != null)
          MaterialPage(
            key: const ValueKey('detail'),
            child: BlocProvider.value(
              value: _professionalDetailCubit,
              child: ProfessionalDetailsPage(
                professionalId: state.selectedProfessional!.id,
                role: 'nutritionist',
                onButtonPressed: () => setState(() => _showSchedule = true),
              ),
            ),
          ),
        if (_showSchedule && state.selectedProfessional != null)
          MaterialPage(
            key: const ValueKey('schedule'),
            child: BlocProvider.value(
              value: _scheduleAppointmentCubit,
              child: ScheduleAppointmentPage(
                data: ScheduleAppointmentPageData(
                  professional: state.selectedProfessional!,
                  serviceType: 'nutrition',
                  isSubmitting: state.isBookingAppointment,
                  onSlotSelected: (slot) => context
                      .read<NutritionFlowBloc>()
                      .add(NutritionFlowTimeSlotSelected(slot)),
                ),
              ),
            ),
          ),
      ];
}
