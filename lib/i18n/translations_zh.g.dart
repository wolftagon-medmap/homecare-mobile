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
	@override late final _TranslationsChatbotZh chatbot = _TranslationsChatbotZh._(_root);
	@override late final _TranslationsDashboardZh dashboard = _TranslationsDashboardZh._(_root);
	@override late final _TranslationsGlobalZh global = _TranslationsGlobalZh._(_root);
	@override late final _TranslationsGuidedBookingZh guidedBooking = _TranslationsGuidedBookingZh._(_root);
	@override late final _TranslationsHealthProfileZh healthProfile = _TranslationsHealthProfileZh._(_root);
	@override late final _TranslationsMessagingZh messaging = _TranslationsMessagingZh._(_root);
	@override late final _TranslationsNursingZh nursing = _TranslationsNursingZh._(_root);
	@override late final _TranslationsPaymentZh payment = _TranslationsPaymentZh._(_root);
	@override late final _TranslationsPharmacyZh pharmacy = _TranslationsPharmacyZh._(_root);
	@override late final _TranslationsPricingZh pricing = _TranslationsPricingZh._(_root);
	@override late final _TranslationsSettingsZh settings = _TranslationsSettingsZh._(_root);
	@override late final _TranslationsSharedBookingZh sharedBooking = _TranslationsSharedBookingZh._(_root);
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
	@override late final _TranslationsBookingConfirmationZh confirmation = _TranslationsBookingConfirmationZh._(_root);
	@override late final _TranslationsBookingHealthStatusZh health_status = _TranslationsBookingHealthStatusZh._(_root);
	@override late final _TranslationsBookingIssueZh issue = _TranslationsBookingIssueZh._(_root);
	@override late final _TranslationsBookingProfessionalDetailZh professional_detail = _TranslationsBookingProfessionalDetailZh._(_root);
	@override late final _TranslationsBookingProfessionalSearchZh professional_search = _TranslationsBookingProfessionalSearchZh._(_root);
	@override late final _TranslationsBookingScheduleZh schedule = _TranslationsBookingScheduleZh._(_root);
}

// Path: chatbot
class _TranslationsChatbotZh implements TranslationsChatbotEn {
	_TranslationsChatbotZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => 'M2Health AI 助手';
	@override String get heroGreeting => '你好！我是你的';
	@override String get heroName => 'M2Health AI 健康助手。';
	@override String get heroBody => '告诉我你哪里不舒服，我会帮你了解下一步可以怎么做。';
	@override String get composerHint => '输入你的消息…';
	@override String get composerHintWelcome => '或在这里输入你的问题…';
	@override String get send => '发送';
	@override String get privacyLabel => '（HIPAA 隐私）';
	@override String get privacyDetail => '你的对话是私密的。健康信息经过加密，并按照我们的隐私政策（符合 PDPA / HIPAA）处理。你可以随时查看或删除此对话。';
	@override String get benefitsTitle => '为什么使用 M2Health AI 助手？';
	@override String get benefitUnderstand => '了解你的健康疑虑';
	@override String get benefitExplain => '用简单的语言获得清晰解释';
	@override String get benefitSaveTime => '节省时间，减少猜测';
	@override String get benefitConnect => '更快连接到合适的照护';
	@override String get disclaimerBody => '此 AI 助手仅提供一般信息，不能取代专业的医疗建议、诊断或治疗。如遇医疗紧急情况，请立即就医。';
	@override String get errorTitle => '助手暂时无法使用';
	@override String get retry => '重试';
	@override String get history => '对话记录';
	@override String get newConversation => '新对话';
	@override String get newConversationTitle => '开始新的对话？';
	@override String get newConversationBody => '此对话将以只读形式保存在你的记录中。';
	@override String get startNew => '开始新对话';
	@override String get cancel => '取消';
	@override String get historyTitle => '对话记录';
	@override String get historyEmpty => '还没有对话。';
	@override String get historyError => '无法加载你的对话';
	@override String get sessionUntitled => '健康对话';
	@override String get sessionActive => '进行中';
	@override String get sessionReadOnly => '只读';
	@override String get deleteTitle => '删除对话';
	@override String get deleteBody => '此对话将从本设备删除，且无法恢复。';
	@override String get delete => '删除';
	@override String get voiceInput => '语音输入';
	@override String get transcribing => '正在转写…';
	@override String get micDeniedTitle => '需要麦克风权限';
	@override String get micDeniedBody => '麦克风权限已被拒绝。请在设备设置中开启后再使用语音输入。';
	@override String get openSettings => '打开设置';
}

