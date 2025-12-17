// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '确认';

  @override
  String get common_delete => '删除';

  @override
  String common_error(String message) {
    return '错误：$message';
  }

  @override
  String get common_no => '否';

  @override
  String get common_no_data => '暂无数据';

  @override
  String get common_retry => '重试';

  @override
  String get common_status => '状态';

  @override
  String get common_description => '描述';

  @override
  String get common_yes => '是';

  @override
  String get common_complete => '完成';

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

  @override
  String get appointment_title => '预约';

  @override
  String get appointment_list_title => '我的预约';

  @override
  String get appointment_status_upcoming => '即将开始';

  @override
  String get appointment_status_pending => '待处理';

  @override
  String get appointment_status_waiting_approval => '等待批准';

  @override
  String get appointment_status_accepted => '已接受';

  @override
  String get appointment_status_completed => '已完成';

  @override
  String get appointment_status_cancelled => '已取消';

  @override
  String get appointment_status_missed => '已错过';

  @override
  String appointment_list_empty(String appointment_status) {
    return '未找到$appointment_status预约。';
  }

  @override
  String get appointment_cancel_booking_btn => '取消预约';

  @override
  String get appointment_reschedule_btn => '重新安排';

  @override
  String get appointment_book_again_btn => '再次预订';

  @override
  String get appointment_rating_btn => '评价';

  @override
  String get appointment_decline_btn => '拒绝';

  @override
  String get appointment_accept_btn => '接受';

  @override
  String get appointment_mark_complete_btn => '标记为完成';

  @override
  String get appointment_screening_confirm_sample_btn => '确认样本已采集';

  @override
  String get appointment_screening_upload_report_btn => '上传报告';

  @override
  String get appointment_arrange_video_consultation => '安排视频咨询';

  @override
  String get appointment_pay_btn => '支付';

  @override
  String get appointment_detail_title => '预约详情';

  @override
  String get appointment_detail_schedule_title => '预约时间表';

  @override
  String get appointment_detail_patient_title => '患者信息';

  @override
  String get appointment_detail_lab_test_title => '实验室测试信息';

  @override
  String appointment_detail_report(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '份报告',
      one: '份报告',
      zero: '无报告',
    );
    return '$_temp0';
  }

  @override
  String get appointment_detail_requested_homecare_task => '请求的居家护理任务';

  @override
  String get appointment_detail_requested_homecare_task_empty =>
      '未请求具体的居家护理任务。';

  @override
  String get appointment_detail_patient_problem_title => '患者问题';

  @override
  String get appointment_detail_patient_problem_empty => '未提供具体问题详情。';

  @override
  String get appointment_detail_payment_title => '支付信息';

  @override
  String get appointment_detail_estimated_budget => '预计预算';

  @override
  String get appointment_detail_payment_details => '支付详情';

  @override
  String get appointment_detail_payment_date => '支付日期';

  @override
  String get appointment_detail_payment_method => '支付方式';

  @override
  String get appointment_detail_order_completed_date => '订单完成';

  @override
  String appointment_detail_total_amount(String amount) {
    return '总计：$amount';
  }

  @override
  String get appointment_detail_total_label => '总计';

  @override
  String get appointment_detail_service_requested => '请求的服务';

  @override
  String get appointment_summary => '摘要：';

  @override
  String get appointment_update_success_message => '预约更新成功';

  @override
  String get appointment_accept_success_message => '预约已接受';

  @override
  String get appointment_decline_success_message => '预约已拒绝';

  @override
  String get appointment_complete_success_message => '预约已完成';

  @override
  String get appointment_confirm_sample_success_message => '样本采集已确认';

  @override
  String get appointment_mark_report_ready_success_message => '报告已标记为准备就绪';

  @override
  String get appointment_cancel_dialog_content => '您确定要取消此预约吗？';

  @override
  String get appointment_cancel_dialog_subtitle => '您可以稍后从已取消的预约菜单中重新预订。';

  @override
  String get appointment_complete_dialog_title => '完成预约';

  @override
  String get appointment_complete_dialog_content => '将此预约标记为已完成？';

  @override
  String get appointment_accept_dialog_title => '接受预约';

  @override
  String get appointment_accept_dialog_content => '您确定要接受此预约吗？';

  @override
  String get appointment_decline_dialog_title => '您确定要拒绝此预约吗？';

  @override
  String get appointment_decline_dialog_subtitle => '此操作无法撤销。';

  @override
  String get screening_report_upload_title => '上传实验室报告';

  @override
  String get screening_report_upload_instruction => '请在标记为准备就绪之前上传所有必要的实验室报告。';

  @override
  String screening_report_uploaded_section(int count) {
    return '已上传报告 ($count)';
  }

  @override
  String get screening_report_empty => '尚未上传报告';

  @override
  String get screening_report_upload_btn => '上传新报告';

  @override
  String get screening_report_mark_ready_btn => '标记报告为准备就绪';

  @override
  String get screening_report_finalize_dialog_title => '完成报告？';

  @override
  String get screening_report_finalize_dialog_content =>
      '一旦标记为准备就绪，报告将发送给患者，您将无法再修改它们。';

  @override
  String get screening_report_finalized_message => '报告已完成';

  @override
  String get screening_report_delete_dialog_title => '删除报告？';

  @override
  String get screening_report_delete_dialog_content => '您确定要删除此报告吗？';

  @override
  String get screening_report_upload_success => '报告上传成功';

  @override
  String get screening_report_delete_success => '报告删除成功';

  @override
  String get screening_report_finalize_success => '报告已标记为准备就绪';

  @override
  String get full_name => '全名';

  @override
  String get age => '年龄';

  @override
  String age_years_old(int age) {
    return '$age 岁';
  }

  @override
  String get gender => '性别';

  @override
  String get address => '地址';

  @override
  String get weight => '体重';

  @override
  String get height => '身高';

  @override
  String get none => '无';

  @override
  String created_on(String date) {
    return '创建于：$date';
  }
}
