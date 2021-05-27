import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'package:kline/kline.dart';

class KlineLogic extends BaseModelLogic {
  KlineBloc klineBloc = KlineBloc();
  List<Market> dataList = [];

  @override
  init(arguments) {
    initData();
  }

  initData() async {
    var response = await Request.get(action: 'kline_data');
    for (int i = 0; i < response.length; i++) {
      var item = response[i];
      dataList.add(
        Market(
          item['open'],
          item['high'],
          item['low'],
          item['close'],
          item['vol'],
          item['id'],
        ),
      );
    }
    klineBloc.updateDataList(dataList);
  }
}
