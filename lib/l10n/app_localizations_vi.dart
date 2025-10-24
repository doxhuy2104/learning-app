// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get haveAccount => 'Đã có tài khoản?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Mật khẩu xác nhận';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get ortherLogin => 'Hoặc đăng nhập bằng';

  @override
  String get enterEmail => 'Nhập địa chỉ email';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get passwordMustLeast8Char => 'Mật khẩu cần ít nhất 8 kí tự';

  @override
  String get sendEmail => 'Gửi email';

  @override
  String get googleLogin => 'Đăng nhập bằng Google';
}
