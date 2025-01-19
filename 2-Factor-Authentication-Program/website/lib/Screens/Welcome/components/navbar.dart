import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../Login/login_page.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopNavbar();
      } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        return DesktopNavbar();
      } else {
        return MobileNavbar();
      }
    });
  }
}

class DesktopNavbar extends StatelessWidget {
  // const DesktopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Adrastea Bank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40),
          ),
          Row(
            children: [
              Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "About Us",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "Portfolio",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 30,
              ),
              MaterialButton(
                color: MainColour,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text("Sign in", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}

class MobileNavbar extends StatelessWidget {
  // const MobileNavbar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        child: Column(children: [
          Text(
            "Adrastea Bank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 60),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Container(
              color: SecondaryColour,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "About Us",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Portfolio",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
