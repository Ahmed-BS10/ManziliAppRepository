import 'package:bloc/bloc.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/controller/cubit/login_state.dart';
import 'package:manziliapp/model/login_model.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;

  LoginCubit(this.authService) : super(LoginInitial());

  Future<void> login(LoginModel loginModel) async {
    emit(LoginLoading());

    final response =
        await authService.login(loginModel.Email, loginModel.Password);
    if (response.isSuccess)
      emit(LoginSuccess('تم تسجيل الدخول بنجاح'));
    else
      emit(LoginFailure(response.message));
  }
}
