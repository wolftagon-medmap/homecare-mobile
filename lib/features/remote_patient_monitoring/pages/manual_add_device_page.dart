import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';
import 'package:m2health/features/remote_patient_monitoring/models/device_model.dart';
import 'package:m2health/features/remote_patient_monitoring/static/devices_data.dart';
import 'package:collection/collection.dart';

class ManualAddDevicePage extends StatefulWidget {
  const ManualAddDevicePage({super.key});

  @override
  State<ManualAddDevicePage> createState() => _ManualAddDevicePageState();
}

class _ManualAddDevicePageState extends State<ManualAddDevicePage> {
  String _searchQuery = '';
  VitalCategory? _selectedCategory; // Null represents "All devices"

  @override
  Widget build(BuildContext context) {
    const allDevices = DevicesData.allDevices;

    final filteredDevices = allDevices.where((device) {
      final matchesSearch =
          device.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          device.supportedVitals.contains(_selectedCategory);
      return matchesSearch && matchesCategory;
    }).toList();

    // Group devices by brand
    final devicesByBrand =
        groupBy(filteredDevices, (Device d) => d.brandDisplayName);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Manually',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search device',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFA3A3A3)),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Const.aqua),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<VitalCategory?>(
                value: _selectedCategory,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Const.tosca),
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: [
                  const DropdownMenuItem<VitalCategory?>(
                    value: null,
                    child: Text("All devices"),
                  ),
                  ...VitalCategory.values.map((category) {
                    return DropdownMenuItem<VitalCategory?>(
                      value: category,
                      child: Text(category.displayName(context)),
                    );
                  }),
                ],
                onChanged: (VitalCategory? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: devicesByBrand.length,
              itemBuilder: (context, index) {
                final brand = devicesByBrand.keys.elementAt(index);
                final devices = devicesByBrand[brand]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: devices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _DeviceListItem(device: devices[index]);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceListItem extends StatelessWidget {
  final Device device;

  const _DeviceListItem({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  device.imageUrl,
                  fit: BoxFit.contain,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.device_hub, color: Colors.grey);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA3A3A3),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFA3A3A3),
          ),
        ],
      ),
    );
  }
}
