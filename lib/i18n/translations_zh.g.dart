///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsZh with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZh({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zh,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZh _root = this; // ignore: unused_field

	@override 
	TranslationsZh $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZh(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAuthZh auth = _TranslationsAuthZh._(_root);
	@override late final _TranslationsBookingZh booking = _TranslationsBookingZh._(_root);
	@override late final _TranslationsDashboardZh dashboard = _TranslationsDashboardZh._(_root);
	@override late final _TranslationsGlobalZh global = _TranslationsGlobalZh._(_root);
	@override late final _TranslationsNursingZh nursing = _TranslationsNursingZh._(_root);
	@override late final _TranslationsPaymentZh payment = _TranslationsPaymentZh._(_root);
	@override late final _TranslationsPharmacyZh pharmacy = _TranslationsPharmacyZh._(_root);
	@override late final _TranslationsSettingsZh settings = _TranslationsSettingsZh._(_root);
	@override late final _TranslationsStoreZh store = _TranslationsStoreZh._(_root);
}

// Path: auth
class _TranslationsAuthZh implements TranslationsAuthEn {
	_TranslationsAuthZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthButtonZh button = _TranslationsAuthButtonZh._(_root);
	@override String get continue_with_alternative_text => '或继续使用';
	@override late final _TranslationsAuthForgotPasswordZh forgot_password = _TranslationsAuthForgotPasswordZh._(_root);
	@override late final _TranslationsAuthFormZh form = _TranslationsAuthFormZh._(_root);
	@override late final _TranslationsAuthLoginZh login = _TranslationsAuthLoginZh._(_root);
	@override late final _TranslationsAuthOtpVerificationZh otp_verification = _TranslationsAuthOtpVerificationZh._(_root);
	@override late final _TranslationsAuthRegisterZh register = _TranslationsAuthRegisterZh._(_root);
	@override late final _TranslationsAuthResetPasswordZh reset_password = _TranslationsAuthResetPasswordZh._(_root);
	@override late final _TranslationsAuthResetPasswordSuccessZh reset_password_success = _TranslationsAuthResetPasswordSuccessZh._(_root);
	@override late final _TranslationsAuthUserRoleZh user_role = _TranslationsAuthUserRoleZh._(_root);
}

// Path: booking
class _TranslationsBookingZh implements TranslationsBookingEn {
	_TranslationsBookingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsBookingAddonZh addon = _TranslationsBookingAddonZh._(_root);
	@override String get book_appointment => '预约';
	@override late final _TranslationsBookingHealthStatusZh health_status = _TranslationsBookingHealthStatusZh._(_root);
	@override late final _TranslationsBookingIssueZh issue = _TranslationsBookingIssueZh._(_root);
	@override late final _TranslationsBookingProfessionalDetailZh professional_detail = _TranslationsBookingProfessionalDetailZh._(_root);
	@override late final _TranslationsBookingProfessionalSearchZh professional_search = _TranslationsBookingProfessionalSearchZh._(_root);
	@override late final _TranslationsBookingScheduleZh schedule = _TranslationsBookingScheduleZh._(_root);
}

// Path: dashboard
class _TranslationsDashboardZh implements TranslationsDashboardEn {
	_TranslationsDashboardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get allied_services => '辅助医疗';
	@override String get chat_ai_placeholder => '咨询AI医生，解答您的健康疑问';
	@override String greeting({required Object displayName}) => '更长寿，更健康，${displayName}！';
	@override late final _TranslationsDashboardServicesZh services = _TranslationsDashboardServicesZh._(_root);
}

// Path: global
class _TranslationsGlobalZh implements TranslationsGlobalEn {
	_TranslationsGlobalZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get add => '添加';
	@override String get book_now => '立即预订';
	@override String get cancel => '取消';
	@override String get complete => '完成';
	@override String get confirm => '确认';
	@override String get delete => '删除';
	@override String get description => '描述';
	@override late final _TranslationsGlobalDialogZh dialog = _TranslationsGlobalDialogZh._(_root);
	@override String get edit_information => '编辑信息';
	@override String get error => '错误';
	@override String error_message({required Object error}) => '错误：${error}';
	@override late final _TranslationsGlobalMessagesZh messages = _TranslationsGlobalMessagesZh._(_root);
	@override String get modify => '修改';
	@override String get next => '下一步';
	@override String get no => '否';
	@override String get no_data => '暂无数据';
	@override String get none => '无';
	@override String get not_specified => '未指定';
	@override String get ok => '确定';
	@override String get other => '其他';
	@override String get ready => '准备就绪';
	@override String get remove => '移除';
	@override String get retry => '重试';
	@override String get save => '保存';
	@override String get saving => '正在保存...';
	@override String get services => '服务';
	@override String get status => '状态';
	@override String get submit => '提交';
	@override String get unknown_location => '未知位置';
	@override String get update => '更新';
	@override String get yes => '是';
}

// Path: nursing
class _TranslationsNursingZh implements TranslationsNursingEn {
	_TranslationsNursingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNursingServicesZh services = _TranslationsNursingServicesZh._(_root);
	@override String get title => '居家护理';
}

