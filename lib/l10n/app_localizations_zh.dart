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
  String get common_save => '保存';

  @override
  String get common_saving => '正在保存...';

  @override
  String get common_modify => '修改';

  @override
  String get common_remove => '移除';

  @override
  String get common_updated_success => '更新成功';

  @override
  String get common_delete_success => '删除成功';

  @override
  String get name => '姓名';

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
  String get contact_number => '联系电话';

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

  @override
  String get last_updated => '最后更新';

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
  String get appointment => '预约';

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
  String get profile_patient_title => '我的健康档案';

  @override
  String get profile_professional_title => '个人资料';

  @override
  String get profile_not_found => '未找到个人资料';

  @override
  String get profile_professional_verified_label => '已认证';

  @override
  String get profile_professional_unverified_label => '未认证';

  @override
  String profile_verified_since_date(String date) {
    return '认证于：$date';
  }

  @override
  String get profile_patient_info_section => '资料信息';

  @override
  String get profile_patient_basic_info => '基本信息';

  @override
  String get profile_patient_medical_history_n_risk_factor => '病史与风险因素';

  @override
  String get profile_patient_lifestyle_n_selfcare => '生活方式与自我健康管理';

  @override
  String get profile_patient_physical_sign => '身体状况';

  @override
  String get profile_patient_mental_state => '心理状态';

  @override
  String get profile_patient_health_record_section => '健康记录';

  @override
  String get profile_patient_medical_record => '医疗记录';

  @override
  String get profile_patient_pharmacogenomics => '药物基因组学档案';

  @override
  String get profile_patient_wellness_genomics => '健康基因组学档案';

  @override
  String get profile_all_my_appointments => '全部预约';

  @override
  String get profile_professional_panel_section => '工作台';

  @override
  String get profile_professional_edit_profile => '编辑专业资料';

  @override
  String get profile_professional_my_services => '我的服务';

  @override
  String get profile_professional_my_schedule => '我的日程';

  @override
  String get profile_admin_panel_section => '管理后台';

  @override
  String get profile_admin_manage_services => '管理服务';

  @override
  String get profile_admin_manage_health_screening_services => '管理健康筛查服务';

  @override
  String get profile_admin_verify_professional => '专业人员审核';

  @override
  String get profile_admin_homecare_config => '居家护理配置';

  @override
  String get settings => '设置';

  @override
  String get settings_app_language => '语言设置';

  @override
  String get auth_logout => '退出登录';

  @override
  String get profile_info_title => '资料信息';

  @override
  String get profile_info_profile_image => '个人头像';

  @override
  String get profile_info_remove_image => '删除头像';

  @override
  String get profile_info_home_address => '家庭地址';

  @override
  String get profile_info_select_map_location_hint => '在地图上选择位置';

  @override
  String get profile_info_drug_allergies => '药物过敏';

  @override
  String get risk_factor_title => '病史与风险因素';

  @override
  String get medical_record_title => '医疗记录';

  @override
  String get medical_record_empty => '未找到医疗记录。';

  @override
  String get medical_record_confirm_delete_dialog_title => '删除医疗记录？';

  @override
  String get medical_record_confirm_delete_dialog_content => '您确定要删除此医疗记录吗？';

  @override
  String get medical_record_patient_status => '患者状态';

  @override
  String get medical_record_disease_name => '疾病名称';

  @override
  String get medical_record_disease_history => '疾病历史';

  @override
  String get medical_record_special_consideration => '特别注意事项';

  @override
  String get medical_record_records_file => '医疗记录文件';

  @override
  String get medical_record_download_file_btn => '下载文件';

  @override
  String get medical_record_view_file_btn => '查看文件';

  @override
  String get diabetic_retinal_photography => '糖尿病视网膜摄影 (DRP)';

  @override
  String get diabetic_retinal_photography_desc =>
      '糖尿病患者常见的眼部疾病。毛细血管可能会出血并损伤视网膜，可能导致失明。定期进行糖尿病视网膜摄影可以检测和监测您的眼睛。';

  @override
  String get diabetic_foot_screening => '糖尿病足部筛查 (DFS)';

  @override
  String get diabetic_foot_screening_desc =>
      '由训练有素的护士进行，他们还将教育正确的足部护理和良好的血糖控制。必要时将转诊给足部护理专家。';

  @override
  String get diabetic_care_title => '糖尿病护理';

  @override
  String get common_book_now => '立即预订';

  @override
  String get diabetes_form_submit_failed => '提交表单失败。';

  @override
  String get common_error_title => '错误';

  @override
  String get diabetes_form_load_failed => '加载表单数据失败。';

  @override
  String get common_next => '下一步';

  @override
  String get common_submit => '提交';

  @override
  String get diabetes_form_title => '糖尿病表单';

  @override
  String get diabetes_history_title => '糖尿病史';

  @override
  String get diabetes_type_label => '糖尿病类型';

  @override
  String get common_not_specified => '未指定';

  @override
  String get year_of_diagnosis_label => '诊断年份';

  @override
  String get last_hba1c_label => '最后一次 HbA1c';

  @override
  String get current_treatment_label => '当前治疗';

  @override
  String get risk_factors_title => '病史与风险因素';

  @override
  String get hypertension_label => '高血压';

  @override
  String get dyslipidemia_label => '血脂异常';

  @override
  String get cardiovascular_disease_label => '心血管疾病';

  @override
  String get eye_disease_label => '眼部疾病 (视网膜病变)';

  @override
  String get neuropathy_label => '神经病变';

  @override
  String get kidney_disease_label => '肾脏疾病';

  @override
  String get family_history_label => '家族史';

  @override
  String get smoking_label => '吸烟';

  @override
  String get lifestyle_self_care_title => '生活方式与自我护理';

  @override
  String get recent_hypoglycemia_label => '近期低血糖';

  @override
  String get physical_activity_label => '体育活动';

  @override
  String get diet_quality_label => '饮食质量';

  @override
  String get physical_signs_title => '体征';

  @override
  String get physical_signs_if_have_title => '体征 (如有)';

  @override
  String get eyes_last_exam_label => '眼部 (上次检查)';

  @override
  String get eyes_findings_label => '眼部 (检查结果)';

  @override
  String get kidneys_egfr_label => '肾脏 (eGFR)';

  @override
  String get kidneys_urine_acr_label => '肾脏 (尿微量白蛋白)';

  @override
  String get feet_skin_label => '足部 (皮肤)';

  @override
  String get feet_deformity_label => '足部 (畸形)';

  @override
  String get common_edit_information => '编辑信息';

  @override
  String get diabetes_type_question => '糖尿病类型：';

  @override
  String get diabetes_type_1 => '1型';

  @override
  String get diabetes_type_2 => '2型';

  @override
  String get diabetes_type_gestational => '妊娠期';

  @override
  String get common_other => '其他';

  @override
  String get enter_diabetes_type_hint => '请输入您的糖尿病类型';

  @override
  String get specify_diabetes_type_error => '请具体说明您的糖尿病类型。';

  @override
  String get year_of_diagnosis_question => '诊断年份：';

  @override
  String get year_hint => '例如 2021';

  @override
  String get invalid_year_error => '无效年份。';

  @override
  String get last_hba1c_question => '最后一次 HbA1c：';

  @override
  String get invalid_value_error => '无效值。';

  @override
  String get current_treatment_question => '当前治疗：';

  @override
  String get treatment_diet_exercise => '饮食与运动';

  @override
  String get treatment_oral_medications => '口服药物';

  @override
  String get list_medications_hint => '列出药物...';

  @override
  String get list_medications_error => '请列出您的口服药物。';

  @override
  String get treatment_insulin => '胰岛素';

  @override
  String get insulin_type_dose_hint => '类型和剂量';

  @override
  String get insulin_type_dose_error => '请具体说明您的胰岛素类型和剂量。';

  @override
  String get answer_all_questions_error => '请回答本页所有问题。';

  @override
  String get recent_hypoglycemia_question => '近期低血糖：';

  @override
  String get hypoglycemia_none => '无';

  @override
  String get hypoglycemia_mild => '轻度';

  @override
  String get hypoglycemia_severe => '重度';

  @override
  String get physical_activity_question => '体育活动：';

  @override
  String get activity_regular => '规律';

  @override
  String get activity_occasional => '偶尔';

  @override
  String get activity_sedentary => '久坐不动';

  @override
  String get diet_quality_question => '饮食质量：';

  @override
  String get diet_healthy => '健康';

  @override
  String get diet_needs_improvement => '需要改善';

  @override
  String get eyes_label => '眼睛：';

  @override
  String get last_exam_date_label => '上次检查日期';

  @override
  String get invalid_date_format_error => '无效格式 (使用 YYYY-MM-DD)';

  @override
  String get invalid_date_error => '无效日期。';

  @override
  String get findings_label => '检查结果';

  @override
  String get kidneys_label => '肾脏：';

  @override
  String get feet_label => '脚部：';

  @override
  String get skin_label => '皮肤：';

  @override
  String get skin_normal => '正常';

  @override
  String get skin_dry => '干燥';

  @override
  String get skin_ulcer => '溃疡';

  @override
  String get skin_infection => '感染';

  @override
  String get deformity_label => '畸形：';

  @override
  String get deformity_none => '无';

  @override
  String get deformity_bunions => '拇囊炎';

  @override
  String get deformity_claw_toes => '爪形趾';

  @override
  String get smoking_current => '目前吸烟';

  @override
  String get smoking_former => '曾经吸烟';

  @override
  String get smoking_never => '从不吸烟';

  @override
  String get family_history_diabetes_label => '糖尿病家族史';

  @override
  String get common_none => '无';

  @override
  String get common_upload_tap => '点击上传您的报告';

  @override
  String get common_ready => '准备就绪';

  @override
  String get common_full_report_file => '完整报告文件';

  @override
  String get mental_state_title => '心理状态';

  @override
  String get mental_state_current_section => '心理状态 (当前)';

  @override
  String get mental_state_overall_mood => '整体情绪：';

  @override
  String get mental_state_anxiety_level => '焦虑程度：';

  @override
  String get mental_state_stress_level => '压力程度：';

  @override
  String get mental_state_energy_level => '精力水平：';

  @override
  String get mental_state_focus_level => '专注程度：';

  @override
  String get mental_state_sleep_quality => '睡眠质量：';

  @override
  String get mental_state_notes_label => '影响您情绪的笔记/事件：';

  @override
  String get mental_state_notes_hint => '补充笔记';

  @override
  String get pharmacogenomics_profile_title => '药物基因组学档案';

  @override
  String get pharmacogenomics_delete_report_title => '删除报告';

  @override
  String get pharmacogenomics_delete_report_content => '您确定要删除此报告文件吗？';

  @override
  String get wellness_genomics_profile_title => '健康基因组学档案';

  @override
  String get settings_language_title => '应用语言设置';

  @override
  String get language_en => '英语 (en)';

  @override
  String get language_zh => '中文 (zh)';

  @override
  String get language_id => '印尼语 (id)';
}
