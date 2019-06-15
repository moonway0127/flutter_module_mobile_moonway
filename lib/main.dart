import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  StaticResource.instance;
  runApp(MyApp());
}

class UserInfo {
  String nickName = "";
  String headImage = "";
  String address = "";
  int sex = 0;
  String school = "";
  int year = 0;
  int month = 0;
  int date = 0;
  String email = "";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: Welcome(),
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext content) => new LoginPage()
      },
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Welcome();
  }
}

class _Welcome extends State<Welcome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(Duration(seconds: 2), () {
      getGuideRead(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Image.asset(
          'imgs/welcome.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                Constant.APP_PACKAGE_NAME,
                style: TextStyle(fontSize: 30, color: Colors.blue),
                textDirection: TextDirection.ltr,
              ),
              new Container(height: 20,),
              new Text("by flutter&android(kotlin)",
                style: TextStyle(fontSize: 10, color: Colors.black),
                textDirection: TextDirection.ltr,)
            ],
          ),
        )
      ],
    );
  }
}

getGuideRead(context) async {
  var prefs = await SharedPreferences.getInstance();
  var readFlag = prefs.get("GUIDE_READ");
  var userid = prefs.get("UserId");
  var pwd = prefs.get("pwd");
  if (readFlag != null && readFlag == 1) {
    if(userid!=null&&pwd!=null&&userid!="0000"&&pwd!="0000"){

      var result = "";
      try {
         result = await MethodChannel(
            "com.moonway.gohi_android/method", StandardMethodCodec())
            .invokeMethod("login", {
          "userId": int.parse(userid),
          "userPwd": pwd
        });

        print('result结束——————————————————————————————————————————$result' +
            result.toString());

      } catch (e) {
        print(e);
      } finally {

      }
        print("--------"+result);
        if (result != null && result != "") {
          print('---------------------');
          print(result);

          Navigator.pushAndRemoveUntil(context,
              new MaterialPageRoute(
                builder: (BuildContext context) {
                  return GoHiApp(
                    userInfoJson: result,
                    uid: int.parse(userid),
                  );
                },
              ), (route) => route == null);
        } else {
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new LoginPage();
            },
          ), (route) => route == null);
        }

    }else{
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return new LoginPage();
        },
      ), (route) => route == null);
    }

  }  else {
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
      builder: (BuildContext context) {
        return new MyAppIntro();
      },
    ), (route) => route == null);
  }
}


class MyAppIntro extends StatelessWidget {
  final pages = [
    PageViewModel(
        pageColor: Colors.lightBlue[500],
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Image.asset(Images.IMG_INTRO_TALK_ICON),
        body: Text(
          '何时  何地  畅所欲言',
        ),
        title: Text(
          '交流',
        ),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          Images.IMG_INTRO_TALK,
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
        pageColor: Colors.lightBlue[400],
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Image.asset(Images.IMG_INTRO_SHARE_ICON),
        body: Text(
          '广交好友  乐享我爱',
        ),
        title: Text(
          '分享',
        ),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          Images.IMG_INTRO_SHARE,
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
        pageColor: Colors.lightBlue[300],
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Image.asset(Images.IMG_INTRO_PRIVATE_ICON),
        body: Text(
          '我们的秘密  我们知',
        ),
        title: Text(
          '私密',
        ),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          Images.IMG_INTRO_PRIVATE,
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Intro Widget', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        builder: (context) =>
            IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                setGuideRead();
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new LoginPage();
                  },
                ), (route) => route == null);
              },
              showSkipButton:
              false, //Whether you want to show the skip button or not.
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ), //IntroViewsFlutter
      ), //Builder
    ); //;

  }
}

setGuideRead() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt("GUIDE_READ", 1);
}


class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Stack(
          children: <Widget>[
            Image.asset(
              Images.IMG_REGIST_BACKGROUND,
              fit: BoxFit.cover,
            ),
            new Center(
              child: Text("aaaaaaaaaaaaaaaaa"),
            )
          ],
        ));
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(

      title: "login widget",
      home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: StaticResource.loginBackground,
            ),
            child: Stack(
              children: <Widget>[
                new BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.2)))),