// Path: payment
class _TranslationsPaymentZh implements TranslationsPaymentEn {
	_TranslationsPaymentZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPaymentErrorZh error = _TranslationsPaymentErrorZh._(_root);
	@override late final _TranslationsPaymentFeedbackZh feedback = _TranslationsPaymentFeedbackZh._(_root);
	@override late final _TranslationsPaymentFeedbackSuccessZh feedback_success = _TranslationsPaymentFeedbackSuccessZh._(_root);
	@override late final _TranslationsPaymentMessagesZh messages = _TranslationsPaymentMessagesZh._(_root);
	@override late final _TranslationsPaymentMethodsZh methods = _TranslationsPaymentMethodsZh._(_root);
	@override late final _TranslationsPaymentOfflineSuccessZh offline_success = _TranslationsPaymentOfflineSuccessZh._(_root);
	@override String get order_summary => '订单摘要';
	@override String pay_btn({required Object amount}) => '支付 ${amount}';
	@override String get price_label => '价格';
	@override String get return_home_btn => '返回首页';
	@override String get select_method => '选择支付方式';
	@override String get service_charge => '服务费';
	@override late final _TranslationsPaymentSubscriptionSuccessZh subscription_success = _TranslationsPaymentSubscriptionSuccessZh._(_root);
	@override late final _TranslationsPaymentSuccessZh success = _TranslationsPaymentSuccessZh._(_root);
	@override String get title => '支付';
	@override String get total_label => '总计';
	@override String get validity_label => '有效期';
}

// Path: pharmacy
class _TranslationsPharmacyZh implements TranslationsPharmacyEn {
	_TranslationsPharmacyZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPharmacyServicesZh services = _TranslationsPharmacyServicesZh._(_root);
	@override String get title => 'iRX 药师服务';
}

// Path: settings
class _TranslationsSettingsZh implements TranslationsSettingsEn {
	_TranslationsSettingsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get account => '帐户';
	@override String get app_language => '语言设置';
	@override String get settings => '设置';
}

// Path: store
class _TranslationsStoreZh implements TranslationsStoreEn {
	_TranslationsStoreZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get consumable => '医疗耗材';
	@override late final _TranslationsStoreMessagesZh messages = _TranslationsStoreMessagesZh._(_root);
	@override String get no_products => '暂无产品';
	@override String get poct => 'PoCT';
	@override String get sort => '排序';
	@override String get title => '医疗商店';
}

// Path: auth.button
class _TranslationsAuthButtonZh implements TranslationsAuthButtonEn {
	_TranslationsAuthButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get logout => '退出登录';
}

// Path: auth.forgot_password
class _TranslationsAuthForgotPasswordZh implements TranslationsAuthForgotPasswordEn {
	_TranslationsAuthForgotPasswordZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthForgotPasswordFormZh form = _TranslationsAuthForgotPasswordFormZh._(_root);
	@override late final _TranslationsAuthForgotPasswordMessageZh message = _TranslationsAuthForgotPasswordMessageZh._(_root);
	@override String get send_code_button => '发送代码';
	@override String get subtitle => '别担心！请输入与您的账户关联的电子邮件地址。';
	@override String get title => '忘记密码？';
}

// Path: auth.form
class _TranslationsAuthFormZh implements TranslationsAuthFormEn {
	_TranslationsAuthFormZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthFormLabelZh label = _TranslationsAuthFormLabelZh._(_root);
	@override late final _TranslationsAuthFormValidationZh validation = _TranslationsAuthFormValidationZh._(_root);
}

// Path: auth.login
class _TranslationsAuthLoginZh implements TranslationsAuthLoginEn {
	_TranslationsAuthLoginZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthLoginButtonZh button = _TranslationsAuthLoginButtonZh._(_root);
	@override late final _TranslationsAuthLoginFormZh form = _TranslationsAuthLoginFormZh._(_root);
	@override late final _TranslationsAuthLoginRoleSelectionDialogZh role_selection_dialog = _TranslationsAuthLoginRoleSelectionDialogZh._(_root);
	@override String get subtitle => '欢迎回来\n好久不见';
	@override String get title => '在此登录';
}

// Path: auth.otp_verification
class _TranslationsAuthOtpVerificationZh implements TranslationsAuthOtpVerificationEn {
	_TranslationsAuthOtpVerificationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthOtpVerificationButtonZh button = _TranslationsAuthOtpVerificationButtonZh._(_root);
	@override late final _TranslationsAuthOtpVerificationMessageZh message = _TranslationsAuthOtpVerificationMessageZh._(_root);
	@override String resend_time_countdown({required Object seconds}) => '${seconds} 秒后重新发送';
	@override String subtitle({required Object email}) => '请输入我们发送到您邮箱 ${email} 的代码';
	@override String get title => '输入验证码';
}

// Path: auth.register
class _TranslationsAuthRegisterZh implements TranslationsAuthRegisterEn {
	_TranslationsAuthRegisterZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthRegisterButtonZh button = _TranslationsAuthRegisterButtonZh._(_root);
	@override late final _TranslationsAuthRegisterRegistrationSuccessDialogZh registration_success_dialog = _TranslationsAuthRegisterRegistrationSuccessDialogZh._(_root);
	@override String get subtitle => '创建一个账户，以便您可以探索所有\n现有工作';
	@override String get title => '创建账户';
}

// Path: auth.reset_password
class _TranslationsAuthResetPasswordZh implements TranslationsAuthResetPasswordEn {
	_TranslationsAuthResetPasswordZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthResetPasswordButtonZh button = _TranslationsAuthResetPasswordButtonZh._(_root);
	@override String get subtitle => '请输入您的新密码';
	@override String get title => '重置密码';
}

// Path: auth.reset_password_success
class _TranslationsAuthResetPasswordSuccessZh implements TranslationsAuthResetPasswordSuccessEn {
	_TranslationsAuthResetPasswordSuccessZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get body => '您已成功重置密码。登录时请使用您的新密码。';
	@override late final _TranslationsAuthResetPasswordSuccessButtonZh button = _TranslationsAuthResetPasswordSuccessButtonZh._(_root);
	@override String get title => '密码重置成功！';
}

