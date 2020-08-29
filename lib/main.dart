import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animation_trigger_testing/trigger_observer.dart';

import 'trigger/cubit/trigger_cubit.dart';

void main() {
  Bloc.observer = TriggerObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TriggerCubit(),
        child: Gui(),
      ),
    );
  }
}

class Gui extends StatelessWidget {
  const Gui({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BulletAnimation(),
      floatingActionButton: BlocBuilder<TriggerCubit, Diff>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              context.bloc<TriggerCubit>().fire(Diff(true, 0));
            },
            child: const Icon(
              Icons.warning,
              color: Colors.black,
            ),
            backgroundColor: Colors.amber,
          );
        },
      ),
    );
  }
}

class BulletAnimation extends StatefulWidget {
  const BulletAnimation({
    Key key,
  }) : super(key: key);

  @override
  _BulletAnimationState createState() => _BulletAnimationState();
}

class _BulletAnimationState extends State<BulletAnimation> {
  static const int bulletTravel = 5;
  static const int milliseconds = 60;
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
    return BlocConsumer<TriggerCubit, Diff>(
      listener: (context, state) {
        if (state.trigger && state.index == 0) launchBullet();
      },
      builder: (context, state) {
        return Stack(
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
          ],
        );
      },
    );
  }
}
