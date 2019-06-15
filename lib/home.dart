import 'package:flutter/material.dart';
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
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' as json;

part 'home.g.dart';



const double _kFrontHeadingHeight = 32.0; // front layer beveled rectangle
const double _kFrontClosedHeight = 92.0; // front layer height when closed
const double _kBackAppBarHeight = 56.0; // back layer (options) appbar height
const Duration _kFrontLayerSwitchDuration = Duration(milliseconds: 300);

final Animatable<BorderRadius> _kFrontHeadingBevelRadius = BorderRadiusTween(
  begin: const BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
  ),
  end: const BorderRadius.only(
    topLeft: Radius.circular(_kFrontHeadingHeight),
    topRight: Radius.circular(_kFrontHeadingHeight),
  ),
);

@JsonSerializable(nullable: false)
class HeadRequestBackEntity {
  final int msgFlag;
  final List<UserNotificationEntity> userNotificationList;
  final List<UserEntity> userAllFriendList;
  final List<ChatContentEntity> chatContentListAll;

  HeadRequestBackEntity(
      {this.msgFlag,
      this.userNotificationList,
      this.chatContentListAll,
      this.userAllFriendList});

  factory HeadRequestBackEntity.fromJson(Map<String, dynamic> json) =>
      _$HeadRequestBackEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HeadRequestBackEntityToJson(this);
}

@JsonSerializable(nullable: false)
class UserNotificationEntity {
  final String ntid;
  final int flag_read;
  final int level;
  final int uid_from;
  final int uid_to;
  final String time;

  UserNotificationEntity(
      {this.ntid,
      this.flag_read,
      this.level,
      this.uid_from,
      this.uid_to,
      this.time});

  factory UserNotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationEntityToJson(this);
}

@JsonSerializable(nullable: false)
class UserEntity {
  final int uid;
  final String name;
  final int sex;
  final String avatar_img;
  final String school;
  final int born_year;
  final int born_month;
  final int born_day;
  final String phone;
  final String address;
  final String mail;
  final int flag_online;
  final int friend;

  UserEntity(
      {this.avatar_img,
      this.uid,
      this.born_day,
      this.born_month,
      this.born_year,
      this.sex,
      this.mail,
      this.address,
      this.name,
      this.phone,
      this.school,
      this.flag_online,
      this.friend});

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

@JsonSerializable(nullable: false)
class ChatContentEntity {
  final List<ChatContent> chatContentList;
  final int friendId;

  ChatContentEntity({this.chatContentList, this.friendId});

  factory ChatContentEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatContentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatContentEntityToJson(this);
}

@JsonSerializable(nullable: false)
class ChatContent {
  final int sender;
  final String time;
  final String content;

  ChatContent({this.sender, this.time, this.content});

  factory ChatContent.fromJson(Map<String, dynamic> json) =>
      _$ChatContentFromJson(json);

  Map<String, dynamic> toJson() => _$ChatContentToJson(this);
}

//{"address":"辽宁省xx市","avatar_img":"localhost","born_day":27,"born_month":1,"born_year":1996,"description":"失 去 ㄋ 、 菂 東 覀 ︶~ 永 遠 兜 囘 罘 來 ︶~ 〃","flag_online":1,"mail":"moonway0127@mail.com","name":"今晚打老虎","phone":"17151976665","pwd":"123456789","school":"五道口职业技术学院","sex":0,"uid":10000,"vip":0}

@JsonSerializable(nullable: false)
class UserInfo {
  String name;

  String avatar_img;

  String address;

  int sex;

  String school;

  int born_day;

  int born_month;

  int born_year = 0;
  String mail;
  String phone;
  int uid;

