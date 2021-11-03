import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cat/constants/api_constants.dart';
import 'package:flutter_cat/page/cat_identify_page.dart';
import 'package:flutter_cat/bean/result_bean.dart';
import 'package:flutter_cat/page/result_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 主页面
class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Dio _dio = Dio();

  /// 拍照传回来的图片
  Uint8List? _unit8list;

  /// 百度Api请求token
  String? _token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    _getBaiDuToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("猫脸识别"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _unit8list != null
                ? Image.memory(
                    _unit8list!,
                    width: 200.w,
                  )
                : Container(),
            SizedBox(
              height: 20.w,
            ),
            GestureDetector(
              onTap: () {
                _toIdentifyPage();
              },
              child: Container(
                alignment: Alignment.center,
                height: 40.w,
                width: 120.w,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "拍照识别",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 跳转至拍照页并获取回传数据
  void _toIdentifyPage() {
    Navigator.push(context,
            CupertinoPageRoute(builder: (context) => CatIdentifyPage()))
        .then((value) async {
      if (value == null) {
        return;
      }
      setState(() {
        _unit8list = base64.decode(value);
      });
      _requestIdentify(value);
    });
  }

  /// 请求验证图片
  void _requestIdentify(var value) async {
    EasyLoading.show(status: '识别中...');
    Map<String, dynamic> headerMap = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    Map<String, dynamic> body = {
      "image": value,
      "baike_num": 99,
    };
    var response = await _dio.post(
        "${ApiConstants.API_IDENTIFY}?access_token=$_token",
        data: body,
        options: Options(
            method: 'post',
            headers: headerMap,
            contentType: "application/x-www-form-urlencoded",
            responseType: ResponseType.json));
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      ResultBean resultBean = ResultBean.fromJson(response.data);
      if (resultBean.error_msg == null) {
        // 识别成功跳转至结果展示页
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ResultPage(
                      resultBean: resultBean,
                    )));
      } else {
        EasyLoading.showError(resultBean.error_msg ?? "");
      }
    } else {
      EasyLoading.showError(response.statusMessage ?? "");
      print(response.statusCode);
      print(response.statusMessage);
    }
  }

  /// 获取百度识别的token，因为token有效期是30天 所以这里只在启动App的时候请求一次
  void _getBaiDuToken() async {
    var response = await _dio.post(
        "${ApiConstants.API_GET_TOKEN}?grant_type=client_credentials&client_id=${ApiConstants.API_KEY}&client_secret=${ApiConstants.API_SECRET}",
        options: Options(
            method: 'post',
            contentType: "application/x-www-form-urlencoded",
            responseType: ResponseType.json));
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      _token = response.data["access_token"];
    } else {
      print("请求token失败${response.statusMessage}");
    }
  }
}
