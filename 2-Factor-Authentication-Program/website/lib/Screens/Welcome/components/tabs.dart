import 'package:flutter/material.dart';
import '../../../constants.dart';

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return DesktopTabs();
      } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        return DesktopTabs();
      } else {
        return MobileTabs();
      }
    });
  }
}

class DesktopTabs extends StatelessWidget {
  // const DesktopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
          color: SecondaryColour,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Accounts",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Credit cards",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Loans",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Invest",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Insurance",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Rewards",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class MobileTabs extends StatelessWidget {
  // const MobileNavbar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      // child: ElevatedButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) {
      //           return LoginPage();
      //         },
      //       ),
      //     );
      //   },
      //   style: ElevatedButton.styleFrom(
      //       backgroundColor: SecondaryColour, elevation: 0),
      //   child: Text(
      //     "Sign In".toUpperCase(),
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
    );
  }
}
