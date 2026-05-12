import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';

// ── State ──────────────────────────────────────────────────────────────────

sealed class AdminServicesState extends Equatable {
  const AdminServicesState();
  @override
  List<Object> get props => [];
}

class AdminServicesInitial extends AdminServicesState {}

class AdminServicesLoading extends AdminServicesState {}

class AdminServicesLoaded extends AdminServicesState {
  final List<ServiceEntity> services;
  const AdminServicesLoaded(this.services);
  @override
  List<Object> get props => [services];
}

class AdminServicesError extends AdminServicesState {
  final String message;
  const AdminServicesError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────

class AdminServicesCubit extends Cubit<AdminServicesState> {
  final Dio _dio = sl<Dio>();
  String _category;

  AdminServicesCubit(this._category) : super(AdminServicesInitial()) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Utils.getSpString(Const.TOKEN);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  void setCategory(String category) {
    _category = category;
    fetchServices();
  }

  Future<void> fetchServices() async {
    emit(AdminServicesLoading());
    try {
      final response = await _dio.get(
        Const.API_SERVICES,
        queryParameters: {'category': _category},
      );
      final services = (response.data as List)
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(AdminServicesLoaded(services));
    } catch (e) {
      emit(AdminServicesError('Failed to fetch services: $e'));
    }
  }

  Future<void> addService({
    required String name,
    required double price,
    String? subCategory,
    String? pricingModel,
    int? durationMinutes,
    String? code,
    bool isPublished = false,
  }) async {
    try {
      await _dio.post(
        Const.API_ADMIN_SERVICES,
        data: {
          'name': name,
          'category': _category,
          'price': price,
          if (subCategory != null) 'sub_category': subCategory,
          if (pricingModel != null) 'pricing_model': pricingModel,
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (code != null) 'code': code,
          'is_published': isPublished,
        },
      );
      fetchServices();
    } catch (e) {
      emit(AdminServicesError('Failed to add service: $e'));
    }
  }

  Future<void> updateService({
    required int id,
    required String name,
    required double price,
    String? subCategory,
    String? pricingModel,
    int? durationMinutes,
    String? code,
    bool isPublished = false,
  }) async {
    try {
      await _dio.put(
        '${Const.API_ADMIN_SERVICES}/$id',
        data: {
          'name': name,
          'category': _category,
          'price': price,
          if (subCategory != null) 'sub_category': subCategory,
          if (pricingModel != null) 'pricing_model': pricingModel,
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (code != null) 'code': code,
          'is_published': isPublished,
        },
      );
      fetchServices();
    } catch (e) {
      emit(AdminServicesError('Failed to update service: $e'));
    }
  }

  Future<void> deleteService(int id) async {
    try {
      await _dio.delete('${Const.API_ADMIN_SERVICES}/$id');
      fetchServices();
    } catch (e) {
      emit(AdminServicesError('Failed to delete service: $e'));
    }
  }
}

// ── Page ───────────────────────────────────────────────────────────────────

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  static const _categories = [
    ('nursing', 'Nursing'),
    ('pharmacy', 'Pharmacy'),
    ('homecare_elderly', 'Homecare Elderly'),
    ('physiotherapy', 'Physiotherapy'),
    ('screening', 'Screening'),
    ('second_opinion_imaging', 'Second Opinion Imaging'),
    ('nutrition', 'Nutrition'),
  ];

  late AdminServicesCubit _cubit;
  String _selectedCategory = _categories[0].$1;

