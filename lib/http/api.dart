import 'http.dart';

class Api {
  static Stream<ResultData> login(param) {
    return httpManager.postRx('api/login_v2', param);
  }
}