// Path: auth.user_role
class _TranslationsAuthUserRoleZh implements TranslationsAuthUserRoleEn {
	_TranslationsAuthUserRoleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get caregiver => '护理员/帮手';
	@override String get nurse => '护士';
	@override String get patient => '患者';
	@override String get pharmacist => '药剂师';
	@override String get physiotherapist => '物理治疗师';
	@override String get radiologist => '放射科医生';
}

// Path: booking.addon
class _TranslationsBookingAddonZh implements TranslationsBookingAddonEn {
	_TranslationsBookingAddonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get empty => '没有可用的附加服务。';
	@override String get estimated_budget => '预计预算';
	@override late final _TranslationsBookingAddonTitleZh title = _TranslationsBookingAddonTitleZh._(_root);
}

// Path: booking.health_status
class _TranslationsBookingHealthStatusZh implements TranslationsBookingHealthStatusEn {
	_TranslationsBookingHealthStatusZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get empty_record => '没有可用的医疗记录。';
	@override String get mobility_detail_hint => '例如：拐杖、助行架、其他';
	@override String get mobility_label => '选择您的行动状态';
	@override String get record_hint => '请选择记录';
	@override String get record_label => '选择相关的健康记录';
	@override String get title => '个人案例详情';
}

// Path: booking.issue
class _TranslationsBookingIssueZh implements TranslationsBookingIssueEn {
	_TranslationsBookingIssueZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get add_issue_button => '添加主诉';
	@override String get add_issue_title => '添加问题';
	@override String get default_page_title => '服务请求';
	@override late final _TranslationsBookingIssueDeleteDialogZh delete_dialog = _TranslationsBookingIssueDeleteDialogZh._(_root);
	@override String get edit_issue_title => '编辑问题';
	@override String get empty_issue => '尚未添加任何问题。\n 请添加一个或多个问题，以便\n您可以继续下一步。';
	@override String get fill_complaint_instruction => '请选择本服务的主诉问题';
	@override late final _TranslationsBookingIssueFormZh form = _TranslationsBookingIssueFormZh._(_root);
	@override String get images => '图片';
	@override late final _TranslationsBookingIssueMessagesZh messages = _TranslationsBookingIssueMessagesZh._(_root);
	@override String get nurse_page_title => '护士服务请求';
	@override String get pharmacy_page_title => '药师服务请求';
	@override String get radiology_page_title => '放射科医生服务请求';
	@override String updated_on({required Object date}) => '更新于：${date}';
}

// Path: booking.professional_detail
class _TranslationsBookingProfessionalDetailZh implements TranslationsBookingProfessionalDetailEn {
	_TranslationsBookingProfessionalDetailZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get about_me => '关于我';
	@override String get certificates => '专业证书';
	@override String get experience_label => '经验';
	@override String id_number({required Object number}) => 'ID 号码：${number}';
	@override String issued_on({required Object date}) => '签发日期：${date}';
	@override String get no_certificate => '暂无证书。';
	@override String get no_reviews => '暂无评论。';
	@override String get patients_label => '患者';
	@override String get rating_label => '评分';
	@override String get reviews => '评论';
	@override String get schedule_button => '安排预约';
	@override String get see_all_button => '查看全部';
	@override late final _TranslationsBookingProfessionalDetailTitleZh title = _TranslationsBookingProfessionalDetailTitleZh._(_root);
	@override String get working_info => '工作信息';
}

// Path: booking.professional_search
class _TranslationsBookingProfessionalSearchZh implements TranslationsBookingProfessionalSearchEn {
	_TranslationsBookingProfessionalSearchZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get appointment_button => '预约';
	@override String get empty => '未找到符合您标准的专业人员。';
	@override String filter_text({required Object count}) => '按 ${count} 个选定服务过滤';
	@override late final _TranslationsBookingProfessionalSearchTitleZh title = _TranslationsBookingProfessionalSearchTitleZh._(_root);
}

// Path: booking.schedule
class _TranslationsBookingScheduleZh implements TranslationsBookingScheduleEn {
	_TranslationsBookingScheduleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get empty_slots => '该日没有可用的时段。';
	@override late final _TranslationsBookingScheduleMessagesZh messages = _TranslationsBookingScheduleMessagesZh._(_root);
	@override String get select_date => '选择日期';
	@override String get select_hour => '选择时间';
	@override String get submit_button => '提交';
	@override String get submitting_button => '正在提交...';
	@override String get title => '选择时间表';
}

// Path: dashboard.services
class _TranslationsDashboardServicesZh implements TranslationsDashboardServicesEn {
	_TranslationsDashboardServicesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get diabetic_care => 'iRX糖尿病护理';
	@override String get dietitian => '营养师服务';
	@override String get health_risk_assessment => '健康风险评估';
	@override String get home_screening => '居家健康筛查';
	@override String get homecare_for_elderly => '长者家政维修';
	@override String get nursing => ' 上门护士';
	@override String get pharmacist => 'iRX 药师服务';
	@override String get physiotherapy => '物理治疗';
	@override String get precision_nutrition => '精准营养';
	@override String get remote_patient_monitoring => '远程健康监测';
	@override String get second_opinion => '医学影像第二意见';
	@override String get sleep_and_mental_health => '睡眠与心理健康';
}

// Path: global.dialog
class _TranslationsGlobalDialogZh implements TranslationsGlobalDialogEn {
	_TranslationsGlobalDialogZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get coming_soon => '敬请期待';
	@override String get feature_available_soon => '此功能即将推出！';
}

// Path: global.messages
class _TranslationsGlobalMessagesZh implements TranslationsGlobalMessagesEn {
	_TranslationsGlobalMessagesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get delete_success => '删除成功';
	@override String get updated_success => '更新成功';
}