  @override
  void initState() {
    super.initState();
    _cubit = AdminServicesCubit(_selectedCategory)..fetchServices();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Services',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.$1,
                    child: Text(cat.$2),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                    _cubit.setCategory(value);
                  }
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<AdminServicesCubit, AdminServicesState>(
                listener: (context, state) {
                  if (state is AdminServicesError) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ));
                  }
                },
                builder: (context, state) {
                  if (state is AdminServicesLoading ||
                      state is AdminServicesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdminServicesError) {
                    return RefreshIndicator(
                      onRefresh: () async => _cubit.fetchServices(),
                      child: ListView(
                        children: [
                          Center(
                            child: Text(state.message,
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is AdminServicesLoaded) {
                    if (state.services.isEmpty) {
                      return const Center(
                          child: Text('No services found for this category.'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _cubit.fetchServices(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          return _ServiceCard(service: state.services[index]);
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showServiceFormModal(context),
          tooltip: 'Add Service',
          foregroundColor: Colors.white,
          backgroundColor: Const.aqua,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showServiceFormModal(BuildContext context, {ServiceEntity? service}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: _ServiceFormModal(service: service),
      ),
    );
  }
}

// ── Service Card ───────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  final ServiceEntity service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Text(service.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${service.price.toStringAsFixed(2)}'),
            if (service.pricingModel != null)
              Text('Model: ${service.pricingModel}',
                  style: const TextStyle(fontSize: 12)),
            if (service.code != null)
              Text('Code: ${service.code}',
                  style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (service.isPublished == true)
              const Icon(Icons.visibility, color: Colors.green, size: 18)
            else
              const Icon(Icons.visibility_off, color: Colors.grey, size: 18),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.edit, color: Const.aqua),
              onPressed: () => _showEditModal(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${service.name}"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<AdminServicesCubit>().deleteService(service.id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<AdminServicesCubit>(context),
        child: _ServiceFormModal(service: service),
      ),
    );
  }
}

// ── Service Form Modal ─────────────────────────────────────────────────────

class _ServiceFormModal extends StatefulWidget {
  final ServiceEntity? service;
  const _ServiceFormModal({this.service});

  @override
  State<_ServiceFormModal> createState() => _ServiceFormModalState();
}

class _ServiceFormModalState extends State<_ServiceFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _subCategoryController;
  late TextEditingController _durationController;
  late TextEditingController _codeController;
  String _pricingModel = 'per_item';
  bool _isPublished = false;

  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _nameController = TextEditingController(text: s?.name ?? '');
    _priceController = TextEditingController(text: s?.price.toString() ?? '');
    _subCategoryController = TextEditingController(text: s?.subCategory ?? '');
    _durationController =
        TextEditingController(text: s?.durationMinutes?.toString() ?? '');
    _codeController = TextEditingController(text: s?.code ?? '');
    _pricingModel = s?.pricingModel ?? 'per_item';
    _isPublished = s?.isPublished ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _subCategoryController.dispose();
    _durationController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final subCategory = _subCategoryController.text.trim().isEmpty
        ? null
        : _subCategoryController.text.trim();
    final duration = int.tryParse(_durationController.text);
    final code = _codeController.text.trim().isEmpty
        ? null
        : _codeController.text.trim();

    if (_isEditing) {
      context.read<AdminServicesCubit>().updateService(
            id: widget.service!.id,
            name: name,
            price: price,
            subCategory: subCategory,
            pricingModel: _pricingModel,
            durationMinutes: duration,
            code: code,
            isPublished: _isPublished,
          );
    } else {
      context.read<AdminServicesCubit>().addService(
            name: name,
            price: price,
            subCategory: subCategory,
            pricingModel: _pricingModel,
            durationMinutes: duration,
            code: code,
            isPublished: _isPublished,
          );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Edit Service' : 'Add New Service',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Price is required';
                  if (double.tryParse(v) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _pricingModel,
                decoration: const InputDecoration(
                  labelText: 'Pricing Model',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'per_item', child: Text('Per Item')),
                  DropdownMenuItem(
                      value: 'per_package', child: Text('Per Package')),
                  DropdownMenuItem(
                      value: 'hourly_rate', child: Text('Hourly Rate')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _pricingModel = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Sub Category (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes, optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Published'),
                value: _isPublished,
                onChanged: (v) => setState(() => _isPublished = v),
                activeColor: Const.aqua,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                ),
                child: Text(_isEditing ? 'Save Changes' : 'Add Service'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
