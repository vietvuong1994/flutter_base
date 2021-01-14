import 'package:DJCloud/commons/http/apiUtils.dart';
import 'package:DJCloud/components/customTextField.dart';
import 'package:DJCloud/components/gradientButton.dart';
import 'package:DJCloud/components/snsButtons/snsButtonsUI.dart';
import 'package:flutter/material.dart';

class HomeUi extends StatelessWidget {
  final dynamic argument;
  HomeUi(this.argument);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(children: [
          CustomTextField(controller: controller, label: 'Họ tên'),
          GradientButton(
            title: 'Test Api',
            onPressed: () {
              ApiUtils().callApiExample(context);
            },
          ),
          SNSButtonsUI()
        ]),
      ),
    );
  }
}