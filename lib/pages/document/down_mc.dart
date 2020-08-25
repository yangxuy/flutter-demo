import 'package:yx_demo/page_config/base_model_logic.dart';

class DownMC extends BaseModelLogic {
  String title = '';

  changeTitle(String v) {
    title = v;
    notify();
  }
}
