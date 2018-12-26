import 'package:flutter/material.dart';
import 'package:flutter_wan/constants/constants.dart';
import 'baseState.dart';
import 'event/RxBus.dart';

class mainDrawerWidget extends StatefulWidget {
  @override
  _mainDrawerWidgetState createState() => _mainDrawerWidgetState();
}

class _mainDrawerWidgetState extends BaseState<mainDrawerWidget> {
  List<ListItemData> datas;

  @override
  void initState() {
    super.initState();
    datas = [
      ListItemData(
          "收集",
          Icon(
            Icons.favorite,
            color: Colors.red,
          )),
      ListItemData(
          "夜间模式",
          Icon(
            Icons.brightness_2,
          ),
          onTap: (){
            mainTheme = moonColor;
            event.add(changeTheme);
          }),
      ListItemData(
          "设置",
          Icon(
            Icons.settings,
            color: Colors.red,
          )),
      ListItemData(
          "关于我们",
          Icon(
            Icons.info_outline,
            color: Colors.red,
          )),
    ];

    event.listen((e){
      if(e == changeTheme){
        setState(() {

        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: mainTheme,
        width: MediaQuery.of(context).size.width * 0.7,
        child: SafeArea(
          child: Center(
            child: (Column(
              children: <Widget>[
                Image.asset(
                  'assets/img/ic_launcher.png',
                  scale: 2,
                ),
                Text(
                  '登录',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = datas[index];
                          return ListTile(
                            title: Text(data.title),
                            leading: data.icon,
                            onTap: data.onTap,
                          );
                        }))
              ],
            )),
          ),
        ));
  }
}

class ListItemData {
  String title;
  Icon icon;
  GestureTapCallback onTap;

  ListItemData(this.title, this.icon, {this.onTap});
}
