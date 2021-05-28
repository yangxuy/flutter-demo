import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'package:ball/ball.dart';

class KlineLogic extends BaseModelLogic {
  BallManager pm;

  @override
  init(arguments) {
    pm = BallManager();
    pm.initState();
    initData();
  }

  initData() async {
    var response = await Request.get(action: 'ball');
    print(response);
    List<BasePointModel> list = (response as List)
        .map((e) => BasePointModel(title: e))
        .cast<BasePointModel>()
        .toList();
    pm.generatePoints(list);
  }
}
