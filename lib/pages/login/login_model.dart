import 'dart:async';
import 'dart:collection';

import 'package:demo2/base_ext/model_ext.dart';
import 'package:demo2/http/api.dart';
import 'package:demo2/http/http.dart';
import 'package:demo2/page_config/base_model_logic.dart';
import 'package:demo2/route_config/pop_route/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo2/base_ext/stream_ext.dart';

class LoginModelLogic extends BaseModelLogic with LoadingModel {
  GlobalKey formKey = new GlobalKey<FormState>();
  TextEditingController unameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  handlerLogin() async{
    // if ((formKey.currentState as FormState).validate()) {}
    var map = new SplayTreeMap<String, dynamic>();
    map['country'] = '+86';
    map['system'] = 'pc';
    map['did'] = 'c1db1fe9461ea8444436ee6b03551d22';
    map['user_name'] = '13116130675';
    map['password'] = 'd58d5e95358d2980b7aa02f6661e7b90c869e5fed397011d7ca72fcd88a48d9f';
    map['time'] = 'time';
    map['platform'] = 1;
    map['language'] = 'zh';
    map['sign'] = '79d98728cc7d08ee504822bca8bd4d70';
//    await Api.login2(map);
    Api.login(map)
        .autoDisposed(this, () {
      print('cancel');
    })
        .autoDialog(this)
        .listen((ResultData event) {
      print(event.code);
    });
  }
}
