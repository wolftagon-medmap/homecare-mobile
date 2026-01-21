part of 'bluetooth_scan_cubit.dart';

enum ScanStatus { initial, scanning, completed, failed }

class BluetoothScanState extends Equatable {
  final BluetoothAdapterState adapterState;
  final ScanStatus scanStatus;
  final List<ScanResult> foundDevices;
  final VitalCategory vitalCategory;

  const BluetoothScanState({
    this.adapterState = BluetoothAdapterState.unknown,
    this.scanStatus = ScanStatus.initial,
    this.foundDevices = const [],
    required this.vitalCategory,
  });

  BluetoothScanState copyWith({
    BluetoothAdapterState? adapterState,
    ScanStatus? scanStatus,
    List<ScanResult>? foundDevices,
    VitalCategory? vitalCategory,
  }) {
    return BluetoothScanState(
      adapterState: adapterState ?? this.adapterState,
      scanStatus: scanStatus ?? this.scanStatus,
      foundDevices: foundDevices ?? this.foundDevices,
      vitalCategory: vitalCategory ?? this.vitalCategory,
    );
  }

  @override
  List<Object?> get props => [adapterState, scanStatus, foundDevices, vitalCategory];
}
