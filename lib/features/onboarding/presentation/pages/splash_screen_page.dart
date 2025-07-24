import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/view/widgets/niklaar_icon.dart';
import '../../../../app/view/widgets/niklaar_logo.dart';
import '../../../../core/constants/app_colors.dart';
import 'onboarding.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animate();
  }

  animate() {
    animationController = AnimationController(
      duration: const Duration(seconds: 2), // Adjust duration
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: AnimatedSplashScreen(
          splash: const Splash(),
          splashIconSize: double.infinity,
          duration: 10000,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          animationDuration: const Duration(milliseconds: 600),
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: const OnboardingPage(),
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _smallController;

  late Animation<double> _smallAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _smallController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _smallAnimation = Tween<double>(begin: 1, end: 0).animate(_smallController)
      ..addListener(() {
        setState(() {});
      });
    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(_smallController)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed((const Duration(seconds: 5)), () {
      _smallController.forward();
    });
  }

  @override
  dispose() {
    _smallController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            NiklaarLogo(
              opacity: _iconAnimation.value,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // 0% at top
                  end: Alignment.bottomCenter, // 100% at bottom
                  colors: [
                    AppColors.blue94.withOpacity(_smallAnimation.value),
                    AppColors.primary.withOpacity(_smallAnimation.value),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Center(
                child: Transform.translate(
                  offset: Offset(_iconAnimation.value * -90.w, 0),
                  child: NiklaarIcon(
                    opacity: _smallAnimation.value,
                  ),
                ),
              ),
            ),

            /*Transform.translate(
              offset: Offset(_smallAnimation.value * -100.w, 0),
              child: Image.asset(
                iconLogo,
                height: 82.h,
                fit: BoxFit.contain,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

/*
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Splash Screen"),
        actions: [
          Switch(
            value: context.read<ThemeBloc>().state == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(ThemeChanged(isDark: value));
            },
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Fresh"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
