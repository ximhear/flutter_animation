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
      home: MyHomePage(title: "hhhh")
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
// class Hello extends StatelessWidget {

  GlobalKey kkk = GlobalKey();
  Offset startPt;
  Offset currentPt;
  double dx = 0;
  double dy = 0;
  AnimationController controller;
  AnimationController controller1;
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
  double opacity = 1;
  double ratio = 1;
  double scale = 1;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1000), reverseDuration: Duration(), vsync: this);
    controller1 = AnimationController(duration: const Duration(milliseconds: 1000), reverseDuration: Duration(), vsync: this);
    animationX = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animationShow = CurvedAnimation(parent: controller1, curve: Curves.easeIn);
    tweenHide = Tween<double>(begin: 1, end: 0);
    tweenShow = Tween<double>(begin: 0, end: 1);

    controllerScaleUp = AnimationController(duration: const Duration(milliseconds: 1000), reverseDuration: Duration(), vsync: this);
    controllerScaleDown = AnimationController(duration: const Duration(milliseconds: 1000), reverseDuration: Duration(), vsync: this);
    animationScaleUp = CurvedAnimation(parent: controllerScaleUp, curve: Curves.easeIn);
    animationScaleDown = CurvedAnimation(parent: controllerScaleDown, curve: Curves.easeIn);
    tweenScaleUp = Tween<double>(begin: 1, end: 1.5);
    tweenScaleDown = Tween<double>(begin: 1.5, end: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    var availableWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    var left = (availableWidth - 100 * scale) / 2 + 50 * scale;
    var top = (availableHeight - 100 * scale) / 2 + 50 * scale;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("title"),
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragStart: (detail) {
            print("drag start : ${detail.localPosition}");
            currentPt = detail.localPosition;
          },
          onVerticalDragEnd: (detail) {
            print("drag end : ${detail.velocity}");

            aaa();
          },
          onVerticalDragUpdate: (detail) {
            print("drag update : ${detail.localPosition}");
            var newPt = detail.localPosition;
            setState(() {
              dx += newPt.dx - currentPt.dx;
              dy += newPt.dy - currentPt.dy;
            });
            print("$dx, $dy");
            currentPt = detail.localPosition;
          },
          onLongPress: () {
            print("onLongPress");
            tweenScaleUp.animate(controllerScaleUp)..addListener(() {
              setState(() {
                scale = tweenScaleUp.evaluate(animationScaleUp);
                print("scale : $scale");
              });
            });
            controllerScaleUp.reset();
            controllerScaleUp.forward();
          },
          onLongPressStart: (details) {
            print("onLongPressStart");
            currentPt = details.localPosition;
          },
          onLongPressMoveUpdate: (details) {
            // print("onLongPressMoveUpdate");
            var newPt = details.localPosition;
            setState(() {
              dx += newPt.dx - currentPt.dx;
              dy += newPt.dy - currentPt.dy;
            });
            print("$dx, $dy");
            currentPt = details.localPosition;
          },
          onLongPressEnd: (details) {
            print("onLongPressEnd : ${details.velocity}");
            tweenScaleDown.animate(controllerScaleDown)..addListener(() {
              setState(() {
                scale = tweenScaleDown.evaluate(animationScaleDown);
                print("scale : $scale");
              });
            });
            controllerScaleDown.reset();
            controllerScaleDown.forward();
            aaa();
          },
          child: Stack(
            children: [
              Expanded(child: Container(
                color: Colors.pink,
              )),
              Positioned(
                key: kkk,
                left: left + dx - 50 * ratio * scale,
                top: top + dy - 50 * ratio * scale,
                width: 100 * ratio * scale,
                height: 100 * ratio * scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    color: Colors.green,
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Text("hello", style: TextStyle(fontSize: 34 * ratio * scale),),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Center(
                    child: FlatButton(
                      child: Text("move"),
                      onPressed: () {
                      },
                    ),
                  ),
                  Center(
                    child: FlatButton(
                      child: Text("animate"),
                      onPressed: () {
                          aaa();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void aaa() {
    tweenX = Tween<Offset>(
      begin: Offset(dx, dy),
      end: Offset.zero,
    );
    tweenX.animate(controller)..addListener(() {
      setState(() {
        var offset = tweenX.evaluate(animationX);
        dx = offset.dx;
        dy = offset.dy;
      });
    });
    tweenHide.animate(controller)..addListener(() {
      setState(() {
        var offset = tweenHide.evaluate(animationX);
        opacity = offset;
        ratio = offset;
      });
    })..addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.completed) {
        print("completed");
        bbb();
      }
    });
    controller.reset();
    controller.forward();
  }

  void bbb() {
    tweenShow.animate(controller1)..addListener(() {
      setState(() {
        var offset = tweenShow.evaluate(animationShow);
        print(offset);
        opacity = offset;
        ratio = offset;
      });
    })..addStatusListener((status) {
      print(status);
    });
    controller1.reset();
    controller1.forward();
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

