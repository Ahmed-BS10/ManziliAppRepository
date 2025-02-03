import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/features/auhentication/cubit/register_state.dart';
import 'package:manziliapp/features/auhentication/model/user_create_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final AuthService authService = AuthService(apiService: ApiService());

  Future<void> register(UserCreateModel user) async {
    emit(RegisterLoading());

    final response = await authService.register(user);
    if (response.isSuccess)
      emit(RegisterSuccess('تم تسجيل الدخول بنجاح'));
    else
      emit(RegisterFailure(response.message));
  }
}
