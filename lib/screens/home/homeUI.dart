import 'package:DJCloud/commons/customNavigator.dart';
import 'package:DJCloud/components/customBottomBar/customBottomBarUI.dart';
import 'package:DJCloud/providers/musicPlayerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatefulWidget {
  final dynamic argument;
  HomeUI(this.argument);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  Page _page = Page('Page 0');
  int _currentIndex = 0;

  final _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
    BottomNavigationBarItem(icon: Icon(Icons.event), label: 'events'),
    BottomNavigationBarItem(icon: Icon(Icons.save_alt), label: 'downloads'),
  ];

  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void onTap(index) {
    // here we used the navigator key to pop the stack to get back to our
    // main page
    navigatorKey.currentState.maybePop();
    setState(() => _page = Page('Page $index'));
    _currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        items: _items,
        currentItem: _currentIndex,
        onTap: onTap,
      ),
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        //Specify your page route [PageRoutes.materialPageRoute] or [PageRoutes.cupertinoPageRoute]
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }
}

class Page extends StatefulWidget {
  final String title;

  const Page(this.title) : assert(title != null);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(widget.title);

    return Container(
      child: Center(
          child: FlatButton(
              onPressed: () {
                // Provider.of<MusicPlayerModel>(context, listen: false).showSmallPlayer();
                _openDetailsPage(context);
              },
              child: text)),
    );
  }

  //Use the navigator like you usually do with .of(context) method
  _openDetailsPage(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => DetailsPage(widget.title)));

//  _openDetailsPage(BuildContext context) => mainNavigatorKey.currentState.push(MaterialPageRoute(builder: (context) => DetailsPage(title)));

}

class DetailsPage extends StatelessWidget {
  final String title;

  const DetailsPage(this.title) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    final text = Text('Details of $title');
    return Container(
      child: Center(child: text),
    );
  }
}
