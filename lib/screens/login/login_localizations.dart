import 'package:commercio/i18n/translations.g.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

/// The strings package:flutterfire_ui uses for localizing are translated
/// by extending/implementing the fui10n.DefaultLocalizations class.
class LoginLocalilzations extends DefaultLocalizations {
  // The translations object needed to find the strings.
  final TranslationsEn _t;
  const LoginLocalilzations(this._t);

  @override
  String get signInWithGoogleButtonText => _t.login.signInWithGoogleButtonText;

  @override
  String get signInText => _t.login.signInText;

  @override
  String get registerText => _t.login.registerText;

  @override
  String get registerHintText => _t.login.registerHintText;

  @override
  String get signInHintText => _t.login.signInHintText;

  @override
  String get passwordIsRequiredErrorText =>
      _t.login.passwordIsRequiredErrorText;

  @override
  String get confirmPasswordIsRequiredErrorText =>
      _t.login.confirmPasswordIsRequiredErrorText;

  @override
  String get confirmPasswordDoesNotMatchErrorText =>
      _t.login.confirmPasswordDoesNotMatchErrorText;

  @override
  String get confirmPasswordInputLabel => _t.login.confirmPasswordInputLabel;

  @override
  String get forgotPasswordButtonLabel => _t.login.forgotPasswordButtonLabel;

  @override
  String get forgotPasswordViewTitle => _t.login.forgotPasswordViewTitle;

  @override
  String get resetPasswordButtonLabel => _t.login.resetPasswordButtonLabel;

  @override
  String get emailInputLabel => _t.login.emailInputLabel;

  @override
  String get passwordInputLabel => _t.login.passwordInputLabel;

  @override
  String get signInActionText => _t.login.signInActionText;

  @override
  String get registerActionText => _t.login.registerActionText;

  @override
  String get emailIsRequiredErrorText => _t.login.emailIsRequiredErrorText;

  @override
  String get isNotAValidEmailErrorText => _t.login.isNotAValidEmailErrorText;

  @override
  String get userNotFoundErrorText => _t.login.userNotFoundErrorText;

  @override
  String get emailTakenErrorText => _t.login.emailTakenErrorText;

  @override
  String get accessDisabledErrorText => _t.login.accessDisabledErrorText;

  @override
  String get wrongOrNoPasswordErrorText => _t.login.wrongOrNoPasswordErrorText;

  @override
  String get provideEmail => _t.login.provideEmail;

  @override
  String get goBackButtonLabel => _t.login.goBackButtonLabel;

  @override
  String get forgotPasswordHintText => _t.login.forgotPasswordHintText;

  @override
  String get passwordResetEmailSentText => _t.login.passwordResetEmailSentText;
}
