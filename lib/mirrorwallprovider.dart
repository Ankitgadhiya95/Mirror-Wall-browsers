import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'main.dart';

class MirrorWallProvider with ChangeNotifier {
  TextEditingController search = TextEditingController();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  TextEditingController urlController = TextEditingController();
  String url = "";
  String google = "https://www.google.com/";
  String yahoo = "https://in.search.yahoo.com/";
  String bing = "https://www.bing.com/";
  String duckduckgo = "https://duckduckgo.com/";
  Status? fruit = Status.Google;
  List<String> bookmark = [];



  get getSearch {
    return search;
  }
  set setSearch(value) {
    search = value;
    notifyListeners();
  }

  get getWebViewController {
    return search;
  }
  set setWebViewController(value) {
    webViewController = value;
    notifyListeners();
  }

  get getPullToRefreshController {
    return search;
  }
  set setPullToRefreshController(value) {
    pullToRefreshController = value;
    notifyListeners();
  }

  get getUrlController {
    return search;
  }
  set setUrlController( value) {
    urlController = value;
    notifyListeners();
  }

  get getUrl {
    return search;
  }
  set setUrl( value) {
    url = value;
    notifyListeners();
  }

  get getFruit {
    return search;
  }
  set setFruit( value) {
    fruit = value;
    notifyListeners();
  }

  get getBookmark {
    return search;
  }
  set setBookmark( value) {
    url = value;
    notifyListeners();
  }





}