// Path: nursing.services
class _TranslationsNursingServicesZh implements TranslationsNursingServicesEn {
	_TranslationsNursingServicesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNursingServicesPrimaryNursingZh primary_nursing = _TranslationsNursingServicesPrimaryNursingZh._(_root);
	@override late final _TranslationsNursingServicesSpecializedNursingZh specialized_nursing = _TranslationsNursingServicesSpecializedNursingZh._(_root);
}

// Path: payment.error
class _TranslationsPaymentErrorZh implements TranslationsPaymentErrorEn {
	_TranslationsPaymentErrorZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get appointment_id_missing => '错误：缺少预约 ID。';
}

// Path: payment.feedback
class _TranslationsPaymentFeedbackZh implements TranslationsPaymentFeedbackEn {
	_TranslationsPaymentFeedbackZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get enter_amount_hint => '输入金额';
	@override String get enter_other_amount => '输入其他金额';
	@override String get excellent => '极好';
	@override String give_tips({required Object name}) => '给 ${name} 一些小费';
	@override String rated_text({required Object name, required Object stars}) => '您给 ${name} 评了 ${stars} 星';
	@override String get submit_btn => '提交反馈';
	@override String get write_text_hint => '在此写下您的反馈...';
}

// Path: payment.feedback_success
class _TranslationsPaymentFeedbackSuccessZh implements TranslationsPaymentFeedbackSuccessEn {
	_TranslationsPaymentFeedbackSuccessZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get content => '您的反馈已成功提交。';
	@override String get thank_you => '谢谢！';
	@override String get view_detail_btn => '查看预约详情';
}

// Path: payment.messages
class _TranslationsPaymentMessagesZh implements TranslationsPaymentMessagesEn {
	_TranslationsPaymentMessagesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String failed({required Object error}) => '支付失败：${error}';
	@override String feedback_failed({required Object error}) => '反馈提交失败：${error}';
	@override String purchase_failed({required Object error}) => '购买失败：${error}';
}

// Path: payment.methods
class _TranslationsPaymentMethodsZh implements TranslationsPaymentMethodsEn {
	_TranslationsPaymentMethodsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get cash_offline => '现金（线下支付）';
}

// Path: payment.offline_success
class _TranslationsPaymentOfflineSuccessZh implements TranslationsPaymentOfflineSuccessEn {
	_TranslationsPaymentOfflineSuccessZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get content => '您的请求已成功提交。\n请在预约期间直接向专业人员支付。';
	@override String get estimated_total => '预计总额';
	@override String get title => '请求已提交';
}

// Path: payment.subscription_success
class _TranslationsPaymentSubscriptionSuccessZh implements TranslationsPaymentSubscriptionSuccessEn {
	_TranslationsPaymentSubscriptionSuccessZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String content({required Object planName}) => '您已成功购买 ${planName}';
	@override String get title => '支付成功';
}

// Path: payment.success
class _TranslationsPaymentSuccessZh implements TranslationsPaymentSuccessEn {
	_TranslationsPaymentSuccessZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get amount => '金额';
	@override String content({required Object name}) => '您的款项已成功发送给 ${name}。';
	@override String get experience_subtitle => '您的反馈将帮助我们改善\n您的体验';
	@override String get experience_title => '您的体验如何？';
	@override String get feedback_btn => '请反馈';
	@override String get title => '支付成功';
}

// Path: pharmacy.services
class _TranslationsPharmacyServicesZh implements TranslationsPharmacyServicesEn {
	_TranslationsPharmacyServicesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPharmacyServicesHealthCoachingZh health_coaching = _TranslationsPharmacyServicesHealthCoachingZh._(_root);
	@override late final _TranslationsPharmacyServicesMedicationCounselingZh medication_counseling = _TranslationsPharmacyServicesMedicationCounselingZh._(_root);
	@override late final _TranslationsPharmacyServicesSmokingCessationZh smoking_cessation = _TranslationsPharmacyServicesSmokingCessationZh._(_root);
	@override late final _TranslationsPharmacyServicesTherapyReviewZh therapy_review = _TranslationsPharmacyServicesTherapyReviewZh._(_root);
}

// Path: store.messages
class _TranslationsStoreMessagesZh implements TranslationsStoreMessagesEn {
	_TranslationsStoreMessagesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get load_failed => '加载产品失败';
}

// Path: auth.forgot_password.form
class _TranslationsAuthForgotPasswordFormZh implements TranslationsAuthForgotPasswordFormEn {
	_TranslationsAuthForgotPasswordFormZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthForgotPasswordFormLabelZh label = _TranslationsAuthForgotPasswordFormLabelZh._(_root);
}

// Path: auth.forgot_password.message
class _TranslationsAuthForgotPasswordMessageZh implements TranslationsAuthForgotPasswordMessageEn {
	_TranslationsAuthForgotPasswordMessageZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get otp_sent => 'OTP 发送成功';
}

// Path: auth.form.label
class _TranslationsAuthFormLabelZh implements TranslationsAuthFormLabelEn {
	_TranslationsAuthFormLabelZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get email => '电子邮箱';
	@override String get new_password => '新密码';
	@override String get password => '密码';
	@override String get password_confirm => '确认密码';
	@override String get user_role => '选择用户类型';
	@override String get username => '用户名';
}

// Path: auth.form.validation
class _TranslationsAuthFormValidationZh implements TranslationsAuthFormValidationEn {
	_TranslationsAuthFormValidationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get email_required => '请输入您的电子邮箱';
	@override String get invalid_email => '请输入有效的电子邮箱';
	@override String get invalid_password_length => '密码必须至少 6 个字符';
	@override String get password_confirm_required => '请确认您的密码';
	@override String get password_mismatch => '密码不匹配';
	@override String get password_required => '请输入密码';
	@override String get user_role_required => '请选择用户类型';
	@override String get username_required => '请输入用户名';
}

