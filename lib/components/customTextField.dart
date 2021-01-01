import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget prefixIcon;
  final bool clearable;
  final bool haveError;

  CustomTextField({
    @required this.controller,
    @required this.label,
    this.obscureText = false,
    this.prefixIcon,
    this.clearable = false,
    this.haveError = false,
  });
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();

  Color borderColor = Colors.black;
  Color borderFocusColor = Colors.green;
  Color borderErrorColor = Colors.red;
  Color cursorColor = Colors.black;
  Color labelColor = Colors.black;
  BorderRadius borderRadius = BorderRadius.all(Radius.circular(4));

  bool isFocus = false;
  bool showClearBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.removeListener(() => null);
  }

  void clearText() {
    setState(() {
      showClearBtn = false;
      widget.controller.text = '';
    });
  }

  void onChanged(text) {
    bool noText = true;
    if (text.length > 0) {
      noText = false;
    }
    setState(() {
      showClearBtn = !noText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.haveError
                  ? borderErrorColor
                  : isFocus
                      ? borderFocusColor
                      : borderColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.verified_user_outlined),
                    )
                  : SizedBox(
                      width: 15,
                    ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: cursorColor,
                  keyboardType: TextInputType.text,
                  obscureText: widget.obscureText,
                  onChanged: onChanged,
                ),
              ),
              (widget.clearable && showClearBtn)
                  ? IconButton(
                      onPressed: () {
                        clearText();
                      },
                      icon: Icon(Icons.close_rounded),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Positioned(
          left: 15,
          top: 0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              widget.label,
              style: TextStyle(color: labelColor),
            ),
          ),
        ),
      ],
    );
  }
}
