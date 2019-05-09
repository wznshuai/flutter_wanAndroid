import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wan/model/bannerModel.dart';
import 'baseState.dart';
import 'constants/urlConstants.dart';
import 'dart:convert';
import 'customer_widget/bannerView.dart';
import 'model/articleModel.dart';
import 'package:intl/intl.dart';

class IndexWidget extends StatefulWidget {
  @override
  _IndexWidgetState createState() => _IndexWidgetState();
}

class _IndexWidgetState extends BaseState<IndexWidget> {
  int page = 0;
  var dio = new Dio();
  BannerListModel bannerData;
  ArticleBaseModel articleData;

  @override
  void initState() {
    _getBanner();
    _getArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: BannerView(bannerData, (BuildContext context, int index) {
              return Image.network(
                bannerData.data[index].imagePath,
                fit: BoxFit.fitWidth,
              );
            }),
          ),
          getArticleList()
        ],
      ),
    );
  }

  Widget getArticleList() {
    List<Widget> get() {
      articleData.data.datas.map((d) {
        return ListTile(
          title: Text(d.title),
        );
      }).toList();
    }

    if (null != articleData && (articleData.data?.size ?? 0) > 0) {
      return SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
        var data = articleData.data.datas[index];
        return GestureDetector(
            onTap: () => {
            },
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("作者: ${data.author}"),
                          Text(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  data.publishTime)))
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(data.title,
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      alignment: Alignment.centerLeft,
                    ),
                  )
                ],
              ),
            ));
      }, childCount: articleData.data.datas.length));
    } else {
      return SliverToBoxAdapter(child: Container(child: Text('????')));
    }
  }

  _getBanner() async {
    Response<Map<String, dynamic>> data = await dio.get(bannerUrl);
    if (null != data) {
      print("banner data is $data");
      setState(() {
        bannerData = BannerListModel.fromJson(data.data);
      });
    }
  }

  _getArticle() async {
    var url = indexArticle(page);
    print('url is ${url}');
    Response<Map<String, dynamic>> data = await dio.get(url);
    if (null != data) {
      setState(() {
        articleData = ArticleBaseModel.fromJson(data.data);
      });
    }
  }
}
