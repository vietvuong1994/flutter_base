import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final double width;
  final double height;
  final Widget leadIcon;
  GradientButton({
    @required this.title,
    @required this.onPressed,
    this.width = 300,
    this.height = 50,
    this.leadIcon,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width,
            minHeight: height,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: leadIcon,
                    )
                  : SizedBox(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
