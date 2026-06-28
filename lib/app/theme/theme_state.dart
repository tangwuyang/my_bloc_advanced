part of 'theme_bloc.dart';
class ThemeState {
  final AppThemePalette palette;
  final ThemeMode themeMode;

  const ThemeState({this.palette = AppThemePalette.classic, this.themeMode = ThemeMode.system});
  ThemeState copyWith({AppThemePalette? palette, ThemeMode? themeMode}) {
    return ThemeState(palette: palette ?? this.palette, themeMode: themeMode ?? this.themeMode);
  }
}