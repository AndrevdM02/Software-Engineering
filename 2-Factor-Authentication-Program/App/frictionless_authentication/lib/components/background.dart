import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  //final String topImage;
  //---Uncomment above to insert backround images
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: [
            // Colors.yellow,
            // Colors.red,
            // Colors.indigo,
            // Colors.teal,
            Color.fromARGB(255, 12, 4, 131),
            Colors.lightBlue,
            Color.fromARGB(255, 48, 213, 200),
            Color.fromARGB(255, 68, 136, 127),
          ],
        )),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
