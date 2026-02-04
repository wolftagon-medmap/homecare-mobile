import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2health/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userName;
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    context.read<ProfileCubit>().loadProfile();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isScrolledToEnd = true;
          });
        } else {
          setState(() {
            _isScrolledToEnd = false;
          });
        }
      });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'User';
    });
    debugPrint('Username loaded: $userName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        elevation: 2,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8EF4E8),
                Color(0xFF35C5CF)
              ], // Gradasi warna dari kiri ke kanan
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom:
                  Radius.circular(30), // Membuat border radius di bagian bawah
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna shadow
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Posisi shadow
              ),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              Widget avatarWidget;
              String displayName = userName ?? 'User';
              String? avatarUrl;

              if (state is PatientProfileLoaded) {
                displayName = state.profile.name.isNotEmpty
                    ? state.profile.name
                    : userName ?? 'User';
                avatarUrl = state.profile.avatar;
              } else if (state is ProfessionalProfileLoaded) {
                displayName =
                    state.profile.name != null && state.profile.name!.isNotEmpty
                        ? state.profile.name!
                        : userName ?? 'User';
                avatarUrl = state.profile.avatar;
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
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
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
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Default avatar
                avatarWidget = Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
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
                      GestureDetector(
                        onTap: () {
                          context.go(AppRoutes.profile);
                        },
                        child: Container(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (state is ProfileLoading) ...[
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_doctor.png',
                          width: 24,
                          height: 24,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: context.t.dashboard.chat_ai_placeholder,
                              hintStyle: const TextStyle(
                                  color: Color(0xFF8A96BC), fontSize: 11),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
        color: Colors.white,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // MAIN SERVICES
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 24, left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.dashboard.main_services,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF232F55),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.pharmaServices);
                          },
                          iconPath: 'assets/icons/ic_pharma_service.png',
                          title: context.t.dashboard.services.pharmacist,
                          backgroundColor:
                              const Color.fromRGBO(142, 244, 220, 0.4),
                        ),
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.nursingServices);
                          },
                          iconPath: 'assets/icons/ic_nurse.png',
                          title: context.t.dashboard.services.nursing,
                          backgroundColor:
                              const Color.fromRGBO(154, 225, 255, 0.35),
                        ),
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.diabeticCare);
                          },
                          iconPath: 'assets/icons/ic_diabetic.png',
                          title: context.t.dashboard.services.diabetic_care,
                          backgroundColor:
                              const Color.fromRGBO(142, 244, 220, 0.4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.homeHealthScreening);
                          },
                          iconPath: 'assets/icons/ic_home_health_screening.png',
                          title: context.t.dashboard.services.home_screening,
                          backgroundColor:
                              const Color.fromRGBO(178, 140, 255, 0.2),
                        ),
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.precisionNutrition);
                          },
                          iconPath: 'assets/icons/ic_precision_nutrition.webp',
                          title:
                              context.t.dashboard.services.precision_nutrition,
                          backgroundColor:
                              const Color.fromRGBO(154, 225, 255, 0.33),
                        ),
                        MainServiceMenuItem(
                          onTap: () {
                            context.push(AppRoutes.homecareForElderly);
                          },
                          iconPath: 'assets/icons/ic_homecare_elderly.png',
                          title:
                              context.t.dashboard.services.homecare_for_elderly,
                          backgroundColor:
                              const Color.fromRGBO(178, 140, 255, 0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Color.fromRGBO(244, 244, 244, 1),
                      thickness: 8,
                    ),
                  ),
                ],
              ),

              // ALLIED HEALTH SERVICES
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, right: 24, left: 24, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.dashboard.allied_services,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF232F55),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AlliedHealthMenuItem(
                            imagePath: 'assets/icons/ilu_physio.webp',
                            label: context.t.dashboard.services.physiotherapy,
                            onTap: () {
                              context.push(AppRoutes.physiotherapy);
                            },
                          ),
                        ),
                        Expanded(
                          child: AlliedHealthMenuItem(
                            imagePath: 'assets/icons/ilu_remote_monitoring.png',
                            label: context
                                .t.dashboard.services.remote_patient_monitoring,
                            onTap: () {
                              context.push(AppRoutes.remotePatientMonitoring);
                            },
                          ),
                        ),
                        Expanded(
                          child: AlliedHealthMenuItem(
                            imagePath: 'assets/icons/ilu_2nd_opinion.webp',
                            label: context.t.dashboard.services.second_opinion,
                            onTap: () {
                              context.push(AppRoutes.secondOpinionMedical);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(
                    //       child: AlliedHealthMenuItem(
                    //         imagePath: 'assets/icons/ilu_health.png',
                    //         label: context
                    //             .t.dashboard.services.health_risk_assessment,
                    //         onTap: showComingSoonDialog,
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: AlliedHealthMenuItem(
                    //         imagePath: 'assets/icons/ilu_dietitian.webp',
                    //         label: context.t.dashboard.services.dietitian,
                    //         onTap: showComingSoonDialog,
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: AlliedHealthMenuItem(
                    //         imagePath: 'assets/icons/ilu_sleep.png',
                    //         label: context
                    //             .t.dashboard.services.sleep_and_mental_health,
                    //         onTap: showComingSoonDialog,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(context.t.global.dialog.coming_soon),
          content: Text(context.t.global.dialog.feature_available_soon),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t.global.ok,
                  style: const TextStyle(color: Const.aqua)),
            ),
          ],
        );
      },
    );
  }
}

class MainServiceMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MainServiceMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: const Color.fromRGBO(247, 248, 248, 1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                // height: 13.25 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlliedHealthMenuItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const AlliedHealthMenuItem({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(247, 248, 248, 1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  height: 72,
                  width: 111,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