  UserInfo(
      {this.name = "testName",
      this.avatar_img = Constant.HEAD_DEFAULT,
      this.address = "辽宁省XX市XX区",
      this.sex = 0,
      this.school = "辽宁科技大学",
      this.born_day = 0,
      this.born_year = 0,
      this.born_month = 0,
      this.mail = "moonway0127@gmail.com",
      this.phone = "17151976665",
      this.uid = -1});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
//  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

//UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
//  return UserInfo(
//      name: json['name'] as String,
//      avatar_img: json['avatar_img'] as String,
//      address: json['address'] as String,
//      sex: json['sex'] as int,
//      school: json['school'] as String,
//      born_day: json['born_day'] as int,
//      born_year: json['born_year'] as int,
//      mail: json['mail'] as String,
//      born_month: json['born_month'] as int,
//      phone: json['phone'] as String,
//      uid: json['uid'] as int);
//}

UserInfo userInfo;

HeadRequestBackEntity headRequestBackEntity = HeadRequestBackEntity();
Map<int, List<ChatContent>> chatContentMap = new Map();
Map<int, UserEntity> friendMap = new Map();

void main() {
  StaticResource.instance;
  runApp(GoHiApp());
}

class _HeadImage extends StatelessWidget {
  const _HeadImage(this.url, {Key key}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          width: 34.0,
          height: 34.0,
          child: new CachedNetworkImage(
            imageUrl: userInfo.avatar_img,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
        onLongPress: (){
          showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                  title: new Text("退出登录"),
                  content: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: Center(
                                  child: Container(
                                      height: 80.0,
                                      child: new Text("退出登录将删除所有聊天记录，是否退出？")
                                  ),
                                )),

                          ],
                        ),
                      )),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("CANCEL"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        logOut();
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return LoginPage();
                              },
                            ), (route) => route == null);

                      },

                    )
                  ]));
        },
      ),

    );
  }

  Future<String> logOut() async {

    var prefs = await SharedPreferences.getInstance();
    prefs.setString("UserId", "0000");
    prefs.setString("pwd", "0000");
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("logout", {
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }


}



class GoHiApp extends StatefulWidget {
  const GoHiApp({
    this.uid,
    this.userInfoJson,
    Key key,
    this.enablePerformanceOverlay = true,
    this.enableRasterCacheImagesCheckerboard = true,
    this.enableOffscreenLayersCheckerboard = true,
    this.onSendFeedback,
    this.testMode = false,
  }) : super(key: key);

  final bool enablePerformanceOverlay;
  final bool enableRasterCacheImagesCheckerboard;
  final bool enableOffscreenLayersCheckerboard;
  final VoidCallback onSendFeedback;
  final bool testMode;
  final String userInfoJson;
  final int uid;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print('home.dart');
    userInfo = new UserInfo();
    if (userInfoJson != null) {
      userInfo = UserInfo.fromJson(json.jsonDecode(userInfoJson));
    }

    return _GoHiAppState();
  }
}

class _GoHiAppState extends State<GoHiApp> {
  @override
  void initState() {
    super.initState();

//    stream.receiveBroadcastStream().listen((event){
//      Future((){
//        print(event);
//      });
//    });
//    print('-------------------------flutter---------------');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Gohichat',
      color: Colors.grey,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}


FocusNode _focusNode = new FocusNode();

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  AnimationController _controller;

  static Widget _topHomeLayout(
      Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) children = children.toList()..add(currentChild);
    return Stack(
      children: children,
      alignment: Alignment.topCenter,
    );
  }

  static const AnimatedSwitcherLayoutBuilder _centerHomeLayout =
      AnimatedSwitcher.defaultLayoutBuilder;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      debugLabel: 'preview banner',
      vsync: this,
    )..forward();

