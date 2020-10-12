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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
// class Hello extends StatelessWidget {

  GlobalKey kkk = GlobalKey();
  Offset startPt;
  Offset currentPt;
  double dx = 0;
  double dy = 0;
  AnimationController controller;
  Animation<double> animationX;
  Tween<Offset> tweenX;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 250), reverseDuration: Duration(), vsync: this);
    animationX = CurvedAnimation(parent: controller, curve: Curves.easeIn);
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

    var left = (availableWidth - 100) / 2;
    var top = (availableHeight - 100) / 2;
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
            RenderBox r = kkk.currentContext.findRenderObject();
            var newPt = detail.localPosition;
            setState(() {
              dx += newPt.dx - currentPt.dx;
              dy += newPt.dy - currentPt.dy;
            });
            print("$dx, $dy");
            currentPt = detail.localPosition;
          },
          child: Stack(
            children: [
              Expanded(child: Container(
                color: Colors.pink,
              )),
              Positioned(
                key: kkk,
                left: left + dx,
                top: top + dy,
                width: 100,
                height: 100,
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 100,
                  child: Center(
                    child: Text("hello"),
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
    controller.reset();
    controller.forward();
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

