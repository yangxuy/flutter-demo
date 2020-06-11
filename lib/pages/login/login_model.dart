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

  handlerLogin() {
    // if ((formKey.currentState as FormState).validate()) {}
    var map = new SplayTreeMap<String, dynamic>();
    map['country'] = '+86';
    map['system'] = 'pc';
    map['did'] = 'xxxx';
    map['user_name'] = 'xxxx';
    map['password'] = 'xxxx';
    map['time'] = 'time';
    map['platform'] = 1;
    map['language'] = 'xx';
    map['sign'] = 'xx';
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
