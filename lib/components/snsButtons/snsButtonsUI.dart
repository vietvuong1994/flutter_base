import 'dart:io';

import 'package:flutter/material.dart';

class SNSButtonsUI extends StatefulWidget {
  @override
  _SNSButtonsUIState createState() => _SNSButtonsUIState();
}

class _SNSButtonsUIState extends State<SNSButtonsUI> {
  List<Map> buttons;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttons = [
      {"icon": "", "type": "", "color": ""},
      {"icon": "", "type": "", "color": ""},
    ];
    if (Platform.isIOS) {
      buttons.add({"icon": "", "type": "", "color": ""});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(child: SizedBox(),),
          ...List.generate(
            buttons.length,
            (item) {
              return FlatButton(
                  onPressed: () {},
                  color: Colors.black,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                
              );
            },
          ),
          Expanded(child: SizedBox(),),
        ],
      ),
    );
  }
}
