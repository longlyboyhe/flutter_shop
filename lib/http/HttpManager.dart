import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/event/NetWorkEvent.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_shop/utils/ToastUtils.dart';

class HttpManager {
  static const String _GET = "get";
  static const String _POST = "post";
  static const String _DownLoad = "downLoad";
  static final EventBus eventBus = new EventBus();
  static Dio _dio;

  // 工厂模式
  factory HttpManager() => _getInstance();

  static HttpManager get instance => _getInstance();
  static HttpManager _instance;
  Map<String, String> headerMap;
  static int time = 0;

  static HttpManager _getInstance() {
    if (_instance == null) {
      _instance = HttpManager._internal();
    }
    return _instance;
  }

  HttpManager._internal() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo info) {
        initDio(info.model);
      });
    } else if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((AndroidDeviceInfo info) {
        initDio(info.model);
      });
    }
  }

  refreshHeader() async {
    Token token = await DataUtils.getTokenInfo();
    if (token != null && token.accessToken != null) {
      headerMap["Authorization"] = "Bearer ${token?.accessToken}";
    }
  }

  initDio(String model) async {
    headerMap = {
      'phoneType': '1',
      'phoneName': model,
//      'sequenceNo': '',
//      'token': ''
    };

    refreshHeader();

    // 或者通过传递一个 `options`来创建dio实例
    BaseOptions options = BaseOptions(
        baseUrl: Api.BASE_URL,
        connectTimeout: 5000,
        receiveTimeout: 300000,
        headers: headerMap,
        contentType: ContentType.parse("application/json;charset=utf-8"));
    _dio = new Dio(options);

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print(
          "-----------------------------------请求---------------------------------------");
      print("method: " + options.method.toString());
      print("header: " + options.headers.toString());
      print("url: " + options.uri.toString());
      if (options.method == "POST") {
        try {
          print("params： " + jsonEncode(options.data).toString());
        } catch (e) {
          print("params： " + "不能encode");
        }
      } else {
        print("params： " + options.queryParameters.toString());
      }
      print(
          "-------------------------------------请求--------------------------------------");
      return options; //continue
    }, onResponse: (Response response) {
      print("---------response------------->" + response.data.toString());
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("-----------error----------->" + e.toString());
      // Do something with response error
      return e; //continue
    }));
  }

  /*
   * callback      请求成功的json直接返回
   * errorCallback 请求不成功或者请求异常返回的errorMsg
   * @author longlyboyhe
   * @date 2018/12/22
   */
  void get(BuildContext context, String url, Function callback(json),
      {Map<String, String> params,
      Function errorCallback(String errorMsg)}) async {
    await _request(context, url, callback,
        method: _GET, params: params, errorCallback: errorCallback);
  }

  void post(BuildContext context, String url, Function callback(json),
      {Map params,
      Function headerCallback(headers),
      Function errorCallback(String errorMsg)}) async {
    await _request(context, url, callback,
        method: _POST,
        params: params,
        headerCallback: headerCallback,
        errorCallback: errorCallback);
  }

  void downLoad(BuildContext context, String url, String savePath,
      Function onSuccess(data),
      {Map<String, String> params,
      Function progress(int count, int total),
      Function errorCallback(String errorMsg)}) async {
    await _request(context, url, onSuccess,
        savePath: savePath,
        method: _DownLoad,
        params: params,
        progress: progress,
        errorCallback: errorCallback);
  }

  static Future _request(BuildContext context, String url, Function callback,
      {String method,
      Map params,
      Function headerCallback,
      Function errorCallback,
      Function progress(int count, int total),
      String savePath}) async {
    try {
      //没有网络
      var connectivityResult = await (Connectivity().checkConnectivity());
      eventBus.fire(NetWorkEvent(connectivityResult));
      if (connectivityResult == ConnectivityResult.none) {
        _handError(errorCallback, "没有网络");
        return;
      }

      Map paramMap = params == null ? new Map() : params;
      Response response;
      if (method == _GET) {
        response = await _dio.get(url, queryParameters: params);
      } else if (method == _POST) {
        response = await _dio.post(url, data: paramMap);
      } else if (method == _DownLoad) {
        File imageFile = File(savePath);
        if (!imageFile.existsSync()) {
          imageFile.createSync(recursive: true);
        }
        response = await _dio.download(url, imageFile.path,
            onReceiveProgress: progress, queryParameters: params);
      }

      if (response.statusCode != 200) {
        _handError(
            errorCallback, "网络请求错误,状态码:" + response.statusCode.toString());
        return;
      }
      print(
          "----------------------------------------response start--------------------------------------------");
      print("response request=${response.request}");
      print("response headers=${response.headers}");
      print("response statusCode=${response.statusCode}");
      print("response data=${response.data}");
      print(
          "----------------------------------------response end--------------------------------------------");
      if (callback != null) {
        callback(response.data);
        //TODO 以下方法要求接口返回数据的数据结构不能变 {result: {msg: 暂无数据, code: 404, is_success: false}, success: true}
      }
      checkToken(context, response);
      if (headerCallback != null) {
        headerCallback(response.headers);
      }
    } catch (exception) {
      _handError(errorCallback, exception.toString());
    }
  }

  void postForm(BuildContext context, String url, Map map, Function success,
      {Function onError}) async {
    try {
      Response response = await _dio.post(url, data: map);
      if (response.statusCode == 200) {
        success(response.data);
        checkToken(context, response);
      } else {
        onError("请求失败");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void delete(BuildContext context, String url, Function success,
      {Function onError, Map<String, String> params}) async {
    try {
      Response response = await _dio.delete(url, queryParameters: params);
      if (response.statusCode == 200) {
        success(response.data);
        checkToken(context, response);
      } else {
        onError("请求失败");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void put(BuildContext context, String url, Map map, Function success,
      {Function onError}) async {
    try {
      Response response = await _dio.put(url, data: map);
      if (response.statusCode == 200) {
        success(response.data);
        checkToken(context, response);
      } else {
        onError("请求失败");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  /*
   *上传单张图片
   */
  void uploadSingleImageFile(
      BuildContext context, String path, Function success,
      {Function onErr}) async {
    try {
      File file = File(path);
      String fileName = path.replaceAll(file.parent.path + "/", "");
      FormData formData = new FormData.from({
        "file": new UploadFileInfo(file, fileName),
      });
      Response response = await _dio.post(Api.IMAGE_UPLOAD, data: formData);
      if (response.statusCode == 200) {
        success(response.data);
        checkToken(context, response);
      } else {
        onErr("请求失败" + response.statusCode.toString());
      }
    } catch (e) {
      onErr("请求失败" + e.toString());
    }
  }

  /*
   * 上传多张图片
   */
  void uploadMultiImageFile(
      BuildContext context, List<dynamic> pathList, Function success,
      {Function onErr, String url = Api.IMAGES_UPLOAD}) async {
    List<UploadFileInfo> list = List();
    if (pathList != null) {
      for (String path in pathList) {
        File file = File(path);
        String fileName = path.replaceAll(file.parent.path + "/", "");
        list.add(new UploadFileInfo(file, fileName));
      }
    }
    FormData formData = new FormData.from({
      "file": list,
    });
    try {
      Response response = await _dio.post(url, data: formData);
      if (response.statusCode == 200) {
        success(response.data);
        checkToken(context, response);
      } else {
        onErr("请求失败" + response.statusCode.toString());
      }
    } catch (e) {
      onErr("请求失败" + e.toString());
    }
  }

  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorMsg = errorMsg != null ? errorMsg : "";
      errorCallback(errorMsg);
    }
    print("errorMsg :" + errorMsg);
  }

  static void checkToken(BuildContext context, Response response) {
    if (response.statusCode == 200) {
      BaseResp resp = BaseResp.fromJson(response.data);
      if (resp.result != null && resp.result.code == 200200) {
        DataUtils.clearLoginInfo();
        //token失效
        Navigator.pushNamedAndRemoveUntil(
            context, "/LoginPage", ModalRoute.withName('/'));
        ToastUtil.showToast(context, "登录失效，请重新登录");
      }
    }
  }
}
