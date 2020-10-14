import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "hhhh"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  Offset currentPt;
  double dx = 0;
  double dy = 0;
  AnimationController controllerThrowAway;
  AnimationController controllerShowGradually;
  AnimationController controllerScaleUp;
  AnimationController controllerScaleDown;
  Animation<double> animationX;
  Animation<double> animationShow;
  Animation<double> animationScaleUp;
  Animation<double> animationScaleDown;
  Tween<Offset> tweenX;
  Tween<double> tweenHide;
  Tween<double> tweenShow;
  Tween<double> tweenScaleUp;
  Tween<double> tweenScaleDown;
  Tween<double> tweenCorrectBarOpacity;
  Tween<double> tweenWrongBarOpacity;
  double opacity = 1;
  double ratio = 1;
  double scale = 1;

  double correctOpacity = 0;
  double wrongOpacity = 0;

  static const double cardWidth = 300;
  static const double cardHeight = 200;
  static const double halfCardWidth = cardWidth / 2;
  static const double halfCardHeight = cardHeight / 2;
  static const double topBarHeight = 44;

  static const double dragThreshold = 100;
  static const double dragSpeedThreshold = 1000;

  @override
  void initState() {
    super.initState();
    controllerThrowAway = AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: Duration(), vsync: this);
    controllerShowGradually = AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: Duration(), vsync: this);
    animationX = CurvedAnimation(parent: controllerThrowAway, curve: Curves.easeIn);
    animationShow = CurvedAnimation(parent: controllerShowGradually, curve: Curves.easeIn);
    tweenHide = Tween<double>(begin: 1, end: 0);
    tweenShow = Tween<double>(begin: 0, end: 1);
    tweenCorrectBarOpacity = Tween<double>(begin: 1, end: 0);
    tweenWrongBarOpacity = Tween<double>(begin: 1, end: 0);

    controllerScaleUp = AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: Duration(), vsync: this);
    controllerScaleDown = AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: Duration(), vsync: this);
    animationScaleUp = CurvedAnimation(parent: controllerScaleUp, curve: Curves.easeIn);
    animationScaleDown = CurvedAnimation(parent: controllerScaleDown, curve: Curves.easeIn);
    tweenScaleUp = Tween<double>(begin: 1, end: 1.5);
    tweenScaleDown = Tween<double>(begin: 1.5, end: 1);


    tweenX = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0)
    );

    tweenCorrectBarOpacity.animate(controllerThrowAway)..addListener(() {
      setState(() {
        correctOpacity = tweenCorrectBarOpacity.evaluate(animationX);
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("completed : tweenBarOpacity");
      }
    });
    tweenWrongBarOpacity.animate(controllerThrowAway)..addListener(() {
      setState(() {
        wrongOpacity = tweenWrongBarOpacity.evaluate(animationX);
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("completed : tweenBarOpacity");
      }
    });
    tweenX.animate(controllerThrowAway)..addListener(() {
      setState(() {
        var offset = tweenX.evaluate(animationX);
        dx = offset.dx;
        dy = offset.dy;
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("completed : tweenX");
        if (tweenX.end == Offset.zero) {
        }
        else {
          showGradually();
        }
      }
      else if (status == AnimationStatus.dismissed) {
        print("dismissed : tweenX");
      }
    });

    tweenHide.animate(controllerThrowAway)..addListener(() {
      setState(() {
        var offset = tweenHide.evaluate(animationX);
        opacity = 1;//offset;
        ratio = offset;
      });
    })..addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        print("completed : tweenHide");
        // showGradually();
      }
    });

    tweenShow.animate(controllerShowGradually)..addListener(() {
      setState(() {
        var offset = tweenShow.evaluate(animationShow);
        // print(offset);
        opacity = offset;
        ratio = offset;
      });
    })..addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        print("completed : tweenShow");
      }
    });

    tweenScaleDown.animate(controllerScaleDown)..addListener(() {
      setState(() {
        scale = tweenScaleDown.evaluate(animationScaleDown);
        // print("scale : $scale");
      });
    })..addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        print("completed : tweenScaleDown");
      }
    });

    tweenScaleUp.animate(controllerScaleUp)..addListener(() {
      setState(() {
        scale = tweenScaleUp.evaluate(animationScaleUp);
        // print("scale : $scale");
      });
    })..addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        print("completed : tweenScaleUp");
      }
    });
  }

  @override
  void dispose() {
    controllerThrowAway.dispose();
    controllerShowGradually.dispose();
    controllerScaleUp.dispose();
    controllerScaleDown.dispose();
    super.dispose();
  }

  Offset getCardCenter() {
    var availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom - topBarHeight;

    var availableWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    var left = availableWidth / 2;
    var top = availableHeight / 2;

    return Offset(left, top);
  }

  @override
  Widget build(BuildContext context) {
    var center = getCardCenter();
    var left = center.dx;
    var top = center.dy;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: topBarHeight,
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: () {})
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  print("drag start : ${details.localPosition}");
                  currentPt = details.localPosition;
                  updateDragPosition(details.localPosition);
                },
                onVerticalDragEnd: (details) {
                  print("drag end : ${details.velocity}");

                  throwAway(details.velocity);
                },
                onVerticalDragUpdate: (details) {
                  print("drag update : ${details.localPosition}");
                  updateDragPosition(details.localPosition);
                },
                onLongPress: () {
                  print("onLongPress");
                  controllerScaleUp.reset();
                  controllerScaleUp.forward();
                },
                onLongPressStart: (details) {
                  print("onLongPressStart");
                  currentPt = details.localPosition;
                  updateDragPosition(details.localPosition);
                },
                onLongPressMoveUpdate: (details) {
                  // print("onLongPressMoveUpdate");
                  updateDragPosition(details.localPosition);
                },
                onLongPressEnd: (details) {
                  print("onLongPressEnd : ${details.velocity}");
                  controllerScaleDown.reset();
                  controllerScaleDown.forward();
                  throwAway(details.velocity);
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(child: Container(
                          color: Colors.pink.shade50,
                        )),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Opacity(
                            opacity: correctOpacity,
                            child: Container(
                              height: 50,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Opacity(
                            opacity: wrongOpacity,
                            child: Container(
                              height: 50,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                        top: 10,
                        width: 30,
                        height: 30,
                        child: Container(
                          color: Colors.blue.shade50,
                        )
                    ),
                    Positioned(
                        right: 10,
                        bottom: 10,
                        width: 30,
                        height: 30,
                        child: Container(
                          color: Colors.red.shade100
                        )
                    ),
                    Positioned(
                      left: left + dx - halfCardWidth * ratio * scale,
                      top: top + dy - halfCardHeight * ratio * scale,
                      width: cardWidth * ratio * scale,
                      height: cardHeight * ratio * scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              border: Border.all(
                                color: Colors.green.shade100,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          // color: Colors.green.shade100,
                          width: cardWidth * ratio * scale,
                          height: cardHeight * ratio * scale,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Test1", style: TextStyle(fontSize: 34 * ratio * scale),),
                                Text("Test2", style: TextStyle(fontSize: 20 * ratio * scale, color: Colors.black38),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void throwAway(Velocity velocity) {
    print("throwAway");
    if (controllerThrowAway.isAnimating || controllerShowGradually.isAnimating) {
      return;
    }
    var center = getCardCenter();
    print("velocity : $velocity");
    print("center : $center");
    print("dx, dy : ${Offset(dx, dy)}");
    if (dy < -dragThreshold || velocity.pixelsPerSecond.dy < -dragSpeedThreshold) {
      tweenX.begin = Offset(dx, dy);
      tweenX.end = Offset(10, 10) - center + Offset(15, 15);

      tweenHide.begin = 1;
      tweenHide.end = 0;

      tweenCorrectBarOpacity.begin = 1;
      tweenCorrectBarOpacity.end = 0;
      tweenWrongBarOpacity.begin = 0;
      tweenWrongBarOpacity.end = 0;
    }
    else if (dy > dragThreshold || velocity.pixelsPerSecond.dy > dragSpeedThreshold) {
      var availableWidth = MediaQuery.of(context).size.width -
          MediaQuery.of(context).padding.left -
          MediaQuery.of(context).padding.right;

      var availableHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom - topBarHeight;

      tweenX.begin = Offset(dx, dy);
      tweenX.end = Offset(availableWidth, availableHeight) - Offset(10, 10) - Offset(15, 15) - center;

      tweenHide.begin = 1;
      tweenHide.end = 0;

      tweenCorrectBarOpacity.begin = 0;
      tweenCorrectBarOpacity.end = 0;
      tweenWrongBarOpacity.begin = 1;
      tweenWrongBarOpacity.end = 0;
    }
    else {
      tweenX.begin = Offset(dx, dy);
      tweenX.end = Offset.zero;

      tweenHide.begin = 1;
      tweenHide.end = 1;

      tweenCorrectBarOpacity.begin = correctOpacity;
      tweenCorrectBarOpacity.end = 0;
      tweenWrongBarOpacity.begin = wrongOpacity;
      tweenWrongBarOpacity.end = 0;
    }

    controllerThrowAway.reset();
    controllerThrowAway.forward();
  }

  void showGradually() {
    dx = 0;
    dy = 0;
    controllerShowGradually.reset();
    controllerShowGradually.forward();
  }

  void updateDragPosition(Offset newPt) {
    if (controllerThrowAway.isAnimating || controllerShowGradually.isAnimating) {
      return;
    }
    setState(() {
      dx += newPt.dx - currentPt.dx;
      dy += newPt.dy - currentPt.dy;
    });
    print("$dx, $dy");
    currentPt = newPt;

    wrongOpacity = 0;
    correctOpacity = 0;
    if (dy < 0) {
      if (dy < -dragThreshold) {
        correctOpacity = 1.0;
      }
      else {
        correctOpacity = 0.25 * -dy / dragThreshold;
      }
    }
    else if (dy > 0) {
      if (dy > dragThreshold) {
        wrongOpacity = 1.0;
      }
      else {
        wrongOpacity = 0.25 * dy / dragThreshold;
      }
    }

    setState(() {
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

