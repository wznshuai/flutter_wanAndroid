import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wan/model/bannerModel.dart';
import 'baseState.dart';
import 'constants/urlConstants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class IndexWidget extends StatefulWidget {
  @override
  _IndexWidgetState createState() => _IndexWidgetState();
}

class _IndexWidgetState extends BaseState<IndexWidget> {
  var dio = new Dio();
  BannerListModel datas;

  @override
  void initState() {
    _getBanner();
  }

  @override
  Widget build(BuildContext context) {
    print('********** ${jsonEncode(datas)}');
    return Container(
      color: Colors.red,
      child: CustomScrollView(
        slivers: <Widget>[
          Banner(message: null, location: null)
        ],
      ),
    );
  }

  _getBanner() async {
    Response<Map<String, dynamic>> data = await dio.get(bannerUrl);
    if (null != data) {
      setState(() {
        datas = BannerListModel.fromJson(data.data);
      });
    }
  }
}