// Path: auth.login.button
class _TranslationsAuthLoginButtonZh implements TranslationsAuthLoginButtonEn {
	_TranslationsAuthLoginButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get create_account_link => '创建新账户';
	@override String get forgot_password_link => '忘记密码？';
	@override String get submit => '登录';
}

// Path: auth.login.form
class _TranslationsAuthLoginFormZh implements TranslationsAuthLoginFormEn {
	_TranslationsAuthLoginFormZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthLoginFormValidationZh validation = _TranslationsAuthLoginFormValidationZh._(_root);
}

// Path: auth.login.role_selection_dialog
class _TranslationsAuthLoginRoleSelectionDialogZh implements TranslationsAuthLoginRoleSelectionDialogEn {
	_TranslationsAuthLoginRoleSelectionDialogZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get body => '欢迎！\n请选择您的账户类型以继续。';
	@override String get title => '完成注册';
}

// Path: auth.otp_verification.button
class _TranslationsAuthOtpVerificationButtonZh implements TranslationsAuthOtpVerificationButtonEn {
	_TranslationsAuthOtpVerificationButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get resend_code => '没有收到代码？重新发送';
	@override String get submit => '验证';
}

// Path: auth.otp_verification.message
class _TranslationsAuthOtpVerificationMessageZh implements TranslationsAuthOtpVerificationMessageEn {
	_TranslationsAuthOtpVerificationMessageZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get code_resent => '代码已重新发送！';
}

// Path: auth.register.button
class _TranslationsAuthRegisterButtonZh implements TranslationsAuthRegisterButtonEn {
	_TranslationsAuthRegisterButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get login_link => '已有账户';
	@override String get submit => '注册';
}

// Path: auth.register.registration_success_dialog
class _TranslationsAuthRegisterRegistrationSuccessDialogZh implements TranslationsAuthRegisterRegistrationSuccessDialogEn {
	_TranslationsAuthRegisterRegistrationSuccessDialogZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get body => '请检查您的电子邮箱进行验证。';
	@override String get title => '注册成功';
}

// Path: auth.reset_password.button
class _TranslationsAuthResetPasswordButtonZh implements TranslationsAuthResetPasswordButtonEn {
	_TranslationsAuthResetPasswordButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get submit => '重置密码';
}

// Path: auth.reset_password_success.button
class _TranslationsAuthResetPasswordSuccessButtonZh implements TranslationsAuthResetPasswordSuccessButtonEn {
	_TranslationsAuthResetPasswordSuccessButtonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get login_page_link => '返回登录';
}

// Path: booking.addon.title
class _TranslationsBookingAddonTitleZh implements TranslationsBookingAddonTitleEn {
	_TranslationsBookingAddonTitleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '附加服务';
	@override String get nursing => '护理程序';
	@override String get pharmacy => 'Pharmacist Services';
	@override String get radiology => 'Radiologist Services';
	@override String get specialized_nursing => '专业护理程序';
}

// Path: booking.issue.delete_dialog
class _TranslationsBookingIssueDeleteDialogZh implements TranslationsBookingIssueDeleteDialogEn {
	_TranslationsBookingIssueDeleteDialogZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get content => '您确定要删除此问题吗？';
	@override String get title => '删除问题';
}

// Path: booking.issue.form
class _TranslationsBookingIssueFormZh implements TranslationsBookingIssueFormEn {
	_TranslationsBookingIssueFormZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get add_button => '添加';
	@override String get complaint_description_hint => '请输入与您的案例相关的问题、疑虑、相关症状以及相关关键字。';
	@override String get complaint_label => '主诉';
	@override String get complaint_title_hint => '告诉我们要咨询的问题';
	@override String get title_description_required => '问题标题和描述为必填项。';
}

// Path: booking.issue.messages
class _TranslationsBookingIssueMessagesZh implements TranslationsBookingIssueMessagesEn {
	_TranslationsBookingIssueMessagesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get add_issue_success => '问题添加成功';
	@override String get edit_issue_success => '问题更新成功';
}

// Path: booking.professional_detail.title
class _TranslationsBookingProfessionalDetailTitleZh implements TranslationsBookingProfessionalDetailTitleEn {
	_TranslationsBookingProfessionalDetailTitleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '专业人员详情';
	@override String get nurse => '护士详情';
	@override String get pharmacist => '药剂师详情';
	@override String get radiologist => '放射科医生详情';
}

// Path: booking.professional_search.title
class _TranslationsBookingProfessionalSearchTitleZh implements TranslationsBookingProfessionalSearchTitleEn {
	_TranslationsBookingProfessionalSearchTitleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get caregiver => '搜索护理员/帮手/工人';
	@override String get kDefault => '搜索专业人员';
	@override String get nurse => '搜索护士';
	@override String get pharmacist => '搜索药剂师';
	@override String get radiologist => '搜索放射科医生';
}

// Path: booking.schedule.messages
class _TranslationsBookingScheduleMessagesZh implements TranslationsBookingScheduleMessagesEn {
	_TranslationsBookingScheduleMessagesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get reschedule_failed => '重新安排失败。';
	@override String get reschedule_success => '预约重新安排成功';
}

// Path: nursing.services.primary_nursing
class _TranslationsNursingServicesPrimaryNursingZh implements TranslationsNursingServicesPrimaryNursingEn {
	_TranslationsNursingServicesPrimaryNursingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '监测并执行从身体检查、给药、管饲和吸痰到注射及伤口护理的各项护理程序。';
	@override String get title => '基础护理';
}

// Path: nursing.services.specialized_nursing
class _TranslationsNursingServicesSpecializedNursingZh implements TranslationsNursingServicesSpecializedNursingEn {
	_TranslationsNursingServicesSpecializedNursingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '您只需专注于康复，将复杂的护理工作交给经验丰富的专业护理人员 。';
	@override String get title => '专科护理服务';
}

