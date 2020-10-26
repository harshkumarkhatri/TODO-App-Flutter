// This file has the code related to about the developer page

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webBrowserOpen.dart';

class AboutTheDev extends StatefulWidget {
  @override
  _AboutTheDevState createState() => _AboutTheDevState();
}

class _AboutTheDevState extends State<AboutTheDev> {
  bool isSwitched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About the Developer"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://avatars1.githubusercontent.com/u/42743629?s=400&u=1f68b5930fca70c68c90e2392798643919a7eeed&v=4",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Harsh Kumar Khatri",
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 30, right: 30),
                  child: Text(
                    "I am a CSE Undergraduate from Career Point University. I love to learn about technology and explore various different dynamics of it. This app is for my technovation project for 5th semester.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(height: 15),
                Text("Follow me:"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        openWebBroser("https://twitter.com/harshkhatri24");
                      },
                      child: FaIcon(
                        FontAwesomeIcons.twitter,
                        size: 30,
                        color: Color.fromRGBO(40, 168, 237, 1),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          openWebBroser("https://github.com/harshkumarkhatri");
                        },
                        child: FaIcon(FontAwesomeIcons.github, size: 30)),
                    GestureDetector(
                      onTap: () {
                        openWebBroser(
                            "https://www.youtube.com/channel/UCKNtMU9M559bmXxKoT6YeJw");
                      },
                      child: FaIcon(
                        FontAwesomeIcons.youtube,
                        size: 30,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openWebBroser(
                            "https://www.linkedin.com/in/harshkumarkhatri/");
                      },
                      child: FaIcon(
                        FontAwesomeIcons.linkedinIn,
                        size: 30,
                        color: Color.fromRGBO(14, 118, 168, 1),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
