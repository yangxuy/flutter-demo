import 'dart:convert';
import 'package:novel/novel.dart';
import 'package:flutter/services.dart';

class Request {
  static Future<dynamic> get({String action, Map params}) async {
    return Request.mock(action: action, params: params);
  }

  static Future<dynamic> post({String action, Map params}) async {
    return Request.mock(action: action, params: params);
  }

  static Future<dynamic> mock({String action, Map params}) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson['data'];
  }
}

class SectionApi {
  static Future<Section> fetchSection(int articleId) async {
    var response = await Request.get(action: 'article_$articleId');
    var article = Section.fromJson(response);

    return article;
  }
}