//    Future((){
//      EventChannel("com.moonway.gohi_android/testToast")
//          .receiveBroadcastStream()
//          .listen((event){
////      Toast.show(event,context);
//        print('--------');
//      });
//    });

    var _basicMessageChannel = BasicMessageChannel(
        "com.moonway.gohi_chat.android/heart", StringCodec());

    _basicMessageChannel.setMessageHandler((heartJson) {
      //TODO json解析
      headRequestBackEntity =
          HeadRequestBackEntity.fromJson(json.jsonDecode(heartJson));

      print(headRequestBackEntity
          .chatContentListAll[1].chatContentList[1].content);
      headRequestBackEntity.chatContentListAll.forEach((chatContentList) {
        chatContentMap[chatContentList.friendId] =
            chatContentList.chatContentList;
      });
      headRequestBackEntity.userAllFriendList.forEach((userInfo) {
        friendMap[userInfo.uid] = userInfo;
      });
      freashUI();
    });
  }

  void freashUI() {
    setState(() {
      print('全局刷新');
    });
  }

  Future<String> selectUser(String id) async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("SelectUserById", {
        "userId": int.parse(id),
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    const Curve switchOutCurve =
        Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    const Curve switchInCurve = Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    final MediaQueryData media = MediaQuery.of(context);
    final bool centerHome =
        media.orientation == Orientation.portrait && media.size.height < 800.0;

    Widget home = Scaffold(
      floatingActionButton: Offstage(
        offstage: headRequestBackEntity.userNotificationList != null &&
                headRequestBackEntity.userNotificationList.length > 0
            ? false
            : true,
        child: FloatingActionButton(
          child: Icon(Icons.group_add),
          onPressed: () {
            selectUser(headRequestBackEntity.userNotificationList[0].uid_from
                    .toString())
                .then((jsonString) {
              if (null != jsonString && jsonString != "") {
                UserInfo selectUserInfo =
                    UserInfo.fromJson(json.jsonDecode(jsonString));
                showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                            title: new Text("添加好友"),
                            content: Scrollbar(
                                child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      child: Center(
                                    child: Container(
                                      width: 80.0,
                                      height: 80.0,
                                      child: new CachedNetworkImage(
                                        imageUrl: selectUserInfo.avatar_img,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    ),
                                  )),
                                  Container(
                                    height: 30,
                                  ),
                                  Text("昵称:${selectUserInfo.name}"),
                                  Text("学校:${selectUserInfo.school}"),
                                  Text("地址:${selectUserInfo.address}"),
                                  Text("电子邮箱:${selectUserInfo.mail}"),
                                ],
                              ),
                            )),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("拒绝"),
                                onPressed: () {
                                  acceptAndRefuse(0, userInfo.uid.toString(),
                                      selectUserInfo.uid.toString());
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text("同意"),
                                onPressed: () {
                                  acceptAndRefuse(1, userInfo.uid.toString(),
                                      selectUserInfo.uid.toString());
                                  Navigator.of(context).pop();
                                },
                              )
                            ]));
              } else {}
            });
          },
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: Backdrop(
            backTitle: new Text("设置"),
            backLayer: new Container(
//            decoration: BoxDecoration(color: Colors.red),
              child: BackLayout(freashUI: freashUI),
            ),
            frontAction: AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchOutCurve,
              child: _HeadImage(userInfo.avatar_img),
            ),
            frontTitle: AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              child: Text(userInfo.name),
            ),
            frontHeading: Container(
              height: 50,
            ),
            frontLayer: AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              layoutBuilder: centerHome ? _centerHomeLayout : _topHomeLayout,
              child:
              FriendList(),

            )),
      ),
    );

    home = AnnotatedRegion<SystemUiOverlayStyle>(
        child: home, value: SystemUiOverlayStyle.light);

    return home;
  }

  Future<String> acceptAndRefuse(
      int flag, String uid, String uid_friend) async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("friendAcceptAndRefuse", {
        "uid_friend": int.parse(uid_friend),
        "uid": userInfo.uid,
        "accpetOrRefuseFlag": flag,
        "notificationId": headRequestBackEntity.userNotificationList[0].ntid,
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());

      return result;
    } catch (e) {
      print(e);
      result = "添加异常";
    } finally {}
  }
}

class Backdrop extends StatefulWidget {
  const Backdrop({
    this.frontAction,
    this.frontTitle,
    this.frontHeading,
    this.frontLayer,
    this.backTitle,
    this.backLayer,
  });