//            LoginModule(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: LoginModule(),
                    ),
                  ],
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Center(
                    child: Text(Constant.APP_DESIGNED),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class LoginModule extends StatefulWidget {
  @override
  _LoginMoudleState createState() => new _LoginMoudleState();
}

class _LoginMoudleState extends State<LoginModule> {
  TextEditingController _uidController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool validatorFlag = false;
  bool whileFlag = true;
  bool serviceCheck = true;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);

    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidate: true, //开启自动校验
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                  child: new Container(
                      width: double.infinity,
                      height: 180,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey.shade200.withOpacity(0.2)))),
              Container(
                height: 160,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _uidController,
                        decoration: InputDecoration(
                            labelText: "账号",
                            hintText: "您的账号",
                            icon: Icon(Icons.person)),
                        // 校验用户名
                        validator: (v) {
                          return new RegExp(r"^\d{5,}$").hasMatch(v.trim())
                              ? null
                              : "用户名不能为空或非数字";
                        },
                        autovalidate: false,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        autocorrect: false,
                        controller: _pwdController,
                        decoration: InputDecoration(
                            labelText: "密码",
                            hintText: "您的登录密码",
                            icon: Icon(Icons.lock)),
                        obscureText: true,
                        //校验密码
                        validator: (v) {
                          return new RegExp(r"^(\d|[a-z]|[A-Z]){8,}$")
                              .hasMatch(v.trim())
                              ? null
                              : "密码不能少于8位且不存在符号";
                        },
                        autovalidate: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 登录按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    elevation: 0.0,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    color: Color.fromARGB(50, 255, 255, 255),
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    onPressed: !serviceCheck
                        ? null
                        : () {
                      if ((_formKey.currentState as FormState)
                          .validate()) {
                        pr.setMessage("正在验证信息");
                        pr.show();
                        login(context).then((json) {
//                          print("----" + json);
                          if (json != null && json != "") {
                            print('---------------------');
                            print(json);
                            setUserPwd(
                                _uidController.text, _pwdController.text);
                            Navigator.pushAndRemoveUntil(context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return GoHiApp(
                                      userInfoJson: json,
                                      uid: int.parse(_uidController.text),
                                    );
                                  },
                                ), (route) => route == null);
                          } else {
                            print('---------2-----------');
                            Toast.show("账号或密码错误", context);
                          }
                        });

                        print('-------3-----------');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          //服务条款
          Container(
              padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: serviceCheck,
                              onChanged: (value) {
                                setState(() {
                                  serviceCheck = value;
                                });
                              }),
                          GestureDetector(
                            child: Text(
                              "服务条款",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              showAboutDialog(
                                  context: context,
                                  applicationName: Constant.APP_NAME,
                                  applicationVersion: Constant.APP_VERSION,
                                  applicationIcon: Image.asset(
                                      Constant.APP_LOGO),
                                  applicationLegalese: Constant.APP_LEGALESE,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                          Images.IMG_LOGO_SCHOOL),
                                    ),
                                    Center(
                                        child: new RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "\n刘奇\n",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlue[500],
                                                      decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                      fontStyle: FontStyle
                                                          .italic)),
                                              TextSpan(
                                                  text:
                                                  "\n本作品用于毕业设计\n答辩结束后将托管至GitHub标记非私有，长期维护与共享。\n",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ]))),
                                    Center(
                                      child: Image.asset(
                                          Images.IMG_LOGO_GITHUB),
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          launchUrl(
                                              "https://github.com/moonway0127");
                                        },
                                        child: Text(
                                          "\nhttps://github.com/moonway0127",
                                          style: TextStyle(
                                              color: Colors.orangeAccent,
                                              decoration: TextDecoration
                                                  .underline),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "\nmoonway0127@gmail.com",
                                        style:
                                        TextStyle(color: Colors.orangeAccent),
                                      ),
                                    )
                                  ]);
                            },
                          )
                        ],
                      )),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                                return new RegistPage();
                              }));
                        },
                        child: new Text(
                          "注册账号",
                          style: TextStyle(
                              color: Colors.grey[500],
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.end,
                        )),
                  )
                ],
              ))
        ],
      ),
    );
  }

  setUserPwd(user, pwd) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("UserId", user);
    prefs.setString("pwd", pwd);
  }

  //flutter 请求Native --login
  Future<String> login(context) async {
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("login", {
        "userId": int.parse(_uidController.text),
        "userPwd": _pwdController.text
      });

      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {
      pr.hide();
    }
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class RegistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "regist page",
      debugShowCheckedModeBanner: true,
      theme: Theme.of(context),
      home: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: StaticResource.registBackground,
        ),
        child: new Scaffold(
          backgroundColor: Color.fromARGB(100, 255, 255, 255),
          appBar: AppBar(
            title: Text(
              "注册",
              style: TextStyle(color: Colors.grey[500]),
            ),
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            elevation: 0.0,
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[500],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Scrollbar(
                  child: SingleChildScrollView(
                    child: RegistModule(),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class RegistModule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegistModuleState();
  }
}

class _RegistModuleState extends State<RegistModule> {
  var _sexRadioGroupValue = "m";
  File _addHead;
  var _bornYear;
  var _bornMonth;
  var _bornDate;

  TextEditingController _firstPwdController = new TextEditingController();
  TextEditingController _secondPwdController = new TextEditingController();
  TextEditingController _nicknameController = new TextEditingController();
  TextEditingController _schoolController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  ProgressDialog pr;

  radioChange(String value) {
    setState(() {
      _sexRadioGroupValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);

    // TODO: implement build
    return Container(
        width: double.infinity,
//        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            Container(
//              decoration: BoxDecoration(color: Colors.green),
              child: Form(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 120,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        onTap: () {
                                          pickImage();
                                        },
                                        title: Center(
                                          child: Text("相册"),
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          getImage(ImageSource.camera);
                                        },
                                        title: Center(
                                          child: Text("相机"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent,
                              image: DecorationImage(
                                  image: _addHead == null
                                      ? AssetImage(Images.IMG_REGIST_ADD_HEAD)
                                      : FileImage(_addHead),
                                  fit: BoxFit.fill)),
                        )),
                    TextFormField(
                      controller: _firstPwdController,
                      decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "8-16位",
                          icon: Icon(Icons.lock)),
                    ),
                    TextFormField(
                      controller: _secondPwdController,
                      decoration: InputDecoration(
                          labelText: "确认密码",
                          hintText: "8-16位",
                          icon: Icon(Icons.lock)),
                    ),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                          labelText: "昵称",
                          hintText: "不能为空",
                          icon: Icon(Icons.face)),
                    ),
                    TextFormField(
                      controller: _schoolController,
                      decoration: InputDecoration(
                          labelText: "学校",
                          hintText: "可选",
                          icon: Icon(Icons.school)),
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          labelText: "住址",
                          hintText: "可选",
                          icon: Icon(Icons.location_on)),
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "电子邮箱",
                          hintText: "安全邮箱",
                          icon: Icon(Icons.email)),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          labelText: "手机号",
                          hintText: "只用作安全",
                          icon: Icon(Icons.phone)),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      locale: 'zh',
                                      minYear: 1970,
                                      maxYear: 2020,
                                      initialYear: 0,
                                      initialMonth: 0,
                                      initialDate: 0,
                                      cancel: Text('取消'),
                                      confirm: Text('完成'),
                                      dateFormat: 'yyyy-mm-dd',
                                      onChanged: (year, month, date) {},
                                      onConfirm: (year, month, date) {
                                        setState(() {
                                          _bornDate = date;
                                          _bornMonth = month;
                                          _bornYear = year;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(0, 0, 0, 0)),
                                    child: Center(
                                      child: Text(
                                        _bornYear == null
                                            ? "出生日期"
                                            : "$_bornYear-$_bornMonth-$_bornDate",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Radio(
                                              value: "m",
                                              groupValue: _sexRadioGroupValue,
                                              onChanged: (value) {
                                                radioChange(value);
                                              }),
                                          Text("男")
                                        ],
                                      )),
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Radio(
                                              value: "w",
                                              groupValue: _sexRadioGroupValue,
                                              onChanged: (value) {
                                                radioChange(value);
                                              }),
                                          Text("女")
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      width: double.infinity,
//                      decoration: BoxDecoration(color: Colors.red),
                      child: RaisedButton(
                        elevation: 0.0,
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          "注册",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        color: Color.fromARGB(50, 255, 255, 255),
                        textColor: Colors.grey[500],
                        onPressed: () {
                          if (checkContent()) {
                            pr.setMessage('Please wait...');
                            pr.show();
                            uploadInfo(_addHead.path);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  bool checkContent() {
    if (_firstPwdController.text.isEmpty ||
        _secondPwdController.text.isEmpty ||
        _nicknameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      showToast("请将内容填写完整");
      return false;
    }

    if (_firstPwdController.text.trim() != _secondPwdController.text) {
      showToast("两次密码输入不正确");
      return false;
    }
    if (!RegExp(r"^(\d|[a-z]|[A-Z]){8,16}$")
        .hasMatch(_secondPwdController.text.trim())) {
      showToast("密码为数字或字母的8-16位组合");
      return false;
    }

    if (!RegExp(
        r"^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$")
        .hasMatch(_emailController.text.trim())) {
      showToast("电子邮箱格式不正确");
      return false;
    }

    if (!RegExp(r"(?:^1[3456789]|^9[28])\d{9}$")
        .hasMatch(_phoneController.text.trim())) {
      showToast("手机号不正确");
      return false;
    }

    return true;
  }

  showToast(String str) {
    Toast.show(str, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  getImage(style) async {
    print('--------------------$style');
    var img = await ImagePicker.pickImage(source: style);
    print('111111111111111');
    setState(() {
//      _addHead = ;
    });
  }

  void pickImage() async {
    List<String> path = [];
    List<AssetPathEntity> photoPathList;
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      themeColor: Colors.lightBlue,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      maxSelected: 1,
      provider: I18nProvider.chinese,
      rowCount: 5,
      textColor: Colors.white,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      pickType: PickType.onlyImage,
      badgeDelegate: const DefaultBadgeDelegate(),
    );
    File file;
    if (imgList == null) {
      showToast("未选择图片");
    } else {
      path.clear();
      for (var e in imgList) {
        file = await e.file;
      }

      cropImage(file);
    }

//    cropImage(path[0]);
  }

  Future<Null> cropImage(File file) async {
    print(file.path);

    ImageCropper.cropImage(
        sourcePath: file.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        circleShape: true)
        .then((file) {
      showToast("因混合开发问题，裁剪工具有部分bug，待重写。");
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      showToast("因混合开发问题，裁剪工具有部分bug，待重写。");
    });
    setState(() {
      _addHead = file;
    });
  }

//flutter 请求Native --uploadHead
  uploadInfo(String path) async {
    print('head--------' + path);
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("uploadHead", {
        "path": path,
        "pwd": _secondPwdController.text,
        "nikename": _nicknameController.text,
        "school": _schoolController.text,
        "address": _addressController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "year": _bornYear,
        "month": _bornMonth,
        "date": _bornDate,
        "sex": _sexRadioGroupValue
      });

      print('result结束——————————————————————————————————————————' +
          result.toString());
    } catch (e) {
      print(e);
    }

    pr.hide();
    Navigator.of(context).pop();
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          },
        ), (route) => route == null);
  }
}