// Path: pharmacy.services.health_coaching
class _TranslationsPharmacyServicesHealthCoachingZh implements TranslationsPharmacyServicesHealthCoachingEn {
	_TranslationsPharmacyServicesHealthCoachingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '提供个性化的指导与支持，助力实现健康目标、管理慢性疾病并提升整体健康水平。我们设有针对体重管理、糖尿病管理、高血压管理及高胆固醇管理的专项计划。';
	@override String get title => '健康指导';
}

// Path: pharmacy.services.medication_counseling
class _TranslationsPharmacyServicesMedicationCounselingZh implements TranslationsPharmacyServicesMedicationCounselingEn {
	_TranslationsPharmacyServicesMedicationCounselingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '药物咨询与教育旨在指导患者正确使用药物、了解副作用并提高用药依从性，从而增强用药安全性并改善健康成效。';
	@override String get title => '药物咨询\n与教育';
}

// Path: pharmacy.services.smoking_cessation
class _TranslationsPharmacyServicesSmokingCessationZh implements TranslationsPharmacyServicesSmokingCessationEn {
	_TranslationsPharmacyServicesSmokingCessationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '戒烟是指通过咨询、药物治疗和支持计划等策略停止吸烟，以改善健康状况并降低患吸烟相关疾病的风险。';
	@override String get title => '戒烟';
}

// Path: pharmacy.services.therapy_review
class _TranslationsPharmacyServicesTherapyReviewZh implements TranslationsPharmacyServicesTherapyReviewEn {
	_TranslationsPharmacyServicesTherapyReviewZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '全面审查您的药物使用及生活方式，旨在优化治疗效果并最大限度地减少潜在的副作用。';
	@override String get title => '综合治疗审查';
}

// Path: auth.forgot_password.form.label
class _TranslationsAuthForgotPasswordFormLabelZh implements TranslationsAuthForgotPasswordFormLabelEn {
	_TranslationsAuthForgotPasswordFormLabelZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get email => '请输入您的电子邮箱';
}

