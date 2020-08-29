import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int bulletTravel = 20;
  static const int milliseconds = 100;
  List<int> bullets = List.generate(bulletTravel, (index) => -1);
  int header = 0;

  void launchBullet() {
    const duration = const Duration(milliseconds: milliseconds);
    shootBullet(header, duration);
    header++;
    if (header == bullets.length) header = 0;
  }

  void shootBullet(int header, duration) {
    if (bullets[header] == -1)
      Timer.periodic(
        duration,
        (Timer timer) {
          setState(() {
            bullets[header]++;
          });
          if (bulletIsOut(header)) {
            timer.cancel();
            bullets[header] = -1;
          }
        },
      );
  }

  void updateBullet(int index) {
    setState(() {
      bullets[index]++;
    });
  }

  bool bulletIsOut(index) {
    if (bullets[index] > bulletTravel) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: bulletTravel,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: bulletTravel),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(color: Colors.grey[900]),
                ),
              );
            },
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: bulletTravel,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: bulletTravel),
            itemBuilder: (context, index) {
              if (bullets.contains(index)) {
                return Container(
                  padding: EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(color: Colors.red),
                  ),
                );
              }
              return Container();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.warning,
                color: Colors.amber,
              ),
              onPressed: launchBullet,
            ),
          ),
        ],
      ),
    );
  }
}
