import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UserTokenCubit extends Cubit<UserTokenState> {
  UserTokenCubit() : super(UserTokenInitialState()) {
    loadUserToken();
  }

  Future<void> saveToken(String userToken) async {
    emit(UserTokenLoadedState(userToken));
    await secureStorage.write(key: 'usertoken', value: userToken);
  }

  Future<void> deleteToken() async {
    emit(UserTokenInitialState());
    await secureStorage.delete(key: 'usertoken');
  }

  void loadUserToken() async {
    try {
      final userToken = await secureStorage.read(key: 'usertoken');
      if (userToken != null) {
        saveToken(userToken);
      }
    } catch (error) {
      print(error);
    }
  }
}

abstract class UserTokenState {}

class UserTokenInitialState extends UserTokenState {}

class UserTokenLoadedState extends UserTokenState {
  final String token;

  UserTokenLoadedState(this.token);
}
