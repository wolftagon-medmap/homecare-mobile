import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/dashboard/presentation/bloc/home_services_cubit.dart';
import 'package:m2health/features/dashboard/presentation/widgets/home_services_section.dart';
import 'package:m2health/features/dashboard/presentation/widgets/notification_bell.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';
import 'package:m2health/features/profiles/presentation/widgets/profile_switcher_sheet.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  late final NotificationsCubit _notifications;

  // Which cubit is authoritative for the header, resolved once from the
  // logged-in role. Explicit (not inferred from "whichever cubit happens to
  // have a Loaded state") so a stale Loaded state left over in the other
  // cubit from a previous account/role never gets shown.
  bool? _isProfessional;

  /// Only patients pick which profile the app acts for — admins and
  /// professionals have no family profiles to switch between.
  bool _isPatient = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadProfileForRole();
    _notifications = NotificationsCubit(sl<Dio>())..load();
  }

  @override
  void dispose() {
    _notifications.close();
    super.dispose();
  }

  void _openNotificationInbox() {
    // Refresh so anything that arrived while away is present on open. The
    // cubit rides along as `extra` so the inbox shares the badge state.
    _notifications.load();
    GoRouter.of(context)
        .push(AppRoutes.notificationInbox, extra: _notifications);
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'User';
    });
  }

  // Loads the header's name/avatar from the cubit matching the account's
  // role (mirrors the role check the unified ProfileCubit used to do
  // internally, now resolved here since the cubit is split by role).
  Future<void> _loadProfileForRole() async {
    final role = await Utils.getSpString(Const.ROLE);
    if (!mounted) return;
    final isProfessional =
        role != null && PROFESSIONAL_ROLES.map((r) => r.value).contains(role);
    setState(() {
      _isProfessional = isProfessional;
      // Admin isn't in PROFESSIONAL_ROLES but has no family profiles either,
      // so "not professional" is not the same as "patient" here.
      _isPatient = !isProfessional && role != 'admin';
    });
    if (isProfessional) {
      context.read<ProfessionalProfileCubit>().loadProfile();
    } else {
      context.read<PatientProfileCubit>().loadProfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeServicesCubit>()..restore(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 180,
          elevation: 2,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8EF4E8), Color(0xFF35C5CF)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: BlocBuilder<PatientProfileCubit, PatientProfileState>(
              builder: (context, patientState) {
                return BlocBuilder<ProfessionalProfileCubit,
                    ProfessionalProfileState>(
                  builder: (context, professionalState) {
                    Widget avatarWidget;
                    String displayName = userName ?? 'User';
                    String? avatarUrl;

                    if (_isProfessional == false &&
                        patientState is PatientProfileLoaded) {
                      // The header follows the active profile, so switching to
                      // a family member is reflected here too.
                      final activeProfile = patientState.activeProfile;
                      displayName = activeProfile.name.isNotEmpty
                          ? activeProfile.name
                          : userName ?? 'User';
                      avatarUrl = activeProfile.avatar;
                    } else if (_isProfessional == true &&
                        professionalState is ProfessionalProfileLoaded) {
                      displayName = professionalState.profile.name != null &&
                              professionalState.profile.name!.isNotEmpty
                          ? professionalState.profile.name!
                          : userName ?? 'User';
                      avatarUrl = professionalState.profile.avatar;
                    } else {
                      displayName = userName ?? 'User';
                      avatarUrl = null;
                    }

                    if (avatarUrl != null && avatarUrl.isNotEmpty) {
                      avatarWidget = Image.network(
                        avatarUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.grey),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: 56,
                            height: 56,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      avatarWidget = Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.grey),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Const.banner,
                              fit: BoxFit.contain,
                              height: 36,
                            ),
                            const Spacer(),
                            NotificationBell(
                              cubit: _notifications,
                              onTap: _openNotificationInbox,
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (_isPatient) {
                                  showProfileSwitcherSheet(context);
                                } else {
                                  context.go(AppRoutes.profile);
                                }
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: avatarWidget,
                                    ),
                                  ),
                                  if (_isPatient)
                                    Positioned(
                                      right: -2,
                                      top: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                        ),
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16,
                                          color: Const.aqua,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              if ((_isProfessional == false &&
                                      patientState is PatientProfileLoading) ||
                                  (_isProfessional == true &&
                                      professionalState
                                          is ProfessionalProfileLoading)) ...[
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Loading...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else
                                Expanded(
                                  child: Text(
                                    context.t.dashboard
                                        .greeting(displayName: displayName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(AppRoutes.intakeBooking);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 9, 9, 9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_ai_robot.svg',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    context.t.dashboard.chat_ai_placeholder,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF7C8AA5),
                                      fontSize: 11,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF038E9F),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
          color: Colors.white,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                HomeServicesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
