import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/buttons/button_size.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/core/presentation/widgets/buttons/secondary_button.dart';
import 'package:m2health/features/remote_patient_monitoring/cubit/bluetooth_scan_cubit.dart';
import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';
import 'package:m2health/route/app_routes.dart';

class BluetoothSearchDevicePage extends StatelessWidget {
  final VitalCategory vitalCategory;

  const BluetoothSearchDevicePage({super.key, required this.vitalCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BluetoothScanCubit(vitalCategory: vitalCategory),
      child: const _BluetoothSearchDeviceView(),
    );
  }
}

class _BluetoothSearchDeviceView extends StatelessWidget {
  const _BluetoothSearchDeviceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monitor My Vitals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BluetoothScanCubit, BluetoothScanState>(
        builder: (context, state) {
          final isBluetoothOn = state.adapterState == BluetoothAdapterState.on;
          final isScanning = state.scanStatus == ScanStatus.scanning;
          final isCompleted = state.scanStatus == ScanStatus.completed;

          String mainText;
          String subText;

          if (!isBluetoothOn) {
            mainText = "Not scanning";
            subText = "Enable Bluetooth first";
          } else if (isScanning) {
            mainText = "Scanning...";
            subText = "Searching for available devices";
          } else if (isCompleted) {
            mainText = "Scan completed";
            subText = "Device not found? Try again.";
          } else {
            mainText = "Initializing...";
            subText = "Please wait";
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: (constraints.maxHeight * 0.6)
                        .clamp(300.0, double.infinity),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (isBluetoothOn && isScanning)
                          _RippleAnimation(vitalCategory: state.vitalCategory)
                        else
                          _StaticIcon(vitalCategory: state.vitalCategory),
                        const SizedBox(height: 24),
                        Text(
                          mainText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500, // Poppins Medium
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA3A3A3),
                          ),
                        ),
                        if (!isBluetoothOn && Platform.isAndroid) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await FlutterBluePlus.turnOn();
                              } catch (e) {
                                // ignore
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Const.aqua,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Turn On Bluetooth"),
                          ),
                        ],
                        if (isCompleted && isBluetoothOn) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              context.read<BluetoothScanCubit>().startScan();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Const.aqua,
                            ),
                            label: const Text(
                              "Retry",
                              style: TextStyle(color: Const.aqua),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.foundDevices.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.foundDevices.length,
                            itemBuilder: (context, index) {
                              final device = state.foundDevices[index].device;
                              return ListTile(
                                title: Text(device.platformName.isNotEmpty
                                    ? device.platformName
                                    : "Unknown Device"),
                                subtitle: Text(device.remoteId.toString()),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Handle Link Logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Const.aqua,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Link"),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                size: ButtonSize.medium,
                text: "Add Manually",
                onPressed: () {
                  // GoRouter.of(context)
                  //     .pushNamed(AppRoutes.monitoringSupportedDevices);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SecondaryButton(
                size: ButtonSize.medium,
                text: "Scan Code",
                onPressed: () {
                  // GoRouter.of(context).pushNamed(AppRoutes.monitoringScanDevice);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticIcon extends StatelessWidget {
  final VitalCategory vitalCategory;
  const _StaticIcon({required this.vitalCategory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 270,
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SvgPicture.asset(
            vitalCategory.iconPath,
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _RippleAnimation extends StatefulWidget {
  final VitalCategory vitalCategory;
  const _RippleAnimation({required this.vitalCategory});

  @override
  State<_RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 270,
      child: CustomPaint(
        painter: _RipplePainter(_controller),
        child: Center(
          child: Container(
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SvgPicture.asset(
              widget.vitalCategory.iconPath,
              width: 40,
              height: 40,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> animation;

  _RipplePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Const.aqua;

    // Draw 3 expanding rings
    for (int i = 0; i < 3; i++) {
      // Stagger the animations
      final progress = (animation.value + (i / 3)) % 1.0;
      // Opacity fades out as it expands
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      // Radius expands from a base size to max size
      // Base size should be larger than the white circle (approx 45 radius)
      final radius = 45.0 + (maxRadius - 45.0) * progress;

      paint.color =
          Const.aqua.withValues(alpha: opacity * 0.5); // Adjust max opacity
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