// Path: auth.login.form.validation
class _TranslationsAuthLoginFormValidationZh implements TranslationsAuthLoginFormValidationEn {
	_TranslationsAuthLoginFormValidationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get email_password_required => '请填写电子邮箱和密码。';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZh {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.button.logout' => '退出登录',
			'auth.continue_with_alternative_text' => '或继续使用',
			'auth.forgot_password.form.label.email' => '请输入您的电子邮箱',
			'auth.forgot_password.message.otp_sent' => 'OTP 发送成功',
			'auth.forgot_password.send_code_button' => '发送代码',
			'auth.forgot_password.subtitle' => '别担心！请输入与您的账户关联的电子邮件地址。',
			'auth.forgot_password.title' => '忘记密码？',
			'auth.form.label.email' => '电子邮箱',
			'auth.form.label.new_password' => '新密码',
			'auth.form.label.password' => '密码',
			'auth.form.label.password_confirm' => '确认密码',
			'auth.form.label.user_role' => '选择用户类型',
			'auth.form.label.username' => '用户名',
			'auth.form.validation.email_required' => '请输入您的电子邮箱',
			'auth.form.validation.invalid_email' => '请输入有效的电子邮箱',
			'auth.form.validation.invalid_password_length' => '密码必须至少 6 个字符',
			'auth.form.validation.password_confirm_required' => '请确认您的密码',
			'auth.form.validation.password_mismatch' => '密码不匹配',
			'auth.form.validation.password_required' => '请输入密码',
			'auth.form.validation.user_role_required' => '请选择用户类型',
			'auth.form.validation.username_required' => '请输入用户名',
			'auth.login.button.create_account_link' => '创建新账户',
			'auth.login.button.forgot_password_link' => '忘记密码？',
			'auth.login.button.submit' => '登录',
			'auth.login.form.validation.email_password_required' => '请填写电子邮箱和密码。',
			'auth.login.role_selection_dialog.body' => '欢迎！\n请选择您的账户类型以继续。',
			'auth.login.role_selection_dialog.title' => '完成注册',
			'auth.login.subtitle' => '欢迎回来\n好久不见',
			'auth.login.title' => '在此登录',
			'auth.otp_verification.button.resend_code' => '没有收到代码？重新发送',
			'auth.otp_verification.button.submit' => '验证',
			'auth.otp_verification.message.code_resent' => '代码已重新发送！',
			'auth.otp_verification.resend_time_countdown' => ({required Object seconds}) => '${seconds} 秒后重新发送',
			'auth.otp_verification.subtitle' => ({required Object email}) => '请输入我们发送到您邮箱 ${email} 的代码',
			'auth.otp_verification.title' => '输入验证码',
			'auth.register.button.login_link' => '已有账户',
			'auth.register.button.submit' => '注册',
			'auth.register.registration_success_dialog.body' => '请检查您的电子邮箱进行验证。',
			'auth.register.registration_success_dialog.title' => '注册成功',
			'auth.register.subtitle' => '创建一个账户，以便您可以探索所有\n现有工作',
			'auth.register.title' => '创建账户',
			'auth.reset_password.button.submit' => '重置密码',
			'auth.reset_password.subtitle' => '请输入您的新密码',
			'auth.reset_password.title' => '重置密码',
			'auth.reset_password_success.body' => '您已成功重置密码。登录时请使用您的新密码。',
			'auth.reset_password_success.button.login_page_link' => '返回登录',
			'auth.reset_password_success.title' => '密码重置成功！',
			'auth.user_role.caregiver' => '护理员/帮手',
			'auth.user_role.nurse' => '护士',
			'auth.user_role.patient' => '患者',
			'auth.user_role.pharmacist' => '药剂师',
			'auth.user_role.physiotherapist' => '物理治疗师',
			'auth.user_role.radiologist' => '放射科医生',
			'booking.addon.empty' => '没有可用的附加服务。',
			'booking.addon.estimated_budget' => '预计预算',
			'booking.addon.title.kDefault' => '附加服务',
			'booking.addon.title.nursing' => '护理程序',
			'booking.addon.title.pharmacy' => 'Pharmacist Services',
			'booking.addon.title.radiology' => 'Radiologist Services',
			'booking.addon.title.specialized_nursing' => '专业护理程序',
			'booking.book_appointment' => '预约',
			'booking.health_status.empty_record' => '没有可用的医疗记录。',
			'booking.health_status.mobility_detail_hint' => '例如：拐杖、助行架、其他',
			'booking.health_status.mobility_label' => '选择您的行动状态',
			'booking.health_status.record_hint' => '请选择记录',
			'booking.health_status.record_label' => '选择相关的健康记录',
			'booking.health_status.title' => '个人案例详情',
			'booking.issue.add_issue_button' => '添加主诉',
			'booking.issue.add_issue_title' => '添加问题',
			'booking.issue.default_page_title' => '服务请求',
			'booking.issue.delete_dialog.content' => '您确定要删除此问题吗？',
			'booking.issue.delete_dialog.title' => '删除问题',
			'booking.issue.edit_issue_title' => '编辑问题',
			'booking.issue.empty_issue' => '尚未添加任何问题。\n 请添加一个或多个问题，以便\n您可以继续下一步。',
			'booking.issue.fill_complaint_instruction' => '请选择本服务的主诉问题',
			'booking.issue.form.add_button' => '添加',
			'booking.issue.form.complaint_description_hint' => '请输入与您的案例相关的问题、疑虑、相关症状以及相关关键字。',
			'booking.issue.form.complaint_label' => '主诉',
			'booking.issue.form.complaint_title_hint' => '告诉我们要咨询的问题',
			'booking.issue.form.title_description_required' => '问题标题和描述为必填项。',
			'booking.issue.images' => '图片',
			'booking.issue.messages.add_issue_success' => '问题添加成功',
			'booking.issue.messages.edit_issue_success' => '问题更新成功',
			'booking.issue.nurse_page_title' => '护士服务请求',
			'booking.issue.pharmacy_page_title' => '药师服务请求',
			'booking.issue.radiology_page_title' => '放射科医生服务请求',
			'booking.issue.updated_on' => ({required Object date}) => '更新于：${date}',
			'booking.professional_detail.about_me' => '关于我',
			'booking.professional_detail.certificates' => '专业证书',
			'booking.professional_detail.experience_label' => '经验',
			'booking.professional_detail.id_number' => ({required Object number}) => 'ID 号码：${number}',
			'booking.professional_detail.issued_on' => ({required Object date}) => '签发日期：${date}',
			'booking.professional_detail.no_certificate' => '暂无证书。',
			'booking.professional_detail.no_reviews' => '暂无评论。',
			'booking.professional_detail.patients_label' => '患者',
			'booking.professional_detail.rating_label' => '评分',
			'booking.professional_detail.reviews' => '评论',
			'booking.professional_detail.schedule_button' => '安排预约',
			'booking.professional_detail.see_all_button' => '查看全部',
			'booking.professional_detail.title.kDefault' => '专业人员详情',
			'booking.professional_detail.title.nurse' => '护士详情',
			'booking.professional_detail.title.pharmacist' => '药剂师详情',
			'booking.professional_detail.title.radiologist' => '放射科医生详情',
			'booking.professional_detail.working_info' => '工作信息',
			'booking.professional_search.appointment_button' => '预约',
			'booking.professional_search.empty' => '未找到符合您标准的专业人员。',
			'booking.professional_search.filter_text' => ({required Object count}) => '按 ${count} 个选定服务过滤',
			'booking.professional_search.title.caregiver' => '搜索护理员/帮手/工人',
			'booking.professional_search.title.kDefault' => '搜索专业人员',
			'booking.professional_search.title.nurse' => '搜索护士',
			'booking.professional_search.title.pharmacist' => '搜索药剂师',
			'booking.professional_search.title.radiologist' => '搜索放射科医生',
			'booking.schedule.empty_slots' => '该日没有可用的时段。',
			'booking.schedule.messages.reschedule_failed' => '重新安排失败。',
			'booking.schedule.messages.reschedule_success' => '预约重新安排成功',
			'booking.schedule.select_date' => '选择日期',
			'booking.schedule.select_hour' => '选择时间',
			'booking.schedule.submit_button' => '提交',
			'booking.schedule.submitting_button' => '正在提交...',
			'booking.schedule.title' => '选择时间表',
			'dashboard.allied_services' => '辅助医疗',
			'dashboard.chat_ai_placeholder' => '咨询AI医生，解答您的健康疑问',
			'dashboard.greeting' => ({required Object displayName}) => '更长寿，更健康，${displayName}！',
			'dashboard.services.diabetic_care' => 'iRX糖尿病护理',
			'dashboard.services.dietitian' => '营养师服务',
			'dashboard.services.health_risk_assessment' => '健康风险评估',
			'dashboard.services.home_screening' => '居家健康筛查',
			'dashboard.services.homecare_for_elderly' => '长者家政维修',
			'dashboard.services.nursing' => ' 上门护士',
			'dashboard.services.pharmacist' => 'iRX 药师服务',
			'dashboard.services.physiotherapy' => '物理治疗',
			'dashboard.services.precision_nutrition' => '精准营养',
			'dashboard.services.remote_patient_monitoring' => '远程健康监测',
			'dashboard.services.second_opinion' => '医学影像第二意见',
			'dashboard.services.sleep_and_mental_health' => '睡眠与心理健康',
			'global.add' => '添加',
			'global.book_now' => '立即预订',
			'global.cancel' => '取消',
			'global.complete' => '完成',
			'global.confirm' => '确认',
			'global.delete' => '删除',
			'global.description' => '描述',
			'global.dialog.coming_soon' => '敬请期待',
			'global.dialog.feature_available_soon' => '此功能即将推出！',
			'global.edit_information' => '编辑信息',
			'global.error' => '错误',
			'global.error_message' => ({required Object error}) => '错误：${error}',
			'global.messages.delete_success' => '删除成功',
			'global.messages.updated_success' => '更新成功',
			'global.modify' => '修改',
			'global.next' => '下一步',
			'global.no' => '否',
			'global.no_data' => '暂无数据',
			'global.none' => '无',
			'global.not_specified' => '未指定',
			'global.ok' => '确定',
			'global.other' => '其他',
			'global.ready' => '准备就绪',
			'global.remove' => '移除',
			'global.retry' => '重试',
			'global.save' => '保存',
			'global.saving' => '正在保存...',
			'global.services' => '服务',
			'global.status' => '状态',
			'global.submit' => '提交',
			'global.unknown_location' => '未知位置',
			'global.update' => '更新',
			'global.yes' => '是',
			'nursing.services.primary_nursing.description' => '监测并执行从身体检查、给药、管饲和吸痰到注射及伤口护理的各项护理程序。',
			'nursing.services.primary_nursing.title' => '基础护理',
			'nursing.services.specialized_nursing.description' => '您只需专注于康复，将复杂的护理工作交给经验丰富的专业护理人员 。',
			'nursing.services.specialized_nursing.title' => '专科护理服务',
			'nursing.title' => '居家护理',
			'payment.error.appointment_id_missing' => '错误：缺少预约 ID。',
			'payment.feedback.enter_amount_hint' => '输入金额',
			'payment.feedback.enter_other_amount' => '输入其他金额',
			'payment.feedback.excellent' => '极好',
			'payment.feedback.give_tips' => ({required Object name}) => '给 ${name} 一些小费',
			'payment.feedback.rated_text' => ({required Object name, required Object stars}) => '您给 ${name} 评了 ${stars} 星',
			'payment.feedback.submit_btn' => '提交反馈',
			'payment.feedback.write_text_hint' => '在此写下您的反馈...',
			'payment.feedback_success.content' => '您的反馈已成功提交。',
			'payment.feedback_success.thank_you' => '谢谢！',
			'payment.feedback_success.view_detail_btn' => '查看预约详情',
			'payment.messages.failed' => ({required Object error}) => '支付失败：${error}',
			'payment.messages.feedback_failed' => ({required Object error}) => '反馈提交失败：${error}',
			'payment.messages.purchase_failed' => ({required Object error}) => '购买失败：${error}',
			'payment.methods.cash_offline' => '现金（线下支付）',
			'payment.offline_success.content' => '您的请求已成功提交。\n请在预约期间直接向专业人员支付。',
			'payment.offline_success.estimated_total' => '预计总额',
			'payment.offline_success.title' => '请求已提交',
			'payment.order_summary' => '订单摘要',
			'payment.pay_btn' => ({required Object amount}) => '支付 ${amount}',
			'payment.price_label' => '价格',
			'payment.return_home_btn' => '返回首页',
			'payment.select_method' => '选择支付方式',
			'payment.service_charge' => '服务费',
			'payment.subscription_success.content' => ({required Object planName}) => '您已成功购买 ${planName}',
			'payment.subscription_success.title' => '支付成功',
			'payment.success.amount' => '金额',
			'payment.success.content' => ({required Object name}) => '您的款项已成功发送给 ${name}。',
			'payment.success.experience_subtitle' => '您的反馈将帮助我们改善\n您的体验',
			'payment.success.experience_title' => '您的体验如何？',
			'payment.success.feedback_btn' => '请反馈',
			'payment.success.title' => '支付成功',
			'payment.title' => '支付',
			'payment.total_label' => '总计',
			'payment.validity_label' => '有效期',
			'pharmacy.services.health_coaching.description' => '提供个性化的指导与支持，助力实现健康目标、管理慢性疾病并提升整体健康水平。我们设有针对体重管理、糖尿病管理、高血压管理及高胆固醇管理的专项计划。',
			'pharmacy.services.health_coaching.title' => '健康指导',
			'pharmacy.services.medication_counseling.description' => '药物咨询与教育旨在指导患者正确使用药物、了解副作用并提高用药依从性，从而增强用药安全性并改善健康成效。',
			'pharmacy.services.medication_counseling.title' => '药物咨询\n与教育',
			'pharmacy.services.smoking_cessation.description' => '戒烟是指通过咨询、药物治疗和支持计划等策略停止吸烟，以改善健康状况并降低患吸烟相关疾病的风险。',
			'pharmacy.services.smoking_cessation.title' => '戒烟',
			'pharmacy.services.therapy_review.description' => '全面审查您的药物使用及生活方式，旨在优化治疗效果并最大限度地减少潜在的副作用。',
			'pharmacy.services.therapy_review.title' => '综合治疗审查',
			'pharmacy.title' => 'iRX 药师服务',
			'settings.account' => '帐户',
			'settings.app_language' => '语言设置',
			'settings.settings' => '设置',
			'store.consumable' => '医疗耗材',
			'store.messages.load_failed' => '加载产品失败',
			'store.no_products' => '暂无产品',
			'store.poct' => 'PoCT',
			'store.sort' => '排序',
			'store.title' => '医疗商店',
			_ => null,
		};
	}
}
