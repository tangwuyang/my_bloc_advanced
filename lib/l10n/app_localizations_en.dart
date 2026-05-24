// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locale => 'en';

  @override
  String get title => 'Task Management App';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get loginScreenTitle => 'Login';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get accountScreenTitle => 'Account';

  @override
  String get tasksScreenTitle => 'Tasks';

  @override
  String get taskSaveScreenTitle => 'Save or Update Task';

  @override
  String get drawerMenuHome => 'Home';

  @override
  String get drawerSettingsTitle => 'Settings';

  @override
  String get drawerLogoutTitle => 'Logout';

  @override
  String get drawerTasks => 'Tasks';

  @override
  String get pageSettingsTitle => 'Settings';

  @override
  String get firstName => 'First Name';

  @override
  String get taskPrice => 'Task Price';

  @override
  String get taskName => 'Task Name';

  @override
  String get save => 'Save';
}
