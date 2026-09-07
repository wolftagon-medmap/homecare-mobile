import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeLayoutLocalDatasource {
  Future<HomeServicesLayout?> read();
  Future<void> write(HomeServicesLayout layout);
}

class HomeLayoutLocalDatasourceImpl implements HomeLayoutLocalDatasource {
  final SharedPreferences prefs;

  HomeLayoutLocalDatasourceImpl({required this.prefs});

  static const _key = 'home_services_layout';

  @override
  Future<HomeServicesLayout?> read() async {
    final saved = prefs.getString(_key);
    if (saved == null) return null;
    for (final layout in HomeServicesLayout.values) {
      if (layout.name == saved) return layout;
    }
    return null;
  }

  @override
  Future<void> write(HomeServicesLayout layout) async {
    await prefs.setString(_key, layout.name);
  }
}
