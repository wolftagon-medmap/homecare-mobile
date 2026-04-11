import 'package:flutter/material.dart';
import 'package:m2health/features/profiles/data/datasources/countries_remote_datasource.dart';
import 'package:m2health/features/profiles/data/models/country_model.dart';
import 'package:m2health/service_locator.dart';

class CountryPickerField extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String labelText;

  const CountryPickerField({
    super.key,
    this.value,
    required this.onChanged,
    this.labelText = 'Country',
  });

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  List<CountryModel> _countries = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await sl<CountriesRemoteDatasource>().fetchCountries();
      if (!mounted) return;
      setState(() {
        _countries = list;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Could not load countries. Check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_error!,
              style: const TextStyle(color: Colors.red, fontSize: 13)),
          TextButton(
            onPressed: _loadCountries,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return DropdownMenu<String>(
      expandedInsets: EdgeInsets.zero,
      initialSelection: widget.value,
      label: Text(widget.labelText, style: const TextStyle(fontSize: 14)),
      enableSearch: true,
      enableFilter: true,
      textStyle: const TextStyle(fontSize: 14),
      menuHeight: 300,
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onSelected: widget.onChanged,
      dropdownMenuEntries: _countries
          .map(
            (c) => DropdownMenuEntry<String>(
              value: c.code,
              label: c.name,
            ),
          )
          .toList(),
    );
  }
}
