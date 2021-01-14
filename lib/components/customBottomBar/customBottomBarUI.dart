import 'package:DJCloud/providers/musicPlayerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomBar extends StatefulWidget {
  final List items;
  final int currentItem;
  final Function onTap;
  CustomBottomBar({
    @required this.items,
    @required this.currentItem,
    @required this.onTap,
  });
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    Provider.of<MusicPlayerModel>(context, listen: false).initSmallPlayer(this);
    animController = Provider.of<MusicPlayerModel>(context, listen: false).animController;

    animation = Tween<double>(begin: 0, end: 100).animate(animController)
      ..addListener(() {
        setState(() {});
      });
    // Provider.of<MusicPlayerModel>(context, listen: false).showSmallPlayer();
    // Future.delayed(Duration(seconds: 5), () {
    //   Provider.of<MusicPlayerModel>(context, listen: false).hideSmallplayer();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Container(
          color: Colors.red,
          width: double.infinity,
          height: animation?.value,
        ),
        BottomNavigationBar(
          items: widget.items,
          onTap: widget.onTap,
          currentIndex: widget.currentItem,
        ),
      ],
    );
  }
}
