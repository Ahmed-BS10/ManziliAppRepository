import 'package:bloc/bloc.dart';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/model/store_create_model.dart';
part 'register_store_state.dart';

class RegisterStoreCubit extends Cubit<RegisterStoreState> {
  RegisterStoreCubit() : super(RegisterStoreInitial());

  final AuthService authService = AuthService(apiService: ApiService());

  Future<void> register(StoreCreateModel store) async {
    emit(RegisterStoreLoading());

    final response = await authService.Storeregister(store);
    if (response.isSuccess)
      emit(RegisterStoreStateSuccess('تم تسجيل الدخول بنجاح'));
    else
      emit(RegisterStoreStateFailure(response.message));
  }
}
