import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';

part 'bluetooth_scan_state.dart';

class BluetoothScanCubit extends Cubit<BluetoothScanState> {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  BluetoothScanCubit({required VitalCategory vitalCategory})
      : super(BluetoothScanState(vitalCategory: vitalCategory)) {
    _init();
  }

  void _init() {
    if (Platform.isAndroid) {
      FlutterBluePlus.turnOn();
    }
    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((adapterState) {
      emit(state.copyWith(adapterState: adapterState));
      if (adapterState == BluetoothAdapterState.on) {
        startScan();
      } else {
        stopScan();
        // Reset found devices when Bluetooth is off
        emit(state.copyWith(foundDevices: [], scanStatus: ScanStatus.initial));
      }
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      emit(state.copyWith(foundDevices: results));
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((isScanning) {
      if (!isScanning && state.scanStatus == ScanStatus.scanning) {
        // If we were scanning and it stopped, mark as completed
        emit(state.copyWith(scanStatus: ScanStatus.completed));
      }
    });
  }

  Future<void> startScan() async {
    if (state.adapterState != BluetoothAdapterState.on) return;

    try {
      emit(state.copyWith(scanStatus: ScanStatus.scanning, foundDevices: []));

      // Stop any existing scan
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      await FlutterBluePlus.startScan(
        withServices: state.vitalCategory.serviceUuids,
        timeout: const Duration(seconds: 15),
      );
    } catch (e) {
      emit(state.copyWith(scanStatus: ScanStatus.failed));
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      emit(state.copyWith(scanStatus: ScanStatus.completed));
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<void> close() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
    stopScan();
    return super.close();
  }
}
