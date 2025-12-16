import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/features/subscription/data/models/subscription_plan_model.dart';
import 'package:m2health/features/subscription/data/models/user_subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<List<UserSubscriptionModel>> getUserSubscriptions();
  Future<UserSubscriptionModel> purchaseSubscription(int planId);
  
  // Admin
  Future<SubscriptionPlanModel> createSubscriptionPlan(Map<String, dynamic> body);
  Future<SubscriptionPlanModel> updateSubscriptionPlan(int id, Map<String, dynamic> body);
  Future<SubscriptionPlanModel> toggleSubscriptionPlanActive(int id);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio dio;

  SubscriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    final token = await Utils.getSpString(Const.TOKEN);
    
    final options = token != null && token.isNotEmpty
        ? Options(headers: {'Authorization': 'Bearer $token'})
        : null;

    final response = await dio.get(
      Const.API_SUBSCRIPTIONS_PLANS,
      options: options,
    );

    final data = response.data['data'] as List;
    return data.map((json) => SubscriptionPlanModel.fromJson(json)).toList();
  }

  @override
  Future<List<UserSubscriptionModel>> getUserSubscriptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_SUBSCRIPTIONS_ME,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final data = response.data['data'] as List;
    return data.map((json) => UserSubscriptionModel.fromJson(json)).toList();
  }

  @override
  Future<UserSubscriptionModel> purchaseSubscription(int planId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.post(
      Const.API_SUBSCRIPTIONS_PURCHASE,
      data: {'plan_id': planId},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    // Response structure: { message: '...', data: subscription }
    final data = response.data['data'];
    return UserSubscriptionModel.fromJson(data);
  }

  @override
  Future<SubscriptionPlanModel> createSubscriptionPlan(Map<String, dynamic> body) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.post(
      Const.API_ADMIN_SUBSCRIPTIONS,
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return SubscriptionPlanModel.fromJson(response.data['data']);
  }

  @override
  Future<SubscriptionPlanModel> updateSubscriptionPlan(int id, Map<String, dynamic> body) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.put(
      '${Const.API_ADMIN_SUBSCRIPTIONS}/$id',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return SubscriptionPlanModel.fromJson(response.data['data']);
  }

  @override
  Future<SubscriptionPlanModel> toggleSubscriptionPlanActive(int id) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.patch(
      '${Const.API_ADMIN_SUBSCRIPTIONS}/$id/toggle-active',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return SubscriptionPlanModel.fromJson(response.data['data']);
  }
}