// Path: dashboard
class _TranslationsDashboardZh implements TranslationsDashboardEn {
	_TranslationsDashboardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get chat_ai_placeholder => '咨询AI医生，解答您的健康疑问';
	@override String greeting({required Object displayName}) => '更长寿，更健康，${displayName}！';
	@override String get greeting_generic => '更长寿，更健康！';
	@override String get header_error => '无法加载您的个人资料。';
	@override String get retry => '重试';
	@override late final _TranslationsDashboardHomeZh home = _TranslationsDashboardHomeZh._(_root);
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

// Path: guidedBooking
class _TranslationsGuidedBookingZh implements TranslationsGuidedBookingEn {
	_TranslationsGuidedBookingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get namespace_title => '预约服务';
	@override late final _TranslationsGuidedBookingSubServiceZh sub_service = _TranslationsGuidedBookingSubServiceZh._(_root);
	@override late final _TranslationsGuidedBookingIssuesZh issues = _TranslationsGuidedBookingIssuesZh._(_root);
	@override late final _TranslationsGuidedBookingAddOnsZh add_ons = _TranslationsGuidedBookingAddOnsZh._(_root);
	@override late final _TranslationsGuidedBookingProfessionalZh professional = _TranslationsGuidedBookingProfessionalZh._(_root);
	@override late final _TranslationsGuidedBookingScheduleZh schedule = _TranslationsGuidedBookingScheduleZh._(_root);
	@override late final _TranslationsGuidedBookingReviewZh review = _TranslationsGuidedBookingReviewZh._(_root);
	@override late final _TranslationsGuidedBookingSentZh sent = _TranslationsGuidedBookingSentZh._(_root);
	@override late final _TranslationsGuidedBookingStatusZh status = _TranslationsGuidedBookingStatusZh._(_root);
	@override late final _TranslationsGuidedBookingCtaZh cta = _TranslationsGuidedBookingCtaZh._(_root);
}

// Path: healthProfile
class _TranslationsHealthProfileZh implements TranslationsHealthProfileEn {
	_TranslationsHealthProfileZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get namespace_title => '健康档案';
	@override String get entry_tile => '我的健康档案';
	@override late final _TranslationsHealthProfileListZh list = _TranslationsHealthProfileListZh._(_root);
	@override late final _TranslationsHealthProfileSectionZh section = _TranslationsHealthProfileSectionZh._(_root);
}

// Path: messaging
class _TranslationsMessagingZh implements TranslationsMessagingEn {
	_TranslationsMessagingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '消息';
	@override String get emptyTitle => '暂无对话';
	@override String get emptyBody => '发送预约请求后，您可以在此与专业人员沟通。';
	@override String get composerHint => '输入消息';
	@override String get threadClosed => '此对话已结束。';
	@override String get sayHello => '打个招呼';
	@override late final _TranslationsMessagingTimeProposalZh timeProposal = _TranslationsMessagingTimeProposalZh._(_root);
	@override late final _TranslationsMessagingEstimateRevisionZh estimateRevision = _TranslationsMessagingEstimateRevisionZh._(_root);
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

// Path: pricing
class _TranslationsPricingZh implements TranslationsPricingEn {
	_TranslationsPricingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get estimate_title => '费用估算';
	@override String get estimate_total => '预计总额';
	@override String get estimate_disclaimer => '此为估算金额。您将在上门服务时向专业人员付款。';
	@override String get estimate_empty => '请选择服务以查看估算。';
	@override String get add_ons => '附加项目';
	@override String hours({required Object count}) => '${count} 小时';
	@override String per_hour({required Object price}) => '每小时 ${price}';
	@override String get rates_title => '我的服务价格';
	@override String get rates_subtitle => '设定您每项服务的收费。可高于标准价，但不可低于标准价。';
	@override String get rates_empty => '您还没有添加任何服务。';
	@override String get rates_error => '无法加载您的价格。';
	@override String get rates_saved => '价格已保存。';
	@override String get your_price => '您的价格';
	@override String standard_price({required Object price}) => '标准价 ${price}';
	@override String at_least({required Object price}) => '不得低于 ${price}';
	@override String get not_a_number => '请输入价格';
	@override String get charging_standard => '按标准价收费';
	@override String get save => '保存';
	@override String get floor_title => '标准价格';
	@override String get floor_subtitle => '所有专业人员的收费下限。上调后，低于此价的收费将一并上调。';
	@override String get floor_error => '无法加载标准价格。';
	@override String get floor_saved => '标准价格已更新。';
	@override String floor_lifted({required Object count}) => '已有 ${count} 项专业人员价格上调至新标准价。';
	@override String get floor_new_price => '新标准价';
	@override String get revision_title => '修订后估算';
	@override String get revision_proposed => '已提出修订';
	@override String get revision_approved => '已批准';
	@override String get revision_rejected => '已拒绝';
	@override String revision_was({required Object price}) => '原为 ${price}';
	@override String revision_now({required Object price}) => '现为 ${price}';
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

// Path: sharedBooking
class _TranslationsSharedBookingZh implements TranslationsSharedBookingEn {
	_TranslationsSharedBookingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String starting_from({required Object price}) => '起价 ${price}';
	@override String from_price({required Object price}) => '起 ${price}';
	@override String get empty_title => '这里还没有内容';
	@override String get error_title => '出了点问题';
	@override String get retry => '重试';
	@override late final _TranslationsSharedBookingStatusZh status = _TranslationsSharedBookingStatusZh._(_root);
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
	@override String get pathologist => '病理学家';
	@override String get nutritionist => '营养师';
	@override String get psychologist => '心理学家';
	@override String get optometrist => '验光师';
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

// Path: booking.confirmation
class _TranslationsBookingConfirmationZh implements TranslationsBookingConfirmationEn {
	_TranslationsBookingConfirmationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get address_label => '上门地址';
	@override String get change_button => '更改';
	@override String get confirm_button => '确认预约';
	@override String get no_address => '尚未选择地址';
	@override String get patient_label => '患者';
	@override String get professional_label => '专业人员';
	@override String get services_label => '服务';
	@override String get time_label => '时间';
	@override String get title => '确认预约';
	@override String get total_label => '总计';
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
	@override late final _TranslationsBookingProfessionalSearchVisitAddressZh visit_address = _TranslationsBookingProfessionalSearchVisitAddressZh._(_root);
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

// Path: dashboard.home
class _TranslationsDashboardHomeZh implements TranslationsDashboardHomeEn {
	_TranslationsDashboardHomeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get section_title => '医疗服务';
	@override String get section_subtitle => '为您和家人提供专业照护。';
	@override String get view_all => '查看全部服务';
	@override String get all_services_title => '全部服务';
	@override String get badge_new => '新';
	@override String get name_pharmacist => '药剂师咨询';
	@override String get name_physiotherapy => '物理治疗';
	@override String get name_psychologist => '心理咨询';
	@override String get name_dietitian => '营养师';
	@override String get name_optometrist => '验光配镜';
	@override String get name_nursing => '居家护理';
	@override String get name_diabetic_care => '糖尿病筛查';
	@override String get name_home_screening => '居家健康检查';
	@override String get name_second_opinion => '医学影像第二意见';
	@override String get name_homecare_elderly => '长者居家照护';
	@override String get desc_pharmacist => '专业用药建议，并提供戒烟支持。';
	@override String get desc_physiotherapy => '缓解疼痛，改善活动能力，加快康复。';
	@override String get desc_psychologist => '为压力、情绪与心理健康提供支持。';
	@override String get desc_dietitian => '为您量身定制的营养方案，助您更健康。';
	@override String get desc_optometrist => '眼部护理、视力检查与专业建议。';
	@override String get desc_nursing => '在家中享受专业护理服务。';
	@override String get desc_diabetic_care => '检查眼部与足部，及早发现糖尿病并发症。';
	@override String get desc_home_screening => '足不出户，轻松完成健康检查。';
	@override String get desc_second_opinion => '由专家为您的影像检查提供第二诊断意见。';
	@override String get desc_homecare_elderly => '日常生活协助与陪伴服务。';
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

// Path: guidedBooking.sub_service
class _TranslationsGuidedBookingSubServiceZh implements TranslationsGuidedBookingSubServiceEn {
	_TranslationsGuidedBookingSubServiceZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '您需要哪项服务？';
	@override String get empty => '此处暂无可用服务。';
}

// Path: guidedBooking.issues
class _TranslationsGuidedBookingIssuesZh implements TranslationsGuidedBookingIssuesEn {
	_TranslationsGuidedBookingIssuesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '我们能为您做些什么？';
	@override String get subtitle => '请选择一项或多项。';
	@override String get remarks_label => '备注（选填）';
	@override String get remarks_hint => '还有什么需要让我们的医护人员知道的吗？';
	@override String get add_ons_link => '添加项目或附加服务';
	@override String get error => '无法加载问题列表。';
	@override String get empty => '此服务暂未列出就诊原因。';
}

// Path: guidedBooking.add_ons
class _TranslationsGuidedBookingAddOnsZh implements TranslationsGuidedBookingAddOnsEn {
	_TranslationsGuidedBookingAddOnsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '还需要添加什么吗？';
	@override String get subtitle => '选填，单独计价。';
	@override String get empty => '此服务暂无附加项目。';
	@override String selected({required Object count}) => '已添加 ${count} 项';
	@override String get no_description => '此附加服务暂无更多说明。';
}

// Path: guidedBooking.professional
class _TranslationsGuidedBookingProfessionalZh implements TranslationsGuidedBookingProfessionalEn {
	_TranslationsGuidedBookingProfessionalZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '选择医护人员';
	@override String get view_profile => '查看资料';
	@override String get select_cta => '选择这位医护人员';
	@override String get location_label => '上门地址';
	@override String get location_empty => '添加地址以查看可服务的人员';
	@override String get location_loading => '正在查找您保存的地址';
	@override String get change_location => '更改';
	@override String get picker_title => '我们应该上门到哪里？';
	@override String get add_address => '添加新地址';
	@override String get loading => '正在查找您附近的医护人员';
	@override String get empty => '该地址暂无可服务的医护人员，请尝试其他地址。';
	@override String get error => '无法加载医护人员列表。';
	@override String years({required Object years}) => '${years} 年经验';
	@override String reviews({required Object count}) => '（${count}）';
	@override String get choose_cta => '选择这位专业人员';
	@override String get search_hint => '按姓名搜索';
}

// Path: guidedBooking.schedule
class _TranslationsGuidedBookingScheduleZh implements TranslationsGuidedBookingScheduleEn {
	_TranslationsGuidedBookingScheduleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '您希望什么时候？';
	@override String get select_date => '选择日期';
	@override String get select_hour => '选择时间';
	@override String chosen({required Object day, required Object time}) => '${day} ${time}';
	@override String get loading => '正在查询可预约时间';
	@override String get empty => '当天没有空档。';
	@override String get error => '无法加载可预约时间。';
	@override String get no_days => '该医护人员目前没有空档。';
}

// Path: guidedBooking.review
class _TranslationsGuidedBookingReviewZh implements TranslationsGuidedBookingReviewEn {
	_TranslationsGuidedBookingReviewZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '核对您的申请';
	@override String get service => '服务';
	@override String get issues => '就诊原因';
	@override String get remarks => '备注';
	@override String get add_ons => '附加项目';
	@override String get location => '上门地址';
	@override String get professional => '医护人员';
	@override String get schedule => '希望的时间';
	@override String get estimate => '预计总额';
	@override String get estimate_note => '仅为预估。现在不会扣款，费用在上门服务时结算。';
	@override String get edit => '修改';
	@override String get none => '无';
	@override String get send => '发送申请';
}

// Path: guidedBooking.sent
class _TranslationsGuidedBookingSentZh implements TranslationsGuidedBookingSentEn {
	_TranslationsGuidedBookingSentZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '申请已发送';
	@override String body({required Object name}) => '我们已将您的申请转交给 ${name}，一有回复便会通知您。';
	@override String get body_generic => '我们已转交您的申请，一旦有人接单便会通知您。';
	@override String get message => '联系医护人员';
	@override String get view_status => '查看申请状态';
	@override String get done => '返回首页';
}

// Path: guidedBooking.status
class _TranslationsGuidedBookingStatusZh implements TranslationsGuidedBookingStatusEn {
	_TranslationsGuidedBookingStatusZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '您的申请';
	@override String reference({required Object id}) => '申请编号 #${id}';
	@override String submitted({required Object date}) => '发送于 ${date}';
	@override String get preferred => '您希望的时间';
	@override String get proposed => '对方建议的时间';
	@override String pending_body({required Object name}) => '您的申请正由 ${name} 处理，一有回复我们便会通知您。';
	@override String confirmed_body({required Object name}) => '${name} 已确认您的预约，届时见。';
	@override String proposed_body({required Object name}) => '${name} 当时不方便，建议了另一个时间。';
	@override String get cancelled_body => '此申请已取消。您随时可以重新发起。';
	@override String get accept_time => '接受该时间';
	@override String get choose_another => '另选时间';
	@override String get cancel_request => '取消申请';
	@override String get message => '消息';
}

// Path: guidedBooking.cta
class _TranslationsGuidedBookingCtaZh implements TranslationsGuidedBookingCtaEn {
	_TranslationsGuidedBookingCtaZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get kContinue => '继续';
	@override String get skip => '跳过';
}

// Path: healthProfile.list
class _TranslationsHealthProfileListZh implements TranslationsHealthProfileListEn {
	_TranslationsHealthProfileListZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '只更新您想更新的内容，全部为选填。';
	@override String get not_started => '尚未填写';
	@override String updated({required Object date}) => '更新于 ${date}';
	@override String get loading => '正在加载您的健康档案';
	@override String get empty => '暂无可填写的部分。';
	@override String get error => '无法加载您的健康档案。';
}

// Path: healthProfile.section
class _TranslationsHealthProfileSectionZh implements TranslationsHealthProfileSectionEn {
	_TranslationsHealthProfileSectionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '能填多少填多少，随时可以回来继续。';
	@override String get save => '保存';
	@override String get saved => '已保存';
	@override String get save_failed => '无法保存此部分。';
	@override String get loading => '正在加载此部分';
	@override String get error => '无法加载此部分。';
	@override String get add_other => '添加其他';
	@override String get add_attachment => '添加附件';
	@override String attachment({required Object n}) => '报告 ${n}';
	@override String get discard_title => '放弃修改？';
	@override String get discard_body => '此部分有未保存的修改。';
	@override String get discard => '放弃';
	@override String get keep_editing => '继续填写';
}

// Path: messaging.timeProposal
class _TranslationsMessagingTimeProposalZh implements TranslationsMessagingTimeProposalEn {
	_TranslationsMessagingTimeProposalZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '已提议其他时间';
	@override String get youAskedFor => '您原本要求';
	@override String get proposed => '建议时间';
	@override String get accept => '接受';
	@override String get chooseAnother => '另选时间';
	@override String get heldFor => '此时段将保留有限时间';
	@override String get suggestAnother => '建议其他时间';
	@override String get sheetTitleProfessional => '建议其他时间';
	@override String get sheetTitlePatient => '哪个时间方便？';
	@override String get sendSuggestion => '发送建议';
	@override String get sendTime => '发送此时间';
	@override String get reasonLabel => '原因？（选填）';
	@override String get reasonHint => '简短说明有助于对方同意。';
}

// Path: messaging.estimateRevision
class _TranslationsMessagingEstimateRevisionZh implements TranslationsMessagingEstimateRevisionEn {
	_TranslationsMessagingEstimateRevisionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '修订后的费用估算';
	@override String get newTotal => '新的预估总额';
	@override String get approve => '批准';
	@override String get approved => '已批准';
	@override String get withdrawn => '已撤回';
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
	@override late final _TranslationsPharmacyServicesReviewAndCounselingZh review_and_counseling = _TranslationsPharmacyServicesReviewAndCounselingZh._(_root);
	@override late final _TranslationsPharmacyServicesSmokingCessationZh smoking_cessation = _TranslationsPharmacyServicesSmokingCessationZh._(_root);
}

// Path: sharedBooking.status
class _TranslationsSharedBookingStatusZh implements TranslationsSharedBookingStatusEn {
	_TranslationsSharedBookingStatusZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get pending => '等待确认';
	@override String get confirmed => '已确认';
	@override String get proposed => '已提议其他时间';
	@override String get cancelled => '已取消';
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
	@override String get username => '姓名';
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
	@override String get username_required => '请输入姓名';
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

// Path: booking.professional_search.visit_address
class _TranslationsBookingProfessionalSearchVisitAddressZh implements TranslationsBookingProfessionalSearchVisitAddressEn {
	_TranslationsBookingProfessionalSearchVisitAddressZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get add_new => '添加新地址';
	@override String get empty => '添加地址';
	@override String get loading => '正在加载地址...';
	@override String get picker_title => '选择上门地址';
	@override String get title => '上门地址';
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

// Path: pharmacy.services.review_and_counseling
class _TranslationsPharmacyServicesReviewAndCounselingZh implements TranslationsPharmacyServicesReviewAndCounselingEn {
	_TranslationsPharmacyServicesReviewAndCounselingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '全面的药物评估与专家指导，助您有效管理副作用、提高用药依从性并优化健康成效。';
	@override String get title => '全面的用药评估与指导';
}

// Path: pharmacy.services.smoking_cessation
class _TranslationsPharmacyServicesSmokingCessationZh implements TranslationsPharmacyServicesSmokingCessationEn {
	_TranslationsPharmacyServicesSmokingCessationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get description => '戒烟是指通过咨询、药物治疗和支持计划等策略停止吸烟，以改善健康状况并降低患吸烟相关疾病的风险。';
	@override String get title => '戒烟';
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
			'auth.form.label.username' => '姓名',
			'auth.form.validation.email_required' => '请输入您的电子邮箱',
			'auth.form.validation.invalid_email' => '请输入有效的电子邮箱',
			'auth.form.validation.invalid_password_length' => '密码必须至少 6 个字符',
			'auth.form.validation.password_confirm_required' => '请确认您的密码',
			'auth.form.validation.password_mismatch' => '密码不匹配',
			'auth.form.validation.password_required' => '请输入密码',
			'auth.form.validation.user_role_required' => '请选择用户类型',
			'auth.form.validation.username_required' => '请输入姓名',
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
			'auth.user_role.pathologist' => '病理学家',
			'auth.user_role.nutritionist' => '营养师',
			'auth.user_role.psychologist' => '心理学家',
			'auth.user_role.optometrist' => '验光师',
			'booking.addon.empty' => '没有可用的附加服务。',
			'booking.addon.estimated_budget' => '预计预算',
			'booking.addon.title.kDefault' => '附加服务',
			'booking.addon.title.nursing' => '护理程序',
			'booking.addon.title.pharmacy' => 'Pharmacist Services',
			'booking.addon.title.radiology' => 'Radiologist Services',
			'booking.addon.title.specialized_nursing' => '专业护理程序',
			'booking.book_appointment' => '预约',
			'booking.confirmation.address_label' => '上门地址',
			'booking.confirmation.change_button' => '更改',
			'booking.confirmation.confirm_button' => '确认预约',
			'booking.confirmation.no_address' => '尚未选择地址',
			'booking.confirmation.patient_label' => '患者',
			'booking.confirmation.professional_label' => '专业人员',
			'booking.confirmation.services_label' => '服务',
			'booking.confirmation.time_label' => '时间',
			'booking.confirmation.title' => '确认预约',
			'booking.confirmation.total_label' => '总计',
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
			'booking.professional_search.visit_address.add_new' => '添加新地址',
			'booking.professional_search.visit_address.empty' => '添加地址',
			'booking.professional_search.visit_address.loading' => '正在加载地址...',
			'booking.professional_search.visit_address.picker_title' => '选择上门地址',
			'booking.professional_search.visit_address.title' => '上门地址',
			'booking.schedule.empty_slots' => '该日没有可用的时段。',
			'booking.schedule.messages.reschedule_failed' => '重新安排失败。',
			'booking.schedule.messages.reschedule_success' => '预约重新安排成功',
			'booking.schedule.select_date' => '选择日期',
			'booking.schedule.select_hour' => '选择时间',
			'booking.schedule.submit_button' => '提交',
			'booking.schedule.submitting_button' => '正在提交...',
			'booking.schedule.title' => '选择时间表',
			'chatbot.title' => 'M2Health AI 助手',
			'chatbot.heroGreeting' => '你好！我是你的',
			'chatbot.heroName' => 'M2Health AI 健康助手。',
			'chatbot.heroBody' => '告诉我你哪里不舒服，我会帮你了解下一步可以怎么做。',
			'chatbot.composerHint' => '输入你的消息…',
			'chatbot.composerHintWelcome' => '或在这里输入你的问题…',
			'chatbot.send' => '发送',
			'chatbot.privacyLabel' => '（HIPAA 隐私）',
			'chatbot.privacyDetail' => '你的对话是私密的。健康信息经过加密，并按照我们的隐私政策（符合 PDPA / HIPAA）处理。你可以随时查看或删除此对话。',
			'chatbot.benefitsTitle' => '为什么使用 M2Health AI 助手？',
			'chatbot.benefitUnderstand' => '了解你的健康疑虑',
			'chatbot.benefitExplain' => '用简单的语言获得清晰解释',
			'chatbot.benefitSaveTime' => '节省时间，减少猜测',
			'chatbot.benefitConnect' => '更快连接到合适的照护',
			'chatbot.disclaimerBody' => '此 AI 助手仅提供一般信息，不能取代专业的医疗建议、诊断或治疗。如遇医疗紧急情况，请立即就医。',
			'chatbot.errorTitle' => '助手暂时无法使用',
			'chatbot.retry' => '重试',
			'chatbot.history' => '对话记录',
			'chatbot.newConversation' => '新对话',
			'chatbot.newConversationTitle' => '开始新的对话？',
			'chatbot.newConversationBody' => '此对话将以只读形式保存在你的记录中。',
			'chatbot.startNew' => '开始新对话',
			'chatbot.cancel' => '取消',
			'chatbot.historyTitle' => '对话记录',
			'chatbot.historyEmpty' => '还没有对话。',
			'chatbot.historyError' => '无法加载你的对话',
			'chatbot.sessionUntitled' => '健康对话',
			'chatbot.sessionActive' => '进行中',
			'chatbot.sessionReadOnly' => '只读',
			'chatbot.deleteTitle' => '删除对话',
			'chatbot.deleteBody' => '此对话将从本设备删除，且无法恢复。',
			'chatbot.delete' => '删除',
			'chatbot.voiceInput' => '语音输入',
			'chatbot.transcribing' => '正在转写…',
			'chatbot.micDeniedTitle' => '需要麦克风权限',
			'chatbot.micDeniedBody' => '麦克风权限已被拒绝。请在设备设置中开启后再使用语音输入。',
			'chatbot.openSettings' => '打开设置',
			'dashboard.chat_ai_placeholder' => '咨询AI医生，解答您的健康疑问',
			'dashboard.greeting' => ({required Object displayName}) => '更长寿，更健康，${displayName}！',
			'dashboard.greeting_generic' => '更长寿，更健康！',
			'dashboard.header_error' => '无法加载您的个人资料。',
			'dashboard.retry' => '重试',
			'dashboard.home.section_title' => '医疗服务',
			'dashboard.home.section_subtitle' => '为您和家人提供专业照护。',
			'dashboard.home.view_all' => '查看全部服务',
			'dashboard.home.all_services_title' => '全部服务',
			'dashboard.home.badge_new' => '新',
			'dashboard.home.name_pharmacist' => '药剂师咨询',
			'dashboard.home.name_physiotherapy' => '物理治疗',
			'dashboard.home.name_psychologist' => '心理咨询',
			'dashboard.home.name_dietitian' => '营养师',
			'dashboard.home.name_optometrist' => '验光配镜',
			'dashboard.home.name_nursing' => '居家护理',
			'dashboard.home.name_diabetic_care' => '糖尿病筛查',
			'dashboard.home.name_home_screening' => '居家健康检查',
			'dashboard.home.name_second_opinion' => '医学影像第二意见',
			'dashboard.home.name_homecare_elderly' => '长者居家照护',
			'dashboard.home.desc_pharmacist' => '专业用药建议，并提供戒烟支持。',
			'dashboard.home.desc_physiotherapy' => '缓解疼痛，改善活动能力，加快康复。',
			'dashboard.home.desc_psychologist' => '为压力、情绪与心理健康提供支持。',
			'dashboard.home.desc_dietitian' => '为您量身定制的营养方案，助您更健康。',
			'dashboard.home.desc_optometrist' => '眼部护理、视力检查与专业建议。',
			'dashboard.home.desc_nursing' => '在家中享受专业护理服务。',
			'dashboard.home.desc_diabetic_care' => '检查眼部与足部，及早发现糖尿病并发症。',
			'dashboard.home.desc_home_screening' => '足不出户，轻松完成健康检查。',
			'dashboard.home.desc_second_opinion' => '由专家为您的影像检查提供第二诊断意见。',
			'dashboard.home.desc_homecare_elderly' => '日常生活协助与陪伴服务。',
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
			'guidedBooking.namespace_title' => '预约服务',
			'guidedBooking.sub_service.title' => '您需要哪项服务？',
			'guidedBooking.sub_service.empty' => '此处暂无可用服务。',
			'guidedBooking.issues.title' => '我们能为您做些什么？',
			'guidedBooking.issues.subtitle' => '请选择一项或多项。',
			'guidedBooking.issues.remarks_label' => '备注（选填）',
			'guidedBooking.issues.remarks_hint' => '还有什么需要让我们的医护人员知道的吗？',
			'guidedBooking.issues.add_ons_link' => '添加项目或附加服务',
			'guidedBooking.issues.error' => '无法加载问题列表。',
			'guidedBooking.issues.empty' => '此服务暂未列出就诊原因。',
			'guidedBooking.add_ons.title' => '还需要添加什么吗？',
			'guidedBooking.add_ons.subtitle' => '选填，单独计价。',
			'guidedBooking.add_ons.empty' => '此服务暂无附加项目。',
			'guidedBooking.add_ons.selected' => ({required Object count}) => '已添加 ${count} 项',
			'guidedBooking.add_ons.no_description' => '此附加服务暂无更多说明。',
			'guidedBooking.professional.title' => '选择医护人员',
			'guidedBooking.professional.view_profile' => '查看资料',
			'guidedBooking.professional.select_cta' => '选择这位医护人员',
			'guidedBooking.professional.location_label' => '上门地址',
			'guidedBooking.professional.location_empty' => '添加地址以查看可服务的人员',
			'guidedBooking.professional.location_loading' => '正在查找您保存的地址',
			'guidedBooking.professional.change_location' => '更改',
			'guidedBooking.professional.picker_title' => '我们应该上门到哪里？',
			'guidedBooking.professional.add_address' => '添加新地址',
			'guidedBooking.professional.loading' => '正在查找您附近的医护人员',
			'guidedBooking.professional.empty' => '该地址暂无可服务的医护人员，请尝试其他地址。',
			'guidedBooking.professional.error' => '无法加载医护人员列表。',
			'guidedBooking.professional.years' => ({required Object years}) => '${years} 年经验',
			'guidedBooking.professional.reviews' => ({required Object count}) => '（${count}）',
			'guidedBooking.professional.choose_cta' => '选择这位专业人员',
			'guidedBooking.professional.search_hint' => '按姓名搜索',
			'guidedBooking.schedule.title' => '您希望什么时候？',
			'guidedBooking.schedule.select_date' => '选择日期',
			'guidedBooking.schedule.select_hour' => '选择时间',
			'guidedBooking.schedule.chosen' => ({required Object day, required Object time}) => '${day} ${time}',
			'guidedBooking.schedule.loading' => '正在查询可预约时间',
			'guidedBooking.schedule.empty' => '当天没有空档。',
			'guidedBooking.schedule.error' => '无法加载可预约时间。',
			'guidedBooking.schedule.no_days' => '该医护人员目前没有空档。',
			'guidedBooking.review.title' => '核对您的申请',
			'guidedBooking.review.service' => '服务',
			'guidedBooking.review.issues' => '就诊原因',
			'guidedBooking.review.remarks' => '备注',
			'guidedBooking.review.add_ons' => '附加项目',
			'guidedBooking.review.location' => '上门地址',
			'guidedBooking.review.professional' => '医护人员',
			'guidedBooking.review.schedule' => '希望的时间',
			'guidedBooking.review.estimate' => '预计总额',
			'guidedBooking.review.estimate_note' => '仅为预估。现在不会扣款，费用在上门服务时结算。',
			'guidedBooking.review.edit' => '修改',
			'guidedBooking.review.none' => '无',
			'guidedBooking.review.send' => '发送申请',
			'guidedBooking.sent.title' => '申请已发送',
			'guidedBooking.sent.body' => ({required Object name}) => '我们已将您的申请转交给 ${name}，一有回复便会通知您。',
			'guidedBooking.sent.body_generic' => '我们已转交您的申请，一旦有人接单便会通知您。',
			'guidedBooking.sent.message' => '联系医护人员',
			'guidedBooking.sent.view_status' => '查看申请状态',
			'guidedBooking.sent.done' => '返回首页',
			'guidedBooking.status.title' => '您的申请',
			'guidedBooking.status.reference' => ({required Object id}) => '申请编号 #${id}',
			'guidedBooking.status.submitted' => ({required Object date}) => '发送于 ${date}',
			'guidedBooking.status.preferred' => '您希望的时间',
			'guidedBooking.status.proposed' => '对方建议的时间',
			'guidedBooking.status.pending_body' => ({required Object name}) => '您的申请正由 ${name} 处理，一有回复我们便会通知您。',
			'guidedBooking.status.confirmed_body' => ({required Object name}) => '${name} 已确认您的预约，届时见。',
			'guidedBooking.status.proposed_body' => ({required Object name}) => '${name} 当时不方便，建议了另一个时间。',
			'guidedBooking.status.cancelled_body' => '此申请已取消。您随时可以重新发起。',
			'guidedBooking.status.accept_time' => '接受该时间',
			'guidedBooking.status.choose_another' => '另选时间',
			'guidedBooking.status.cancel_request' => '取消申请',
			'guidedBooking.status.message' => '消息',
			'guidedBooking.cta.kContinue' => '继续',
			'guidedBooking.cta.skip' => '跳过',
			'healthProfile.namespace_title' => '健康档案',
			'healthProfile.entry_tile' => '我的健康档案',
			'healthProfile.list.subtitle' => '只更新您想更新的内容，全部为选填。',
			'healthProfile.list.not_started' => '尚未填写',
			'healthProfile.list.updated' => ({required Object date}) => '更新于 ${date}',
			'healthProfile.list.loading' => '正在加载您的健康档案',
			'healthProfile.list.empty' => '暂无可填写的部分。',
			'healthProfile.list.error' => '无法加载您的健康档案。',
			'healthProfile.section.subtitle' => '能填多少填多少，随时可以回来继续。',
			'healthProfile.section.save' => '保存',
			'healthProfile.section.saved' => '已保存',
			'healthProfile.section.save_failed' => '无法保存此部分。',
			'healthProfile.section.loading' => '正在加载此部分',
			'healthProfile.section.error' => '无法加载此部分。',
			'healthProfile.section.add_other' => '添加其他',
			'healthProfile.section.add_attachment' => '添加附件',
			'healthProfile.section.attachment' => ({required Object n}) => '报告 ${n}',
			'healthProfile.section.discard_title' => '放弃修改？',
			'healthProfile.section.discard_body' => '此部分有未保存的修改。',
			'healthProfile.section.discard' => '放弃',
			'healthProfile.section.keep_editing' => '继续填写',
			'messaging.title' => '消息',
			'messaging.emptyTitle' => '暂无对话',
			'messaging.emptyBody' => '发送预约请求后，您可以在此与专业人员沟通。',
			'messaging.composerHint' => '输入消息',
			'messaging.threadClosed' => '此对话已结束。',
			'messaging.sayHello' => '打个招呼',
			'messaging.timeProposal.title' => '已提议其他时间',
			'messaging.timeProposal.youAskedFor' => '您原本要求',
			'messaging.timeProposal.proposed' => '建议时间',
			'messaging.timeProposal.accept' => '接受',
			'messaging.timeProposal.chooseAnother' => '另选时间',
			'messaging.timeProposal.heldFor' => '此时段将保留有限时间',
			'messaging.timeProposal.suggestAnother' => '建议其他时间',
			'messaging.timeProposal.sheetTitleProfessional' => '建议其他时间',
			'messaging.timeProposal.sheetTitlePatient' => '哪个时间方便？',
			'messaging.timeProposal.sendSuggestion' => '发送建议',
			'messaging.timeProposal.sendTime' => '发送此时间',
			'messaging.timeProposal.reasonLabel' => '原因？（选填）',
			'messaging.timeProposal.reasonHint' => '简短说明有助于对方同意。',
			'messaging.estimateRevision.title' => '修订后的费用估算',
			'messaging.estimateRevision.newTotal' => '新的预估总额',
			'messaging.estimateRevision.approve' => '批准',
			'messaging.estimateRevision.approved' => '已批准',
			'messaging.estimateRevision.withdrawn' => '已撤回',
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
			'pharmacy.services.review_and_counseling.description' => '全面的药物评估与专家指导，助您有效管理副作用、提高用药依从性并优化健康成效。',
			'pharmacy.services.review_and_counseling.title' => '全面的用药评估与指导',
			'pharmacy.services.smoking_cessation.description' => '戒烟是指通过咨询、药物治疗和支持计划等策略停止吸烟，以改善健康状况并降低患吸烟相关疾病的风险。',
			'pharmacy.services.smoking_cessation.title' => '戒烟',
			'pharmacy.title' => 'iRX 药师服务',
			'pricing.estimate_title' => '费用估算',
			'pricing.estimate_total' => '预计总额',
			'pricing.estimate_disclaimer' => '此为估算金额。您将在上门服务时向专业人员付款。',
			'pricing.estimate_empty' => '请选择服务以查看估算。',
			'pricing.add_ons' => '附加项目',
			'pricing.hours' => ({required Object count}) => '${count} 小时',
			'pricing.per_hour' => ({required Object price}) => '每小时 ${price}',
			'pricing.rates_title' => '我的服务价格',
			'pricing.rates_subtitle' => '设定您每项服务的收费。可高于标准价，但不可低于标准价。',
			'pricing.rates_empty' => '您还没有添加任何服务。',
			'pricing.rates_error' => '无法加载您的价格。',
			'pricing.rates_saved' => '价格已保存。',
			'pricing.your_price' => '您的价格',
			'pricing.standard_price' => ({required Object price}) => '标准价 ${price}',
			'pricing.at_least' => ({required Object price}) => '不得低于 ${price}',
			'pricing.not_a_number' => '请输入价格',
			'pricing.charging_standard' => '按标准价收费',
			'pricing.save' => '保存',
			'pricing.floor_title' => '标准价格',
			'pricing.floor_subtitle' => '所有专业人员的收费下限。上调后，低于此价的收费将一并上调。',
			'pricing.floor_error' => '无法加载标准价格。',
			'pricing.floor_saved' => '标准价格已更新。',
			'pricing.floor_lifted' => ({required Object count}) => '已有 ${count} 项专业人员价格上调至新标准价。',
			'pricing.floor_new_price' => '新标准价',
			'pricing.revision_title' => '修订后估算',
			'pricing.revision_proposed' => '已提出修订',
			'pricing.revision_approved' => '已批准',
			'pricing.revision_rejected' => '已拒绝',
			'pricing.revision_was' => ({required Object price}) => '原为 ${price}',
			'pricing.revision_now' => ({required Object price}) => '现为 ${price}',
			'settings.account' => '帐户',
			'settings.app_language' => '语言设置',
			'settings.settings' => '设置',
			'sharedBooking.starting_from' => ({required Object price}) => '起价 ${price}',
			'sharedBooking.from_price' => ({required Object price}) => '起 ${price}',
			'sharedBooking.empty_title' => '这里还没有内容',
			'sharedBooking.error_title' => '出了点问题',
			'sharedBooking.retry' => '重试',
			'sharedBooking.status.pending' => '等待确认',
			'sharedBooking.status.confirmed' => '已确认',
			'sharedBooking.status.proposed' => '已提议其他时间',
			'sharedBooking.status.cancelled' => '已取消',
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
