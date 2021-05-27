import '../kline.dart';

enum YKChartType { Unknown, MA, BOOL }

class KlineDataManager {
  static final List<int> priceMaList = [5, 10, 30];
  static final List<int> volumeMaList = [5, 10];

  static List<Market> calculateKlineData(
      YKChartType type, List<Market> dataList) {
    switch (type) {
      case YKChartType.MA:
        return _calculatePriceMa(dataList);
      case YKChartType.BOOL:
        return _calculateVolumeMa(dataList);
      default:
        return dataList;
    }
  }

  static List<Market> _calculatePriceMa(List<Market> dataList) {
    List<Market> tmpList = dataList;
    int listCount = tmpList.length;
    for (int i = 0; i <= listCount - 1; i++) {
      ///计算priceMa
      for (int numIndex = 0; numIndex < priceMaList.length; numIndex++) {
        int maNum = priceMaList[numIndex];
        if (maNum <= 0) {
          return tmpList;
        }
        Market market = tmpList[i];
        if ((market.priceMa1 == null) ||
            (market.priceMa2 == null) ||
            (market.priceMa3 == null)) {
          if (i >= maNum - 1) {
            Market lastData = tmpList[i - 1];
            double lastMa;
            if (lastData != null) {
              switch (numIndex) {
                case 0:
                  lastMa = lastData.priceMa1;
                  break;
                case 1:
                  lastMa = lastData.priceMa2;
                  break;
                case 2:
                  lastMa = lastData.priceMa3;
                  break;
                default:
                  break;
              }
            }
            double priceMa = 0;
            if (lastMa != null) {
              Market deleteData = tmpList[i - maNum];
              priceMa = lastMa * maNum + market.close - deleteData.close;
            } else {
              List<Market> aveArray = tmpList.sublist(0, maNum);
              for (var tmpData in aveArray) {
                priceMa += tmpData.close;
              }
            }

            priceMa = priceMa / maNum;
            switch (numIndex) {
              case 0:
                tmpList[i].priceMa1 = priceMa;
                break;
              case 1:
                tmpList[i].priceMa2 = priceMa;
                break;
              case 2:
                tmpList[i].priceMa3 = priceMa;
                break;
              default:
                break;
            }
          }
        }
      }

      ///vol ma
      for (int numIndex = 0; numIndex < volumeMaList.length; numIndex++) {
        int maNum = volumeMaList[numIndex];

        if (maNum <= 0) {
          return tmpList;
        }

        Market market = tmpList[i];
        if ((market.volMa1 == null) || (market.volMa2 == null)) {
          if (i >= maNum - 1) {
            Market lastData = tmpList[i - 1];
            double lastMa;
            if (lastData != null) {
              switch (numIndex) {
                case 0:
                  lastMa = lastData.volMa1;
                  break;
                case 1:
                  lastMa = lastData.volMa2;
                  break;
                default:
                  break;
              }
            }
            double volMa = 0;
            if (lastMa != null) {
              Market deleteData = tmpList[i - maNum];
              volMa = lastMa * maNum + market.vol - deleteData.vol;
            } else {
              List<Market> aveArray = tmpList.sublist(0, maNum);
              for (var tmpData in aveArray) {
                volMa += tmpData.vol;
              }
            }

            volMa = volMa / maNum;
            switch (numIndex) {
              case 0:
                tmpList[i].volMa1 = volMa;
                break;
              case 1:
                tmpList[i].volMa2 = volMa;
                break;
              default:
                break;
            }
          }
        }
      }
    }
    return tmpList;
  }

  static List<Market> _calculateVolumeMa(List<Market> dataList) {
    // TODO： 计算幅图Ma数据
    List<Market> tmpList = dataList;

    return tmpList;
  }

  ///计算MA
  static double getPriceMa(List<Market> dataList, int index) {
    double priceMa;
    int len = dataList.length;
    if (dataList.length >= index) {
      if (dataList[len - 2].priceMa1 != null) {
        switch (index) {
          case 5:
            priceMa = (dataList[len - 2].priceMa1 * index -
                dataList[len - index - 1].close +
                dataList.last.close) /
                index;
            break;
          case 10:
            priceMa = (dataList[len - 2].priceMa2 * index -
                dataList[len - index - 1].close +
                dataList.last.close) /
                index;
            break;
          case 30:
            priceMa = (dataList[len - 2].priceMa3 * index -
                dataList[len - index - 1].close +
                dataList.last.close) /
                index;
            break;
        }
      } else {
        priceMa = getReduce(dataList.sublist(0, index)) / index;
      }
    }
    return priceMa;
  }

  static num getReduce(List<Market> dataList) {
    num cur = 0;
    for (int i = 0; i < dataList.length; i++) {
      cur += dataList[i].close;
    }
    return cur;
  }
}
