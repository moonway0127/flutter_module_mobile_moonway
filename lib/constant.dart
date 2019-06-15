import 'package:flutter/material.dart';


class Constant {
  static const String APP_PACKAGE_NAME = "com.moonway.gohi";
  static const String APP_NAME = "GOHI";
  static const String APP_NAME_FULL = "GOHI_CHAT";
  static const String APP_LOGO = "imgs/logo.png";
  static const String APP_DESIGNED = "Designed by moonway";
  static const String APP_VERSION = "1.0.0(BETA)";
  static const String APP_LEGALESE = "©️ 2019 \n$APP_DESIGNED";
  static const String HEAD_DEFAULT = "https://gohi-chat-1254406116.cos.ap-beijing.myqcloud.com/user_head/default24.png";
}

class Images {
  static const String IMG_LOGIN_BACKGROUND = "imgs/login_background.png";
  static const String IMG_INTRO_PRIVATE = "imgs/intro/intro_private.png";
  static const String IMG_INTRO_PRIVATE_ICON =
      "imgs/intro/intro_private_icon.png";
  static const String IMG_INTRO_SHARE = "imgs/intro/intro_share.png";
  static const String IMG_INTRO_SHARE_ICON = "imgs/intro/intro_share_icon.png";
  static const String IMG_INTRO_TALK = "imgs/intro/intro_talk.png";
  static const String IMG_INTRO_TALK_ICON = "imgs/intro/intro_talk_icon.png";
  static const String IMG_LOGO_SCHOOL = "imgs/logo_school.png";
  static const String IMG_LOGO_GITHUB = "imgs/logo_github.png";
  static const String IMG_REGIST_BACKGROUND = "imgs/regist_background.jpeg";
  static const String IMG_REGIST_ADD_HEAD = "imgs/regist_add_head.png";
}

class StaticResource {
//    _registBackground = AssetImage(Images.IMG_REGIST_BACKGROUND);

  // 工厂模式
  factory StaticResource() => _getInstance();

  static StaticResource get instance => _getInstance();
  static StaticResource _instance;
  DecorationImage _loginBackground;

  static DecorationImage get loginBackground => _getInstance()._loginBackground;
  DecorationImage _registBackground;

  static DecorationImage get registBackground =>
      _getInstance()._registBackground;




  StaticResource._internal() {
    this._loginBackground = DecorationImage(
        image: AssetImage(Images.IMG_LOGIN_BACKGROUND),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Color.fromARGB(0, 255, 255, 255), BlendMode.color));

    this._registBackground = DecorationImage(
        image: AssetImage(Images.IMG_LOGIN_BACKGROUND), fit: BoxFit.cover);

  }

  static StaticResource _getInstance() {
    if (_instance == null) {
      _instance = new StaticResource._internal();
    }

    return _instance;
  }
}

class LoadingDialog {}
