import 'package:flutter/material.dart';
import 'package:demo2/page_config/base_model_logic.dart';

class MainModelLogic extends BaseModelLogic {
  goHome() async {
    await Navigator.of(context).pushNamed('/home');
  }

  goLogin() async {
    await Navigator.of(context).pushNamed('/login');
  }
}
