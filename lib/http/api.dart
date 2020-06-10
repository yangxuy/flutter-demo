import 'package:demo2/base_config/index.dart';

import 'http.dart';
import 'package:dio/dio.dart';

class Api{
  static login(param)async{
   return await httpManager.post('api/login_v2 ', param);
  }

  static login2(param)async{
    return HttpManager.getInstance(basePageUrl).post('api/login_v2', param);
  }

  static Stream<ResultData> login3(param){
    return  HttpManager().postRx('api/login_v2', param);
  }
}