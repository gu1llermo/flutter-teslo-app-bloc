import 'package:flutter/material.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class GoRouterNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;
  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authBloc) {
    _authBloc.stream.listen((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;
  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
