part of 'register_store_cubit.dart';

abstract class RegisterStoreState {}

final class RegisterStoreInitial extends RegisterStoreState {}

class RegisterStoreLoading extends RegisterStoreState {}

class RegisterStoreStateSuccess extends RegisterStoreState {
  final String message;
  RegisterStoreStateSuccess(this.message);
}

class RegisterStoreStateFailure extends RegisterStoreState {
  final String errorMessage;
  RegisterStoreStateFailure(this.errorMessage);
}