  final Widget frontAction;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget frontHeading;
  final Widget backTitle;
  final Widget backLayer;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BackdropState();
  }
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<double> _frontOpacity;

  static final Animatable<double> _frontOpacityTween =
      Tween<double>(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    _frontOpacity = _controller.drive(_frontOpacityTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    // Warning: this can be safely called from the event handlers but it may
    // not be called at build time.
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(
        0.0, renderBox.size.height - _kBackAppBarHeight - _kFrontClosedHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void _toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect =
        _controller.drive(RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, constraints.biggest.height - _kFrontClosedHeight, 0.0, 0.0),
      end: const RelativeRect.fromLTRB(0.0, _kBackAppBarHeight, 0.0, 0.0),
    ));

    final List<Widget> layers = <Widget>[
      // Back layer
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _BackAppBar(
            leading: widget.frontAction,
            title: _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child0: Semantics(namesRoute: true, child: widget.frontTitle),
              child1: Semantics(namesRoute: true, child: widget.backTitle),
            ),
            trailing: IconButton(
              onPressed: _toggleFrontLayer,
              tooltip: 'Toggle options page',
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _controller,
              ),
            ),
          ),
          Expanded(
              child: Visibility(
            child: widget.backLayer,
            visible: _controller.status != AnimationStatus.completed,
            maintainState: true,
          )),
        ],
      ),
      // Front layer
      PositionedTransition(
        rect: frontRelativeRect,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return PhysicalShape(
              elevation: 12.0,
              color: Theme.of(context).canvasColor,
              clipper: ShapeBorderClipper(
                shape: BeveledRectangleBorder(
                  borderRadius:
                      _kFrontHeadingBevelRadius.transform(_controller.value),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          child: _TappableWhileStatusIs(
            AnimationStatus.completed,
            controller: _controller,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
    ];

    // The front "heading" is a (typically transparent) widget that's stacked on
    // top of, and at the top of, the front layer. It adds support for dragging
    // the front layer up and down and for opening and closing the front layer
    // with a tap. It may obscure part of the front layer's topmost child.
    if (widget.frontHeading != null) {
      layers.add(
        PositionedTransition(
          rect: frontRelativeRect,
          child: ExcludeSemantics(
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFrontLayer,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: widget.frontHeading,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildStack);
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  const _BackAppBar({
    Key key,
    this.leading = const SizedBox(width: 56.0),
    @required this.title,
    this.trailing,
  })  : assert(leading != null),
        assert(title != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Container(
        alignment: Alignment.center,
        width: 56.0,
        child: leading,
      ),
      Expanded(
        child: title,
      ),
    ];

    if (trailing != null) {
      children.add(
        Container(
          alignment: Alignment.center,
          width: 56.0,
          child: trailing,
        ),
      );
    }

    final ThemeData theme = Theme.of(context);

    return IconTheme.merge(
      data: theme.primaryIconTheme,
      child: DefaultTextStyle(
        style: theme.primaryTextTheme.title,
        child: SizedBox(
          height: _kBackAppBarHeight,
          child: Row(children: children),
        ),
      ),
    );
  }
}

class _TappableWhileStatusIs extends StatefulWidget {
  const _TappableWhileStatusIs(
    this.status, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  @override
  _TappableWhileStatusIsState createState() => _TappableWhileStatusIsState();
}

class _TappableWhileStatusIsState extends State<_TappableWhileStatusIs> {
  bool _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
    _active = widget.controller.status == widget.status;
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.status;
    if (_active != value) {
      setState(() {
        _active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );
  }
}

class BackLayout extends StatefulWidget {
  BackLayout({this.freashUI});

  var freashUI;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BackLayout(freashUI: freashUI);
  }
}

class _BackLayout extends State<BackLayout> {
  _BackLayout({this.freashUI});

  var freashUI;
  bool _isExpansion = true;

  TextEditingController addUserController = new TextEditingController();
  FocusNode addUserFocusNode = FocusNode();
  bool addUserEnable = false;
  TextEditingController nickNameController =
      new TextEditingController(text: userInfo.name);
  bool nickNameEnable = false;
  FocusNode nickNameFocusNode = FocusNode();
  Color personColor = Colors.white;
  Color addColor = Colors.white;
  TextEditingController addressController =
      TextEditingController(text: userInfo.address);
  FocusNode addressFocusNode = FocusNode();
  bool addressEnable = false;

  TextEditingController schoolController =
      TextEditingController(text: userInfo.school);
  FocusNode schoolFocusNode = FocusNode();
  bool schoolEnable = false;

  TextEditingController emailController =
      TextEditingController(text: userInfo.mail);
  FocusNode emailFocusNode = FocusNode();
  bool emailEnable = false;

  TextEditingController phoneController =
      TextEditingController(text: userInfo.phone);
  FocusNode phoneFocusNode = FocusNode();
  bool phoneEnable = false;

  bool sexEnable = false;
  int _tempRadioValue = userInfo.sex;
  int _tempYear = userInfo.born_year;
  int _tempMonth = userInfo.born_month;
  int _tempDay = userInfo.born_day;
  String _tempImagePath = userInfo.avatar_img;
  ProgressDialog pr;

  setFocusNode({
    bool nickNameFocus = false,
    bool addressFocus = false,
    bool emailFocus = false,
    bool schoolFocus = false,
    bool phoneFocus = false,
    bool sexFocus = false,
  }) {
    nickNameEnable = nickNameFocus;
    addressEnable = addressFocus;
    emailEnable = emailFocus;
    schoolEnable = schoolFocus;
    phoneEnable = phoneFocus;
    sexEnable = sexFocus;
    nickNameController.text = userInfo.name;
    phoneController.text = userInfo.phone;
    schoolController.text = userInfo.school;
    emailController.text = userInfo.mail;
    addressController.text = userInfo.address;
    _tempRadioValue = userInfo.sex;
    _tempYear = userInfo.born_year;
    _tempMonth = userInfo.born_month;
    _tempDay = userInfo.born_day;
  }

  Widget userInfoList() {
    nickNameFocusNode.addListener(() {
      setFocusNode(nickNameFocus: nickNameFocusNode.hasFocus);
    });

    addressFocusNode.addListener(() {
      setFocusNode(addressFocus: addressFocusNode.hasFocus);
    });

    emailFocusNode.addListener(() {
      setFocusNode(emailFocus: emailFocusNode.hasFocus);
    });

    schoolFocusNode.addListener(() {
      setFocusNode(schoolFocus: schoolFocusNode.hasFocus);
    });

    phoneFocusNode.addListener(() {
      setFocusNode(phoneFocus: phoneFocusNode.hasFocus);
    });

    radioChange(int value) {
      setState(() {
        _tempRadioValue = value;
      });
    }

    addUserFocusNode.addListener(() {
      print('listener');
      if (addUserFocusNode.hasFocus) {
        addUserEnable = true;
      }
    });

    var userInfoList = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ExpansionTile(
          onExpansionChanged: ((open) {
            setState(() {
              open
                  ? personColor = Colors.lightGreenAccent
                  : personColor = Colors.white;
              nickNameEnable = false;
              addressEnable = false;
              emailEnable = false;
              schoolEnable = false;
              phoneEnable = false;
              sexEnable = false;
              _tempDay = userInfo.born_day;
              _tempMonth = userInfo.born_month;
              _tempYear = userInfo.born_year;
              _tempRadioValue = userInfo.sex;
            });
          }),
          leading: Icon(Icons.info),
          title: Text(
            "个人信息",
            style: TextStyle(color: personColor),
          ),
          children: <Widget>[
            ListTile(
              onTap: () {
                setFocusNode();

                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 120,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                print("ontap");

                                pickImage().then((file) {
                                  var temp = new ProgressDialog(context);

                                  cropImage(file);

                                  freashUI();
                                });

//                                  pickImage().then((){
//                                    pr.show();
//                                    if(_tempImagePath != userInfo.avatar_img){
//                                      print('tempimage------------------$_tempImagePath');
//                                      updateImage(_tempImagePath).then((result){
//                                        if(result!=null&&result!=""){
//                                          String _oldPath = userInfo.avatar_img;
//                                          userInfo.avatar_img = result;
//                                          update().then((result){
//                                            if(result!=null&&result!=""){
//                                              showToast("修改成功");
//                                            }else{
//                                              userInfo.avatar_img = _oldPath;
//                                            }
//                                            _tempImagePath = userInfo.avatar_img;
//                                            freashUI();
//                                          });
//                                        }else{
//                                          pr.hide();
//                                          showToast("上传失败");
//                                        }
//                                      });
//                                    }
//
//                                  });
                              },
                              title: Center(
                                child: Text("相册"),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              title: Center(
                                child: Text("相机"),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              title: Container(
                padding: EdgeInsets.only(bottom: 5),
                height: 60.0,
                child: new CachedNetworkImage(
                  imageUrl: userInfo.avatar_img,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.lightBlue[200]),
                    bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.face,
                        color: nickNameEnable
                            ? Colors.lightGreenAccent
                            : Colors.grey,
                      ),
                    ),
                    controller: nickNameController,
                    enabled: nickNameEnable,
                    focusNode: nickNameFocusNode,
                  )),
                  GestureDetector(
                    child: nickNameEnable
                        ? Icon(
                            Icons.check,
                            color: Colors.lightGreenAccent,
                          )
                        : Icon(Icons.create),
                    onTap: () {
                      nickNameEnable = !nickNameEnable;
                      if (nickNameEnable) {
                        setState(() {
                          FocusScope.of(context)
                              .requestFocus(nickNameFocusNode);
                        });
                      } else {
                        String _oldNickName = userInfo.name;
                        userInfo.name = nickNameController.text;
                        pr.show();
                        update().then((result) {
                          print(result);
                          if (result != null && result != "") {
                            showToast("修改成功");
                          } else {
                            userInfo.name = _oldNickName;
                          }
                          freashUI();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.location_on,
                        color: addressEnable
                            ? Colors.lightGreenAccent
                            : Colors.grey,
                      ),
                    ),
                    controller: addressController,
                    enabled: addressEnable,
                    focusNode: addressFocusNode,
                  )),
                  GestureDetector(
                    child: addressEnable
                        ? Icon(
                            Icons.check,
                            color: Colors.lightGreenAccent,
                          )
                        : Icon(Icons.create),
                    onTap: () {
                      addressEnable = !addressEnable;
                      if (addressEnable) {
                        setState(() {
                          FocusScope.of(context).requestFocus(addressFocusNode);
                        });
                      } else {
                        String _oldAddress = userInfo.address;
                        userInfo.address = addressController.text;
                        pr.show();
                        update().then((result) {
                          print(result);
                          if (result != null && result != "") {
                            showToast("修改成功");
                          } else {
                            userInfo.address = _oldAddress;
                          }
                          freashUI();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.email,
                        color:
                            emailEnable ? Colors.lightGreenAccent : Colors.grey,
                      ),
                    ),
                    controller: emailController,
                    enabled: emailEnable,
                    focusNode: emailFocusNode,
                  )),
                  GestureDetector(
                    child: emailEnable
                        ? Icon(
                            Icons.check,
                            color: Colors.lightGreenAccent,
                          )
                        : Icon(Icons.create),
                    onTap: () {
                      emailEnable = !emailEnable;
                      if (emailEnable) {
                        setState(() {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        });
                      } else {
                        String _oldEmail = userInfo.mail;
                        userInfo.mail = emailController.text;
                        pr.show();
                        update().then((result) {
                          print(result);
                          if (result != null && result != "") {
                            showToast("修改成功");
                          } else {
                            userInfo.mail = _oldEmail;
                          }
                          freashUI();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.school,
                        color: schoolEnable
                            ? Colors.lightGreenAccent
                            : Colors.grey,
                      ),
                    ),
                    controller: schoolController,
                    enabled: schoolEnable,
                    focusNode: schoolFocusNode,
                  )),
                  GestureDetector(
                    child: schoolEnable
                        ? Icon(
                            Icons.check,
                            color: Colors.lightGreenAccent,
                          )
                        : Icon(Icons.create),
                    onTap: () {
                      schoolEnable = !schoolEnable;
                      if (schoolEnable) {
                        setState(() {
                          FocusScope.of(context).requestFocus(schoolFocusNode);
                        });
                      } else {
                        String _oldSchool = userInfo.school;
                        userInfo.school = schoolController.text;
                        pr.show();
                        update().then((result) {
                          print(result);
                          if (result != null && result != "") {
                            showToast("修改成功");
                          } else {
                            userInfo.school = _oldSchool;
                          }
                          freashUI();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.phone,
                        color:
                            phoneEnable ? Colors.lightGreenAccent : Colors.grey,
                      ),
                    ),
                    controller: phoneController,
                    enabled: phoneEnable,
                    focusNode: phoneFocusNode,
                  )),
                  GestureDetector(
                    child: phoneEnable
                        ? Icon(
                            Icons.check,
                            color: Colors.lightGreenAccent,
                          )
                        : Icon(Icons.create),
                    onTap: () {
                      phoneEnable = !phoneEnable;
                      if (phoneEnable) {
                        setState(() {
                          FocusScope.of(context).requestFocus(phoneFocusNode);
                        });
                      } else {
                        String _oldPhone = userInfo.phone;
                        userInfo.phone = phoneController.text;
                        pr.show();
                        update().then((result) {
                          print(result);
                          if (result != null && result != "") {
                            showToast("修改成功");
                          } else {
                            userInfo.phone = _oldPhone;
                          }
                          freashUI();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white)),
                ),
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              setFocusNode();
                            });

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
//                                int _oldYear = _tempYear;
//                                int _oldMonth = _tempMonth;
//                                int _oldDay = _tempDay;
                                userInfo.born_year = year;
                                userInfo.born_month = month;
                                userInfo.born_day = date;
                                pr.show();
                                update().then((result) {
                                  print('------------result:$result');
                                  if (result != null && result != "") {
                                    _tempYear = userInfo.born_year;
                                    _tempMonth = userInfo.born_month;
                                    _tempDay = userInfo.born_day;

                                    setState(() {
                                      showToast("修改成功");
                                    });
                                  } else {
                                    userInfo.born_year = _tempYear;
                                    userInfo.born_month = _tempMonth;
                                    userInfo.born_day = _tempDay;
                                  }
                                  freashUI();
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
                                userInfo.born_year == null
                                    ? "出生日期"
                                    : "$_tempYear-$_tempMonth-$_tempDay",
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                  activeColor: Colors.greenAccent,
                                  value: 0,
                                  groupValue: _tempRadioValue,
                                  onChanged: !sexEnable
                                      ? null
                                      : (value) {
                                          radioChange(value);
                                        }),
                              Text("男")
                            ],
                          )),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                  activeColor: Colors.greenAccent,
                                  value: 1,
                                  groupValue: _tempRadioValue,
                                  onChanged: !sexEnable
                                      ? null
                                      : (value) {
                                          radioChange(value);
                                        }),
                              Text("女")
                            ],
                          )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                            child: GestureDetector(
                              child: sexEnable
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.lightGreenAccent,
                                    )
                                  : Icon(Icons.create),
                              onTap: () {
                                sexEnable = !sexEnable;
                                if (sexEnable) {
                                  setState(() {
                                    setFocusNode(sexFocus: sexEnable);
                                  });
                                } else {
                                  int _oldSex = userInfo.sex;
                                  userInfo.sex = _tempRadioValue;
                                  pr.show();
                                  update().then((result) {
                                    print(result);
                                    if (result != null && result != "") {
                                      showToast("修改成功");
                                    } else {
                                      userInfo.sex = _oldSex;
                                    }
                                    freashUI();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (open) {
            setState(() {
              open
                  ? addColor = Colors.lightGreenAccent
                  : addColor = Colors.white;
              if (!open) {
                addUserEnable = false;
              }
//              if(open){
//                FocusScope.of(context).requestFocus(addUserFocusNode);
//              }else{
//                addUserEnable = false;
//              }
            });
          },
          leading: Icon(Icons.add_circle),
          title: Text(
            "添加好友",
            style: TextStyle(color: addColor),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.lightBlue[200]),
                    bottom: BorderSide(color: Colors.lightBlue[200])),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.supervised_user_circle,
                        color: addUserEnable
                            ? Colors.lightGreenAccent
                            : Colors.orangeAccent,
                      ),
                    ),
//                        enabled: true,
                    controller: addUserController,
//                        focusNode: addUserFocusNode,
                  )),
                  GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.orangeAccent,
                    ),
                    onTap: () {
                      pr.show();
                      selectUser(addUserController.text).then((jsonString) {
                        if (null != jsonString && jsonString != "") {
                          UserInfo selectUserInfo =
                              UserInfo.fromJson(json.jsonDecode(jsonString));
                          showDialog(
                              context: context,
                              builder: (context) => new AlertDialog(
                                      title: new Text("添加好友"),
                                      content: Scrollbar(
                                          child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                child: Center(
                                              child: Container(
                                                width: 80.0,
                                                height: 80.0,
                                                child: new CachedNetworkImage(
                                                  imageUrl:
                                                      selectUserInfo.avatar_img,
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            )),
                                            Container(
                                              height: 30,
                                            ),
                                            Text("昵称:${selectUserInfo.name}"),
                                            Text("学校:${selectUserInfo.school}"),
                                            Text(
                                                "地址:${selectUserInfo.address}"),
                                            Text("电子邮箱:${selectUserInfo.mail}"),
                                          ],
                                        ),
                                      )),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("CANCEL"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        new FlatButton(
                                          child: new Text("OK"),
                                          onPressed: () {
                                            addUser(
                                                selectUserInfo.uid.toString());
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ]));
                        } else {
                          showToast("没有查找到用户");
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );

    return userInfoList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(context);
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return userInfoList();
  }

  Future<String> addUser(String uid_friend) async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("friendAdd", {
        "uid_to": int.parse(uid_friend),
        "uid_from": userInfo.uid,
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());

      return result;
    } catch (e) {
      print(e);
      result = "添加异常";
    } finally {}
  }

  Future<String> selectUser(String id) async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("SelectUserById", {
        "userId": int.parse(id),
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

  Future<String> update() async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("userInfoUpdate", {
        "uid": userInfo.uid,
        "path": userInfo.avatar_img,
        "nikename": userInfo.name,
        "school": userInfo.school,
        "address": userInfo.address,
        "email": userInfo.mail,
        "phone": userInfo.phone,
        "year": userInfo.born_year,
        "month": userInfo.born_month,
        "date": userInfo.born_day,
        "sex": userInfo.sex
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {
      if (pr.isShowing()) {
        pr.hide();
      }
    }
  }

  showToast(String str) {
    Toast.show(str, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  getImage(style) async {
    print('--------------------$style');
    String imagePath = "";
    var img = await ImagePicker.pickImage(source: style);
  }

  Future<File> pickImage() async {
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

      return file;
    }

//    cropImage(path[0]);
  }

  Future<Null> cropImage(File file) async {
    print("file:" + file.path);
//
//    try{
//      var a = await ImageCropper.cropImage(
//          sourcePath: file.path,
//          ratioX: 1.0,
//          ratioY: 1.0,
//          maxWidth: 512,
//          maxHeight: 512,
//          circleShape: true);
//    }catch(e){
//      print(e);
//    }

//    Future.delayed(Duration(seconds: 2)).then((value) {
//      showToast("因混合开发问题，裁剪工具有部分bug，待重写。");
//    });
    _tempImagePath = file.path;
    print("tempImagePath" + _tempImagePath);

    String path = await updateImage(file.path);

    if (path != null && path != "") {
      String _oldImage = userInfo.avatar_img;
      userInfo.avatar_img = path;

      update().then((result) {
        if (result != null && result != "") {
          showToast("修改成功");
        } else {
          userInfo.avatar_img = _oldImage;
        }
        if (pr.isShowing()) {
          pr.hide();
        }
        _tempImagePath = userInfo.avatar_img;
        freashUI();
      });
    }
  }

  Future<String> updateImage(String path) async {
    var result = "";
    try {
      var result = await MethodChannel(
              "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("userHeadImageChange", {
        "path": path,
        "uid": userInfo.uid,
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }
}

class FriendList extends StatefulWidget {
  @override
  State<FriendList> createState() {
    // TODO: implement createState
    return _friendListState();
  }
}

bool isChat = false;
int currentChatUid = -1;
String editContent = "";

class _friendListState extends State<FriendList> {
  TextEditingController sendController;

  initState(){
      sendController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _cardList = new List();
    if (headRequestBackEntity != null &&
        headRequestBackEntity.userAllFriendList != null) {
      headRequestBackEntity.userAllFriendList.forEach((userInfo) {
        _cardList.add(_card(userInfo));
      });
    }


    List<Widget> _chatCardList = new List();
    if(chatContentMap!=null&&chatContentMap[currentChatUid]!=null&&chatContentMap[currentChatUid].length>0){
      chatContentMap[currentChatUid].forEach((chatContent){
        _chatCardList.add(_chatCard(chatContent));

      });
    }



    // TODO: implement build
    return !isChat
        ? Container(
            child: Column(
              children: <Widget>[
                Container(
//            color: Colors.red,

                    decoration: BoxDecoration(color: Colors.lightBlue[500]),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "好友列表",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                      ],
                    )),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: _cardList != null && _cardList.length > 0
                          ? _cardList
                          : [
                              Container(
                                height: 60,
                                child: Center(child: Text("暂无好友，请添加")),
                              )
                            ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(

            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(color: Colors.lightBlue[500]),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "聊天",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )),
//            color: Colors.red,
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(color: Colors.lightBlue[400]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          setState(() {
                            isChat = false;
                            currentChatUid = -1;
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: new CachedNetworkImage(
                          width: 40,
                          height: 40,
                          imageUrl: friendMap[currentChatUid].avatar_img,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                      new Text(
                        friendMap[currentChatUid].name,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top:20),
                    child:ListView(
                    children:
                      _chatCardList,

                  ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  color: Colors.white54,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: new TextFormField(

                          controller: sendController,
                          focusNode: _focusNode,
                        ),
                      ),
                      IconButton(icon: Icon(Icons.send),color: Colors.blue,onPressed: (){
                        if(sendController.text!=""){
                          setState(() {
                            if(chatContentMap[currentChatUid]==null||chatContentMap[currentChatUid].length==0){
                              List<ChatContent> tempList = new List();
                              tempList.add(ChatContent(sender: userInfo.uid,content: sendController.text));
                            }else{
                              chatContentMap[currentChatUid].add(ChatContent(sender: userInfo.uid,content: sendController.text));

                            }
                            sendMessage(currentChatUid,sendController.text);
                            sendController.text = "";
                          });
                        }else{
                          Toast.show("请输入内容", context);
                        }

                      },)
                    ],
                  ),
                )

              ],
            ),
          );
  }


  Future<String> sendMessage(int friendId,String content) async {
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("sendMessage", {
        "uid_friend": friendId,
        "uid": userInfo.uid,
        "content":content,
      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }



  Widget _chatCard(ChatContent chatContent) {
    var _cardId = userInfo.uid;
    return GestureDetector(
      child: Container(

        height: 60,
//      ListTile
        child: chatContent.sender==userInfo.uid?Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: new CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: userInfo.avatar_img,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                chatContent.content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ):Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                chatContent.content,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 0, 20),
              child: new CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: friendMap[chatContent.sender].avatar_img,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),

          ],
        ),
      ),
//      onTap: () {
//        setState(() {
//          isChat = true;
//          currentChatUid = _cardId;
//        });
//      },
    );
  }



  Widget _card(UserEntity userInfo) {
    var itemClick =false;
    var _cardId = userInfo.uid;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: itemClick?Colors.red:Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[500]))),
        width: 160.0,
        height: 60,
//      ListTile
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: new CachedNetworkImage(

                width: 40,
                height: 40,
                imageUrl: userInfo.avatar_img,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                userInfo.name,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      onTapUp: (value){
        setState(() {
          print("抬手");
          itemClick = false;
        });
      },
      onTapDown: (value){
        setState(() {
          print("点击");
          itemClick = true;
        });
      },
      onTap: () {
        setState(() {
          isChat = true;
          currentChatUid = _cardId;
        });
      },
      onDoubleTap: (){
        clearMessage(userInfo.uid);
        Toast.show("聊天记录清除成功！", context);
      },
      onLongPress: (){
        showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                title: new Text("删除好友"),
                content: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Center(
                                child: Container(
                                  height: 80.0,
                                  child: new Text("是否删除好友？")
                                ),
                              )),

                        ],
                      ),
                    )),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("CANCEL"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                    deleteFriend(userInfo.uid);
                    Navigator.of(context).pop();
                    },
                  )
                ]));
      },
    );
  }


  Future<String> deleteFriend(friendId) async {
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("deleteFriend", {
        "uid_friend": friendId,
        "uid": userInfo.uid,

      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }


  Future<String> clearMessage(friendId) async {
    var result = "";
    try {
      var result = await MethodChannel(
          "com.moonway.gohi_android/method", StandardMethodCodec())
          .invokeMethod("clearMessage", {
        "uid_friend": friendId,
        "uid": userInfo.uid,

      });
      print('result结束——————————————————————————————————————————$result' +
          result.toString());
      return result;
    } catch (e) {
      print(e);
      result = "";
    } finally {}
  }
}
