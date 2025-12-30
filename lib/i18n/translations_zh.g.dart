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
	@override late final _TranslationsDashboardZh dashboard = _TranslationsDashboardZh._(_root);
	@override late final _TranslationsGlobalZh global = _TranslationsGlobalZh._(_root);
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
	@override String get cancel => '取消';
	@override late final _TranslationsGlobalDialogZh dialog = _TranslationsGlobalDialogZh._(_root);
	@override String get error => '错误';
	@override String get ok => '确定';
	@override String get services => '服务';
	@override String get submit => '提交';
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

// Path: dashboard.services
class _TranslationsDashboardServicesZh implements TranslationsDashboardServicesEn {
	_TranslationsDashboardServicesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get diabetic_care => 'iRX糖尿病护理。';
	@override String get dietitian => '营养师服务';
	@override String get health_risk_assessment => '健康风险评估';
	@override String get home_screening => '居家健康筛查';
	@override String get homecare_for_elderly => '家政维修';
	@override String get nursing => ' 上门护士。';
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
			'dashboard.allied_services' => '辅助医疗',
			'dashboard.chat_ai_placeholder' => '咨询AI医生，解答您的健康疑问',
			'dashboard.greeting' => ({required Object displayName}) => '更长寿，更健康，${displayName}！',
			'dashboard.services.diabetic_care' => 'iRX糖尿病护理。',
			'dashboard.services.dietitian' => '营养师服务',
			'dashboard.services.health_risk_assessment' => '健康风险评估',
			'dashboard.services.home_screening' => '居家健康筛查',
			'dashboard.services.homecare_for_elderly' => '家政维修',
			'dashboard.services.nursing' => ' 上门护士。',
			'dashboard.services.pharmacist' => 'iRX 药师服务',
			'dashboard.services.physiotherapy' => '物理治疗',
			'dashboard.services.precision_nutrition' => '精准营养',
			'dashboard.services.remote_patient_monitoring' => '远程健康监测',
			'dashboard.services.second_opinion' => '医学影像第二意见',
			'dashboard.services.sleep_and_mental_health' => '睡眠与心理健康',
			'global.cancel' => '取消',
			'global.dialog.coming_soon' => '敬请期待',
			'global.dialog.feature_available_soon' => '此功能即将推出！',
			'global.error' => '错误',
			'global.ok' => '确定',
			'global.services' => '服务',
			'global.submit' => '提交',
			_ => null,
		};
	}
}
