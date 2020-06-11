import 'package:demo2/base_config/index.dart';
import 'package:demo2/entity/base_entity.dart';
import 'package:dio/dio.dart';

/// 统一返回数据的格式
class ResultData <T>{
  int code; // 返回code  0 代表成功
  String msg; // 返回日志
  T data; // 返回数据体

  ResultData({this.data, this.msg, this.code});

  ResultData.fromJson(Map json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'];
  }
}

/// 自定义Header
Map<String, dynamic> httpHeaders = {
  'Accept': 'application/json,*/*',
  'Content-Type': 'application/json; charset=utf-8',
};

/*
* 1 全局单例
* 2 能提供多cdn配置
* 3 包含日志
* 4 返回统一数据结构
* 5 包含错误处理
* 6 提供stream流处理
 */

/// HttpManager
class HttpManager {
  Dio _dio;

  /// 工厂模式--》单例
  factory HttpManager() => _shareInstance();
  static HttpManager _instance;

  static HttpManager _shareInstance(){
    if (_instance == null) {
      _instance = HttpManager._(base: null);
    }
    return _instance;
  }

  /// 多cdn配置
  static HttpManager getInstance(String baseUrl) {
    return HttpManager._(base: baseUrl);
  }

  /// 工具类
  HttpManager._({String base}) {
    BaseOptions options = BaseOptions(
      baseUrl: base ?? basePageUrl,
      connectTimeout: 15000,
//      headers: httpHeaders,
    );
    _dio = new Dio(options);

    ///添加日志-->根据需求合理打印日志
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    ));
  }

  // 请求拦截 这里对请求数据做统一处理 比如：添加公共参数，添加token等
  RequestOptions onRequest(RequestOptions options) {
    print('请求BaseUrl：${options.baseUrl}');
    print('请求路径：${options.path}');
    if (options.method == 'GET') {
      print('请求参数：${options.queryParameters.toString()}');
    }
    if (options.method == 'POST') {
      print('请求参数：${options.data.toString()}');
    }

    if (options.headers['Cookie'] == null) {
      // cookie判断
    }

    if (options.headers['token'] == null) {
      // token判断
      options.headers['token'] = '1373a739fd8599909738511f41831623';
    }
    return options;
  }

  // 返回拦截
  Response onResponse(Response response) {
    print('返回请求${response.request.path}的数据：${response.data.toString()}');
    ResultData resultData = ResultData.fromJson(response.data);
    response.data = resultData;
    return response;
  }

  onError(DioError e) async {
    print(e);
    print('错误类型：${e.type}');

    /// 这里自己定义返回错误code
    return await _dio
        .resolve(Response(data: ResultData(code: -1, msg: e.error.toString())));
  }

  /// get async
  Future<ResultData> get(String path, Map param) async {
    Response<ResultData> response = await _dio.get<ResultData>(
      path,
      queryParameters: param,
    );

    return response.data;
  }

  ///post async
  Future<ResultData> post(path, param,{CancelToken cancelToken}) async {
    Response<ResultData> response = await _dio.post(path, data: param,cancelToken: cancelToken);
    ResultData resultData = response.data;
    return resultData;
  }

  /// get stream
  Stream<ResultData> getRx(path, param) {
    return Stream.fromFuture(get(path, param));
  }

  /// post stream
  Stream<ResultData> postRx(path, param) {
    return Stream.fromFuture(post(path, param));
  }
}

/// 单例使用httpManager调用
final HttpManager httpManager = HttpManager();