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
  String get common_ok => '确定';

  @override
  String get common_coming_soon => '敬请期待';

  @override
  String get common_feature_available_soon => '此功能即将推出！';

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

  @override
  String get auth_sign_in_title => '在此登录';

  @override
  String get auth_welcome_back => '欢迎回来\n好久不见';

  @override
  String get auth_email_hint => '电子邮箱';

  @override
  String get auth_password_hint => '密码';

  @override
  String get auth_forgot_password_btn => '忘记密码？';

  @override
  String get auth_sign_in_btn => '登录';

  @override
  String get auth_create_account => '创建新账户';

  @override
  String get auth_continue_with => '或继续使用';

  @override
  String get auth_error_title => '错误';

  @override
  String get auth_fill_email_password_error => '请填写电子邮箱和密码。';

  @override
  String get auth_fill_all_fields_error => '请正确填写所有字段。';

  @override
  String get auth_select_role_error => '请选择用户类型';

  @override
  String get auth_select_role_first_error => '请先选择用户类型';

  @override
  String get auth_passwords_do_not_match => '密码不匹配';

  @override
  String get auth_enter_valid_email => '请输入有效的电子邮箱';

  @override
  String get auth_enter_email => '请输入您的电子邮箱';

  @override
  String get auth_enter_password => '请输入密码';

  @override
  String get auth_password_length_error => '密码必须至少 6 个字符';

  @override
  String get auth_enter_username => '请输入用户名';

  @override
  String get auth_confirm_password_hint => '确认密码';

  @override
  String get auth_username_hint => '用户名';

  @override
  String get auth_select_user_type_hint => '选择用户类型';

  @override
  String get auth_role_patient => '患者';

  @override
  String get auth_role_nurse => '护士';

  @override
  String get auth_role_pharmacist => '药剂师';

  @override
  String get auth_role_radiologist => '放射科医生';

  @override
  String get auth_role_caregiver => '护理员/帮手';

  @override
  String get auth_sign_up_title => '创建账户';

  @override
  String get auth_sign_up_subtitle => '创建一个账户，以便您可以探索所有\n现有工作';

  @override
  String get auth_sign_up_btn => '注册';

  @override
  String get auth_already_have_account => '已有账户';

  @override
  String get auth_registration_successful_title => '注册成功';

  @override
  String get auth_registration_successful_content => '请检查您的电子邮箱进行验证。';

  @override
  String get auth_complete_registration_title => '完成注册';

  @override
  String get auth_complete_registration_content => '欢迎！\n请选择您的账户类型以继续。';

  @override
  String get auth_forgot_password_title => '忘记密码？';

  @override
  String get auth_forgot_password_subtitle => '别担心！请输入与您的账户关联的电子邮件地址。';

  @override
  String get auth_enter_email_hint => '请输入您的电子邮箱';

  @override
  String get auth_send_code_btn => '发送代码';

  @override
  String get auth_otp_sent_success => 'OTP 发送成功';

  @override
  String get auth_otp_verification_title => '输入验证码';

  @override
  String auth_otp_verification_subtitle(String email) {
    return '请输入我们发送到您邮箱 $email 的代码';
  }

  @override
  String get auth_verify_btn => '验证';

  @override
  String get auth_resend_code => '没有收到代码？重新发送';

  @override
  String auth_resend_in_seconds(int seconds) {
    return '$seconds 秒后重新发送';
  }

  @override
  String get auth_code_resent => '代码已重新发送！';

  @override
  String get auth_pin_incorrect => 'Pin 码不正确';

  @override
  String get auth_reset_password_title => '重置密码';

  @override
  String get auth_reset_password_subtitle => '请输入您的新密码';

  @override
  String get auth_new_password_hint => '新密码';

  @override
  String get auth_confirm_password_error => '请确认您的密码';

  @override
  String get auth_reset_password_btn => '重置密码';

  @override
  String get auth_reset_password_success_title => '密码重置成功！';

  @override
  String get auth_reset_password_success_content => '您已成功重置密码。登录时请使用您的新密码。';

  @override
  String get auth_back_to_login_btn => '返回登录';

  @override
  String get booking_nursing_primary_title => '基础护理';

  @override
  String get booking_nursing_primary_desc =>
      '监测并执行\n护理程序，从\n身体检查、给药、\n管饲和吸痰到\n注射和伤口护理。';

  @override
  String get booking_nursing_specialized_title => '专业护理服务';

  @override
  String get booking_nursing_specialized_desc =>
      '专注于康复，并将\n复杂的护理工作交给我们经验丰富的\n护士护理专家';

  @override
  String get booking_nursing_page_title => '居家护理';

  @override
  String get booking_pharmacy_page_title => 'iRX 药师服务';

  @override
  String get booking_pharmacy_medication_counseling_title => '药物咨询\n与教育';

  @override
  String get booking_pharmacy_medication_counseling_desc =>
      '药物咨询和教育指导\n患者正确使用、副作用和\n处方依从性，\n提高安全性并\n改善健康结果。';

  @override
  String get booking_pharmacy_therapy_review_title => '综合治疗\n审查';

  @override
  String get booking_pharmacy_therapy_review_desc =>
      '全面审查您的药物\n和生活方式，以优化治疗\n结果并最大程度地减少潜在的副\n作用';

  @override
  String get booking_pharmacy_health_coaching_title => '健康指导';

  @override
  String get booking_pharmacy_health_coaching_desc =>
      '个性化指导和支持，帮助\n个人实现健康目标，管理\n慢性病，并改善整体福祉\n，设有体重\n管理、糖尿病管理、高\n血压管理和高\n胆固醇管理的专门计划';

  @override
  String get booking_pharmacy_smoking_cessation_title => '戒烟';

  @override
  String get booking_pharmacy_smoking_cessation_desc =>
      '戒烟涉及通过\n咨询、药物和支持\n计划等策略戒除\n吸烟习惯，以改善健康并\n降低吸烟相关\n疾病的风险。';

  @override
  String get booking_issue_list_title_nursing => '护士服务案例';

  @override
  String get booking_issue_list_title_pharmacy => '药师服务案例';

  @override
  String get booking_issue_list_title_radiology => '放射科医生服务案例';

  @override
  String get booking_issue_list_title_default => '服务案例';

  @override
  String get booking_tell_us_concern => '告诉我们要咨询的问题';

  @override
  String get booking_issue_empty => '尚未添加任何问题。\n 请添加一个或多个问题，以便\n您可以继续下一步。';

  @override
  String get booking_add_issue_btn => '添加问题';

  @override
  String get booking_next_btn => '下一步';

  @override
  String get booking_issue_delete_dialog_title => '删除问题';

  @override
  String get booking_issue_delete_dialog_content => '您确定要删除此问题吗？';

  @override
  String get booking_issue_form_add_title => '添加问题';

  @override
  String get booking_issue_form_edit_title => '编辑问题';

  @override
  String get booking_issue_form_instruction => '告诉我们要咨询的问题';

  @override
  String get booking_issue_form_title_hint => '问题标题';

  @override
  String get booking_issue_form_desc_hint => '请输入与您的案例相关的问题、疑虑、相关症状以及相关关键字。';

  @override
  String get booking_issue_form_images_label => '图片';

  @override
  String get booking_issue_form_update_btn => '更新';

  @override
  String get booking_issue_form_add_btn => '添加';

  @override
  String get booking_issue_form_required_error => '问题标题和描述为必填项。';

  @override
  String get booking_issue_form_success_update => '问题更新成功';

  @override
  String get booking_issue_form_success_add => '问题添加成功';

  @override
  String get booking_health_status_title => '个人案例详情';

  @override
  String get booking_health_status_mobility_label => '选择您的行动状态';

  @override
  String get booking_health_status_record_label => '选择相关的健康记录';

  @override
  String get booking_health_status_record_hint => '请选择记录';

  @override
  String get booking_health_status_no_records => '没有可用的医疗记录。';

  @override
  String get booking_addon_nursing_title => '护理程序';

  @override
  String get booking_addon_specialized_nursing_title => '专业护理程序';

  @override
  String get booking_addon_pharmacy_title => '药房服务';

  @override
  String get booking_addon_radiology_title => '放射科服务';

  @override
  String get booking_addon_default_title => '附加服务';

  @override
  String get booking_addon_empty => '没有可用的附加服务。';

  @override
  String get booking_estimated_budget => '预计预算';

  @override
  String get booking_book_appointment_btn => '预约';

  @override
  String get booking_professional_search_nurse => '搜索护士';

  @override
  String get booking_professional_search_pharmacist => '搜索药剂师';

  @override
  String get booking_professional_search_radiologist => '搜索放射科医生';

  @override
  String get booking_professional_search_caregiver => '搜索护理员/帮手/工人';

  @override
  String get booking_professional_search_default => '搜索专业人员';

  @override
  String booking_professional_filter_text(int count) {
    return '按 $count 个选定服务过滤';
  }

  @override
  String get booking_professional_empty => '未找到符合您标准的专业人员。';

  @override
  String get booking_professional_appointment_btn => '预约';

  @override
  String get booking_professional_detail_nurse => '护士详情';

  @override
  String get booking_professional_detail_pharmacist => '药剂师详情';

  @override
  String get booking_professional_detail_radiologist => '放射科医生详情';

  @override
  String get booking_professional_detail_default => '专业人员详情';

  @override
  String get booking_professional_patients_label => '患者';

  @override
  String get booking_professional_experience_label => '经验';

  @override
  String get booking_professional_rating_label => '评分';

  @override
  String get booking_professional_about_me => '关于我';

  @override
  String get booking_professional_working_info => '工作信息';

  @override
  String get booking_professional_certificate => '专业证书';

  @override
  String get booking_professional_no_certificate => '暂无证书。';

  @override
  String booking_professional_id_number(String number) {
    return 'ID 号码：$number';
  }

  @override
  String booking_professional_issued_on(String date) {
    return '签发日期：$date';
  }

  @override
  String get booking_professional_reviews => '评论';

  @override
  String get booking_professional_see_all => '查看全部';

  @override
  String get booking_professional_no_reviews => '暂无评论。';

  @override
  String get booking_professional_schedule_btn => '安排预约';

  @override
  String get booking_schedule_title => '选择时间表';

  @override
  String get booking_schedule_select_date => '选择日期';

  @override
  String get booking_schedule_select_hour => '选择时间';

  @override
  String get booking_schedule_no_slots => '该日没有可用的时段。';

  @override
  String get booking_schedule_submit_btn => '提交';

  @override
  String get booking_schedule_submitting => '正在提交...';

  @override
  String get booking_schedule_reschedule_success => '预约重新安排成功';

  @override
  String get booking_schedule_reschedule_failed => '重新安排失败。';

  @override
  String get booking_appointment_created_success => '预约创建成功';

  @override
  String get booking_appointment_created_failed => '创建预约失败';

  @override
  String get chat_pharma_title => 'AI 药剂师';

  @override
  String get chat_pharma_online => '在线';

  @override
  String get chat_pharma_privacy => '(HIPAA 隐私)';

  @override
  String get chat_pharma_need_help => '需要帮助？ ';

  @override
  String get chat_pharma_request_help => '请求药剂师帮助';

  @override
  String get chat_pharma_input_hint => '输入您的消息';

  @override
  String get common_unknown_location => '未知位置';

  @override
  String get booking_personal_issue_concern => '疑虑 / 问题';

  @override
  String booking_personal_issue_updated_on(String date) {
    return '更新于：$date';
  }

  @override
  String get booking_personal_issue_images => '图片';

  @override
  String get booking_mobility_bedbound => '长期卧床';

  @override
  String get booking_mobility_wheelchair_bound => '轮椅代步';

  @override
  String get booking_mobility_walking_aid => '助行器辅助';

  @override
  String get booking_mobility_mobile_without_aid => '无需辅助行动';

  @override
  String get home_health_screening_title => '居家健康筛查';

  @override
  String get home_health_at_home_diagnostic => '居家诊断测试';

  @override
  String get home_health_at_home_diagnostic_desc =>
      '患者使用包含拭子、测试卡和收集管等材料的自采集套件在家采集样本，并将其提交给经过CLIA/CAP认证的实验室（远程医疗实验室）进行处理。实验室技术人员处理这些样本并将结果上传到在线门户。初级保健医生、专科医生或其他医疗专业人员会审查结果并指导患者进行后续步骤。';

  @override
  String get home_health_point_of_care => '即时检测 (POCT)';

  @override
  String get home_health_point_of_care_desc =>
      '在实验室外进行的诊断，患者可以在家中自行进行。这些测试显影迅速，无需医生或实验室技术人员在场即可产生结果。通过即时检测，患者可以在医疗环境之外查看结果并确定自己的后续步骤。';

  @override
  String get home_health_screening_booked_success => '筛查预约成功！';

  @override
  String get home_health_screening_booking_failed => '预约失败';

  @override
  String get homecare_elderly_title => '长者居家护理';

  @override
  String get homecare_house_bedding_cleaning => '房屋与寝具清洁';

  @override
  String get homecare_house_bedding_cleaning_desc =>
      '定期清洁服务，为长者维护卫生、舒适和安全的居住环境。';

  @override
  String get homecare_living_security_safety => '居住安全与保障';

  @override
  String get homecare_living_security_safety_desc => '安全检查和整理，以减少风险并创造安全的居住环境。';

  @override
  String get homecare_kitchen_bathroom_repair => '厨房与浴室维修';

  @override
  String get homecare_kitchen_bathroom_repair_desc => '按需进行小修，以维持家庭关键区域的功能和安全。';

  @override
  String get homecare_plus_active => '居家护理 Plus 已激活';

  @override
  String get homecare_get_plus => '获取居家护理 Plus';

  @override
  String homecare_balance(int balance) {
    return '余额：$balance 小时';
  }

  @override
  String homecare_subscription_offer(int quota, String price) {
    return '$quota 小时 仅需 $price';
  }

  @override
  String get homecare_request_services_btn => '请求服务';

  @override
  String get homecare_select_at_least_one_task => '请至少选择一项任务。';

  @override
  String get homecare_task_list_title => '任务列表';

  @override
  String get homecare_feature_name => '功能名称';

  @override
  String get homecare_frequency => '频率';

  @override
  String get homecare_weekly => '每周';

  @override
  String get homecare_monthly => '每月';

  @override
  String get homecare_as_needed => '按需';

  @override
  String get homecare_review_checkout_title => '审查与结账';

  @override
  String get homecare_requested_tasks => '请求的任务';

  @override
  String get homecare_billing_option => '计费选项';

  @override
  String get homecare_hourly_rate => '小时费率';

  @override
  String get homecare_use_subscription_balance => '使用订阅余额';

  @override
  String homecare_deduct_hours(int hours, int balance) {
    return '扣除 $hours 小时（余额：$balance 小时）';
  }

  @override
  String homecare_insufficient_balance(int balance) {
    return '余额不足（$balance 小时）';
  }

  @override
  String get homecare_confirm_booking_btn => '确认预订';

  @override
  String get homecare_subscription_plans_title => '订阅计划';

  @override
  String homecare_care_hours(int hours) {
    return '$hours 小时护理';
  }

  @override
  String homecare_valid_for_days(int days) {
    return '有效期 $days 天';
  }

  @override
  String get homecare_experienced_caregivers => '经验丰富的护理人员';

  @override
  String get homecare_active_subscription => '当前订阅';

  @override
  String homecare_expires_on(String date) {
    return '过期时间 $date';
  }

  @override
  String homecare_purchase_now(String price) {
    return '立即购买 - $price';
  }

  @override
  String get precision_nutrition_title => '精准营养';

  @override
  String get precision_assessment_title => '精准营养评估';

  @override
  String get precision_assessment_desc =>
      '通过深入分析您的基因、新陈代谢和生活方式，开启您的旅程，了解您身体的独特需求。';

  @override
  String get precision_plan_title => '精准营养计划';

  @override
  String get precision_plan_desc => '获取由专家制定的个性化营养策略，以应对您的特定健康目标和状况。';

  @override
  String get precision_implementation_title => '精准营养实施';

  @override
  String get precision_implementation_desc =>
      '通过持续支持、生物标志物监测和智能数字工具跟踪进度并调整您的计划。';

  @override
  String get precision_start_now => '立即开始';

  @override
  String get precision_book_now => '立即预订';

  @override
  String get precision_main_concern_question => '您的主要关注点是什么？';

  @override
  String get precision_main_concern_subtitle => '选择最能描述您主要健康目标的领域';

  @override
  String get precision_sub_health => '亚健康';

  @override
  String get precision_sub_health_desc => '改善整体健康状况和精力水平';

  @override
  String get precision_chronic_disease => '慢性病';

  @override
  String get precision_chronic_disease_desc => '管理和改善慢性健康状况';

  @override
  String get precision_anti_aging => '抗衰老';

  @override
  String get precision_anti_aging_desc => '随着年龄增长优化健康和活力';

  @override
  String get precision_basic_info_title => '基本信息与健康史';

  @override
  String get precision_age_label => '年龄';

  @override
  String get precision_age_hint => '例如 34 岁';

  @override
  String get precision_age_error => '请输入您的年龄';

  @override
  String get precision_age_valid_error => '请输入有效年龄';

  @override
  String get precision_gender_label => '性别';

  @override
  String get precision_gender_error => '请选择您的性别';

  @override
  String get precision_known_condition_label => '已知状况（可选）';

  @override
  String get precision_known_condition_hint => '在此填写您的病史';

  @override
  String get precision_special_consideration_title => '有特殊注意事项的患者';

  @override
  String get precision_medication_history_label => '药物与补充剂史';

  @override
  String get precision_medication_history_hint => '例如：避免氯吡格雷、昂丹司琼等';

  @override
  String get precision_family_history_label => '家族健康史';

  @override
  String get precision_family_history_hint => '在此填写其他生物标志物（最少10个字符）';

  @override
  String get precision_family_history_error => '请输入至少10个字符';

  @override
  String get precision_self_rated_health_title => '自评健康状况';

  @override
  String get precision_terrible => '糟糕';

  @override
  String get precision_bad => '差';

  @override
  String get precision_neutral => '一般';

  @override
  String get precision_good => '好';

  @override
  String get precision_excellent => '极好';

  @override
  String get precision_its_terrible => '很糟糕';

  @override
  String get precision_its_bad => '比较差';

  @override
  String get precision_its_good => '还不错';

  @override
  String get precision_its_very_good => '非常好';

  @override
  String get precision_lifestyle_habits_title => '生活方式与习惯';

  @override
  String get precision_sleep_hours_question => '您每晚睡眠多少小时？';

  @override
  String precision_hours_per_day(String hours) {
    return '每天 $hours 小时';
  }

  @override
  String get precision_activity_level_label => '描述您典型的日常活动水平';

  @override
  String get precision_activity_level_hint => '例如：每天在办公桌前工作8小时';

  @override
  String get precision_activity_level_error => '请描述您的活动水平';

  @override
  String get precision_exercise_frequency_label => '您每周锻炼频率如何？';

  @override
  String get precision_exercise_frequency_hint => '例如：每天约30分钟';

  @override
  String get precision_exercise_frequency_error => '请描述您的锻炼频率';

  @override
  String get precision_stress_level_label => '压力水平';

  @override
  String get precision_stress_level_hint => '例如：中等压力水平';

  @override
  String get precision_stress_level_error => '请描述您的压力水平';

  @override
  String get precision_smoking_alcohol_label => '吸烟或饮酒习惯？';

  @override
  String get precision_smoking_alcohol_hint => '例如：重度吸烟';

  @override
  String get precision_smoking_alcohol_error => '请描述您的吸烟/饮酒习惯';

  @override
  String get precision_nutrition_habits_title => '营养习惯';

  @override
  String get precision_meal_frequency_label => '描述您的每日进餐频率';

  @override
  String get precision_meal_frequency_hint => '例如：一天两次';

  @override
  String get precision_meal_frequency_error => '请描述您的进餐频率';

  @override
  String get precision_food_sensitivities_label => '已知食物敏感或过敏';

  @override
  String get precision_food_sensitivities_hint => '例如：海鲜（如虾）';

  @override
  String get precision_food_sensitivities_error => '请描述您的食物敏感情况';

  @override
  String get precision_favorite_foods_label => '喜欢的食物类型';

  @override
  String get precision_favorite_foods_hint => '例如：鸡肉、健康汤、肉丸';

  @override
  String get precision_favorite_foods_error => '请描述您喜欢的食物';

  @override
  String get precision_avoided_foods_label => '避免的食物类型';

  @override
  String get precision_avoided_foods_hint => '例如：海鲜';

  @override
  String get precision_avoided_foods_error => '请描述您避免的食物';

  @override
  String get precision_water_intake_label => '饮水量';

  @override
  String get precision_water_intake_hint => '例如：每天7杯';

  @override
  String get precision_water_intake_error => '请描述您的饮水量';

  @override
  String get precision_past_diets_label => '过去的饮食经历';

  @override
  String get precision_past_diets_hint => '例如：生酮、低碳水、植物基、生食';

  @override
  String get precision_past_diets_error => '请描述您过去的饮食经历';

  @override
  String get precision_biomarker_upload_title => '生物标志物上传';

  @override
  String get precision_upload_header => '上传您的医疗记录并连接设备';

  @override
  String get precision_upload_subtitle => '这有助于我们制定更准确和个性化的营养计划';

  @override
  String get precision_upload_medical_records => '上传医疗记录';

  @override
  String get precision_upload_medical_records_desc => '上传 PDF、图片或其他医疗文件';

  @override
  String get precision_choose_file => '选择文件';

  @override
  String get precision_connect_wearable => '连接可穿戴设备';

  @override
  String get precision_connect_wearable_desc => '同步来自您的智能手表、健身追踪器或其他设备的数据';

  @override
  String get precision_uploaded_files => '已上传文件';

  @override
  String get precision_submit_assessment => '提交评估';

  @override
  String get precision_success_title => '成功！';

  @override
  String get precision_success_content =>
      '您的精准营养评估已成功提交。我们的专家将审查您的信息并为您制定个性化计划。';

  @override
  String get precision_view_details => '查看详情';

  @override
  String get precision_my_assessment_details => '我的营养评估详情';

  @override
  String get precision_edit_information => '编辑信息';

  @override
  String get precision_download_pdf => '下载 (PDF)';

  @override
  String get precision_back_to_page => '返回精准营养页面';

  @override
  String get precision_plan_my_plan => '我的精准营养计划';

  @override
  String get precision_plan_tab_dietary => '饮食计划';

  @override
  String get precision_plan_tab_supplements => '补充剂';

  @override
  String get precision_plan_tab_lifestyle => '生活方式';

  @override
  String get precision_plan_request_update => '请求更新计划';

  @override
  String get precision_plan_goal => '目标';

  @override
  String get precision_plan_strategy => '策略';

  @override
  String get precision_plan_daily_calory => '每日热量目标';

  @override
  String get precision_plan_recommended_foods => '推荐食物';

  @override
  String get precision_plan_foods_to_limit => '需限制食物';

  @override
  String get precision_plan_weekly_meal_plan => '每周膳食计划';

  @override
  String get precision_plan_view_all => '查看全部';

  @override
  String get precision_weekly_meal_plan_title => '每周膳食计划';

  @override
  String precision_day_meal_plan(String day) {
    return '$day 膳食计划';
  }

  @override
  String get precision_meal_breakfast => '早餐';

  @override
  String get precision_meal_lunch => '午餐';

  @override
  String get precision_meal_dinner => '晚餐';

  @override
  String get precision_implementation_journey => '实施旅程';

  @override
  String get precision_implementation_indepth_assessment => '深度评估（2-4周）';

  @override
  String get precision_implementation_intervention => '干预（3-6个月）';

  @override
  String get precision_implementation_maintenance => '维护';

  @override
  String get precision_sub_health_metabolic => '代谢功能优化';

  @override
  String get precision_sub_health_gut_brain => '肠脑轴调节';

  @override
  String get precision_sub_health_immune => '免疫平衡干预';

  @override
  String get precision_chronic_diabetes => '糖尿病管理';

  @override
  String get precision_chronic_cardio => '心血管疾病支持';

  @override
  String get precision_chronic_autoimmune => '自身免疫性疾病护理';

  @override
  String get precision_chronic_obesity => '肥胖管理';

  @override
  String get precision_anti_aging_cellular => '细胞再生与线粒体健康';

  @override
  String get precision_anti_aging_cognitive => '认知长寿与神经保护';

  @override
  String get precision_anti_aging_hormonal => '荷尔蒙平衡与活力优化';

  @override
  String get precision_anti_aging_skin => '皮肤与结构长寿';

  @override
  String get precision_learn_more => '了解更多';

  @override
  String get precision_applicable_issues => '适用问题';

  @override
  String get precision_services_include => '服务包括';

  @override
  String get precision_interventions_include => '干预包括';

  @override
  String get precision_solutions_include => '解决方案包括';

  @override
  String get precision_technologies_used => '使用的技术';

  @override
  String get precision_programs_include => '计划包括';

  @override
  String get precision_precision_methods_include => '精准方法包括';

  @override
  String get day_monday => '星期一';

  @override
  String get day_tuesday => '星期二';

  @override
  String get day_wednesday => '星期三';

  @override
  String get day_thursday => '星期四';

  @override
  String get day_friday => '星期五';

  @override
  String get day_saturday => '星期六';

  @override
  String get day_sunday => '星期日';

  @override
  String get nutrition_protein => '蛋白质';

  @override
  String get nutrition_carbs => '碳水化合物';

  @override
  String get nutrition_fat => '脂肪';

  @override
  String get admin_homecare_service_rates => '服务费率';

  @override
  String get admin_homecare_subscription_plans => '订阅计划';

  @override
  String get admin_homecare_update_successful => '更新成功';

  @override
  String admin_homecare_update_failed(String error) {
    return '更新失败：$error';
  }

  @override
  String get admin_homecare_no_service_rates => '未找到服务费率。';

  @override
  String get admin_homecare_no_subscription_plans => '未找到订阅计划。';

  @override
  String admin_homecare_edit_rate(String name) {
    return '编辑费率：$name';
  }

  @override
  String get admin_homecare_edit_plan => '编辑计划';

  @override
  String get admin_homecare_price => '价格';

  @override
  String get admin_homecare_quota_hours => '配额（小时）';

  @override
  String get admin_homecare_validity_days => '有效期（天）';

  @override
  String get admin_homecare_active => '已激活';

  @override
  String get admin_homecare_inactive => '未激活';

  @override
  String get admin_homecare_save_changes => '保存更改';

  @override
  String admin_homecare_plan_details(String price, int quota, int days) {
    return '价格：\$$price | 配额：$quota小时 | 有效期：$days天';
  }

  @override
  String get favourite_title => '收藏夹';

  @override
  String get favourite_no_favorites => '您还没有收藏的专业人员。';

  @override
  String favourite_error_fetching(String error) {
    return '获取数据错误：$error';
  }

  @override
  String favourite_error_toggle(String error) {
    return '错误：$error';
  }

  @override
  String get medical_store_title => '医疗商店';

  @override
  String get medical_store_sort => '排序';

  @override
  String get medical_store_consumable_tab => '医疗耗材';

  @override
  String get medical_store_poct_tab => '屁哦西提';

  @override
  String get medical_store_no_products => '暂无产品';

  @override
  String get medical_store_load_failed => '加载产品失败';

  @override
  String get payment_title => '支付';

  @override
  String get payment_order_summary => '订单摘要';

  @override
  String get payment_charge => '费用';

  @override
  String get payment_total => '总计';

  @override
  String get payment_select_method => '选择支付方式';

  @override
  String get payment_confirm_btn => '确认';

  @override
  String payment_pay_btn(String amount) {
    return '支付 $amount';
  }

  @override
  String get payment_success_title => '支付成功';

  @override
  String payment_success_content(String name) {
    return '您的款项已成功发送给 $name。';
  }

  @override
  String get payment_amount => '金额';

  @override
  String get payment_how_is_experience => '您的体验如何？';

  @override
  String get payment_feedback_help => '您的反馈将帮助我们更好地\n改善您的体验';

  @override
  String get payment_please_feedback_btn => '请反馈';

  @override
  String get payment_return_home_btn => '返回首页';

  @override
  String get payment_feedback_thank_you => '感谢您的反馈！';

  @override
  String get payment_feedback_success_content => '此预约已完成，可以在已完成订单菜单中查看';

  @override
  String get payment_view_detail_btn => '查看详情';

  @override
  String get payment_excellent => '极好';

  @override
  String payment_rated_text(String name, int stars) {
    return '您给 $name 打了 $stars 星';
  }

  @override
  String get payment_write_text_hint => '写下您的文字';

  @override
  String payment_give_tips(String name) {
    return '给 $name 一些小费';
  }

  @override
  String get payment_enter_other_amount => '输入其他金额';

  @override
  String get payment_enter_amount_hint => '输入金额';

  @override
  String get payment_submit_btn => '提交';

  @override
  String payment_failed(String message) {
    return '支付失败：$message';
  }

  @override
  String payment_feedback_failed(String message) {
    return '反馈失败：$message';
  }

  @override
  String payment_purchase_failed(String message) {
    return '购买失败：$message';
  }

  @override
  String get payment_subscription_success_title => '支付成功';

  @override
  String payment_subscription_success_content(String plan) {
    return '您已成功订阅 $plan';
  }

  @override
  String get schedule_working_schedule_title => '工作时间表';

  @override
  String get schedule_weekly_hours_tab => '每周时间';

  @override
  String get schedule_date_specific_hours_tab => '特定日期时间';

  @override
  String get schedule_preview_tab => '预览';

  @override
  String get schedule_unavailable => '不可用';

  @override
  String get schedule_edit_hours => '编辑时间';

  @override
  String get schedule_add_hours => '添加时间';

  @override
  String get schedule_start => '开始';

  @override
  String get schedule_end => '结束';

  @override
  String get schedule_please_select_time => '请选择开始和结束时间。';

  @override
  String get schedule_end_time_error => '结束时间必须晚于开始时间。';

  @override
  String get schedule_delete_time_block_title => '删除时间块？';

  @override
  String schedule_delete_time_block_content(String start, String end) {
    return '您确定要删除 $start - $end 吗？';
  }

  @override
  String get schedule_add_time_slot_title => '添加时间段';

  @override
  String get schedule_add_btn => '添加';

  @override
  String get schedule_revert_to_weekly => '恢复为每周';

  @override
  String get schedule_i_am_unavailable => '我不可用';

  @override
  String get schedule_mark_day_off => '将此特定日期标记为休息日';

  @override
  String get schedule_specific_hours => '特定时间';

  @override
  String get schedule_no_slots_added => '尚未添加时间段。您显示为不可用。';

  @override
  String get schedule_using_weekly => '使用每周时间表';

  @override
  String get schedule_customize_hours => '为此日期自定义时间';

  @override
  String get schedule_reset_default_title => '重置为默认？';

  @override
  String get schedule_reset_default_content =>
      '这将删除您为此日期的自定义设置。时间表将恢复为您每周的重复规则。';

  @override
  String get schedule_reset_btn => '重置';

  @override
  String get schedule_select_date => '选择日期';

  @override
  String get schedule_available_hours => '可用时间';

  @override
  String get schedule_no_available_slots => '此日期没有可用的时段。';

  @override
  String get schedule_availability_added => '可用性已添加！';

  @override
  String get schedule_availability_updated => '可用性已更新！';

  @override
  String get schedule_availability_removed => '可用性已移除！';

  @override
  String get schedule_reverted_success => '已恢复为每周时间表';

  @override
  String get schedule_updated_success => '时间表更新成功';
}
