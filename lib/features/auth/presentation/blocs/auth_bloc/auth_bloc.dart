import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/shared/infraestructure/services/key_value_storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthBloc({required this.authRepository, required this.keyValueStorageService})
      : super(const AuthState()) {
    on<LogOutEvent>(_logoutHandler);
    on<SetLoggedUserEvent>(_setUserHandler);
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      add(SetLoggedUserEvent(user));
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      add(SetLoggedUserEvent(user));
    } catch (e) {
      logout();
    }
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');
    add(LogOutEvent(errorMessage));
  }

  _logoutHandler(LogOutEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: event.errorMessage));
  }

  _setUserHandler(SetLoggedUserEvent event, Emitter<AuthState> emit) async {
    await keyValueStorageService.setKeyValue('token', event.user.token);
    emit(state.copyWith(
        user: event.user,
        authStatus: AuthStatus.authenticated,
        errorMessage: ''));
  }
}
