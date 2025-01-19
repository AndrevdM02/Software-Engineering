import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    //this.topImage = "assets/images/Empty.png",
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
