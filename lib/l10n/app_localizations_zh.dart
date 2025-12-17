// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tab_home => '首页';

  @override
  String get services => '服务';

  @override
  String get allied_services => '辅助医疗';

  @override
  String get pharmacist_services => 'iRX 药师服务';

  @override
  String get nursing_service => '居家护理';

  @override
  String get diabetic_care_service => '糖尿病护理';

  @override
  String get home_screening_service => '居家健康筛查';

  @override
  String get precision_nutrition_service => '精准营养';

  @override
  String get homecare_for_elderly_service => '长者居家护理';

  @override
  String get physiotherapy_service => '物理治疗';

  @override
  String get remote_patient_monitoring_service => '远程健康监测';

  @override
  String get second_opinion_service => '医学影像第二意见';

  @override
  String get health_risk_assessment_service => '健康风险评估';

  @override
  String get dietitian_service => '营养师服务';

  @override
  String get sleep_and_mental_health_service => '睡眠与心理健康';

  @override
  String dashboard_greeting(String displayName) {
    return '更长寿，更健康，$displayName！';
  }

  @override
  String get dashboard_chat_ai_placeholder => '咨询AI医生，解答您的健康疑问';
}
