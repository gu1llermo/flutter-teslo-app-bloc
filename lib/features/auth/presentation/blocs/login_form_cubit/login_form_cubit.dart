import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/inputs.dart';

part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  final Function(String, String) loginUserCallback;
  LoginFormCubit({required this.loginUserCallback}) : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    emit(state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password])));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    emit(state.copyWith(
        password: newPassword,
        isValid: Formz.validate([state.email, newPassword])));
  }

  onFormSubmit() async {
    _touchEveryField();
    print('Estoy en formSubmit');
    emit(state.copyWith(isPosting: true));
    await loginUserCallback(state.email.value, state.password.value);
    emit(state.copyWith(isPosting: false));
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password])));
  }
}
