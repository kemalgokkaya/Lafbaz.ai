// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:collection/collection.dart' as _i12;
import 'package:flutter/material.dart' as _i10;
import 'package:lafbaz_ai/src/model/chat_gpt_model.dart' as _i11;
import 'package:lafbaz_ai/src/screens/history_screen.dart' as _i1;
import 'package:lafbaz_ai/src/screens/home_screen.dart' as _i2;
import 'package:lafbaz_ai/src/screens/login_screen.dart' as _i3;
import 'package:lafbaz_ai/src/screens/profile_screen.dart' as _i4;
import 'package:lafbaz_ai/src/screens/register_screen.dart' as _i5;
import 'package:lafbaz_ai/src/screens/result_screen.dart' as _i6;
import 'package:lafbaz_ai/src/screens/settings_screen.dart' as _i7;
import 'package:lafbaz_ai/src/screens/splash_screen.dart' as _i8;

/// generated route for
/// [_i1.HistoryScreen]
class HistoryRoute extends _i9.PageRouteInfo<void> {
  const HistoryRoute({List<_i9.PageRouteInfo>? children})
    : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.HistoryScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.ProfileScreen]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i5.RegisterScreen]
class RegisterRoute extends _i9.PageRouteInfo<void> {
  const RegisterRoute({List<_i9.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i6.ResultScreen]
class ResultRoute extends _i9.PageRouteInfo<ResultRouteArgs> {
  ResultRoute({
    _i10.Key? key,
    required List<_i11.Suggestion> suggestions,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         ResultRoute.name,
         args: ResultRouteArgs(key: key, suggestions: suggestions),
         initialChildren: children,
       );

  static const String name = 'ResultRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResultRouteArgs>();
      return _i6.ResultScreen(key: args.key, suggestions: args.suggestions);
    },
  );
}

class ResultRouteArgs {
  const ResultRouteArgs({this.key, required this.suggestions});

  final _i10.Key? key;

  final List<_i11.Suggestion> suggestions;

  @override
  String toString() {
    return 'ResultRouteArgs{key: $key, suggestions: $suggestions}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResultRouteArgs) return false;
    return key == other.key &&
        const _i12.ListEquality<_i11.Suggestion>().equals(
          suggestions,
          other.suggestions,
        );
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i12.ListEquality<_i11.Suggestion>().hash(suggestions);
}

/// generated route for
/// [_i7.SettingsScreen]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute({List<_i9.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i8.SplashScreen]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SplashScreen();
    },
  );
}
