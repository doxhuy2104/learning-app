// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get createAccount => 'Create account';

  @override
  String get ortherLogin => 'Or login with';

  @override
  String get enterEmail => 'Enter email address';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get enterConfirmPassword => 'Enter confirm password';

  @override
  String get confirmPasswordError =>
      'Passwords do not match, please enter again!';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordT => 'Forgot password';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordMustLeast8Char => 'Password must be at least 8 characters';

  @override
  String get sendEmail => 'Send email';

  @override
  String get googleLogin => 'Login with Google';

  @override
  String get home => 'Home';

  @override
  String get account => 'Account';

  @override
  String get practice => 'Practice';

  @override
  String get exam => 'Exam';

  @override
  String get close => 'Close';

  @override
  String get emailInUse => 'Email already in use';

  @override
  String get success => 'Success';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get register_success => 'Registration successful';

  @override
  String get errorTitle => 'Failed';

  @override
  String get fullName => 'Full name';

  @override
  String get enterName => 'Enter full name';

  @override
  String get invalidName => 'Please enter name';

  @override
  String get logout => 'Log out';

  @override
  String get confirmLogout => 'Confirm log out';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get accountInfo => 'Account infomation';

  @override
  String get groupSelection => 'Group selection';

  @override
  String get selectBlock => 'Select block';

  @override
  String get selectGroup => 'Select group';

  @override
  String get save => 'Save';

  @override
  String get examQuestions => 'Exam questions';

  @override
  String get history => 'History';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get submit => 'Submit';

  @override
  String get exit => 'Exit';

  @override
  String get exitTitle => 'Are you sure you want to exit?';

  @override
  String get exitMessage => 'Your test progress will not be saved';

  @override
  String get submitTitle => 'Are you sure you want to submit?';

  @override
  String get submitMessage =>
      'The system will automatically score and display the results for you';

  @override
  String submitMessage1(num count) {
    return 'You still have $count unanswered questions';
  }

  @override
  String get seeAll => 'See all';
}
