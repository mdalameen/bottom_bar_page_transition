import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CircularHomePage(),
    );
  }
}

class CircularHomePage extends StatefulWidget {
  @override
  _CircularHomePageState createState() => _CircularHomePageState();
}

class _CircularHomePageState extends State<CircularHomePage>
    with TickerProviderStateMixin {
  static const int totalPage = 4;
  static const List<String> names = [
    'Home',
    'Type',
    'Duration',
    'Curve',
  ];

  List<IconData> icons = [
    Icons.home,
    Icons.movie,
    Icons.timer,
    Icons.multiline_chart
  ];

  static const List<Color> colors = [
    Colors.blueGrey,
    Colors.teal,
    Colors.blue,
    Colors.brown
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBarPageTransition(
        builder: (_, index) => _getBody(index),
        currentIndex: _currentPage,
        totalLength: totalPage,
        transitionType: transitionType,
        transitionDuration: duration,
        transitionCurve: curve,
      ),
      bottomNavigationBar: _getBottomBar(),
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          _currentPage = index;
          setState(() {});
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(
            totalPage,
            (index) => BottomNavigationBarItem(
                  icon: Icon(icons[index]),
                  label: names[index],
                )));
  }

  Duration duration = Duration(milliseconds: 300);
  Curve curve = Curves.ease;
  TransitionType transitionType = TransitionType.circular;
  String selectedDuration = '300ms';
  String selectedTransactionType = 'Circular';
  String selectedCurve = 'Ease';

  Widget _getBody(int index) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(selectedTransactionType),
          backgroundColor: <Color>[
            Colors.blue,
            Colors.indigo,
            Colors.blueGrey,
            Colors.green
          ][index],
        ),
        SliverFillRemaining(
          child: Container(
            color: colors[index],
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(names[index],
                    style: TextStyle(fontSize: 50, color: Colors.white)),
                if (index == 1)
                  _getMenuButton(
                      <String>['Circular', 'Slide', 'Fade'],
                      selectedTransactionType,
                      (_) => setState(() {
                            selectedTransactionType = _;
                            if (_ == 'Circular')
                              transitionType = TransitionType.circular;
                            else if (_ == 'Slide')
                              transitionType = TransitionType.slide;
                            else if (_ == 'Fade')
                              transitionType = TransitionType.fade;
                          })),
                if (index == 2)
                  _getMenuButton(
                      <String>['300ms', '500ms', '1s', '2s'],
                      selectedDuration,
                      (_) => setState(() {
                            selectedDuration = _;
                            if (_ == '300ms')
                              duration = Duration(milliseconds: 300);
                            else if (_ == '500ms')
                              duration = Duration(milliseconds: 500);
                            else if (_ == '1s')
                              duration = Duration(seconds: 1);
                            else if (_ == '2s') duration = Duration(seconds: 2);
                          })),
                if (index == 3)
                  _getMenuButton(
                      <String>[
                        'Ease',
                        'EaseIn',
                        'Elastic In Out',
                        'Bounce In Out'
                      ],
                      selectedCurve,
                      (_) => setState(() {
                            selectedCurve = _;
                            if (_ == 'Ease')
                              curve = Curves.ease;
                            else if (_ == 'EaseIn')
                              curve = Curves.easeIn;
                            else if (_ == 'Elastic In Out')
                              curve = Curves.elasticInOut;
                            else if (_ == 'Bounce In Out')
                              curve = Curves.bounceInOut;
                          })),
              ],
            ),
          ),
        )
      ],
    );
  }

  _getMenuButton(List<String> list, String selectedValue,
      ValueChanged<String> onSelected) {
    return Theme(
        data: ThemeData.dark(),
        child: DropdownButton(
            underline: SizedBox(),
            value: selectedValue,
            items: List.generate(
                list.length,
                (index) => DropdownMenuItem<String>(
                      child: Text(list[index]),
                      value: list[index],
                    )),
            onChanged: onSelected));
  }
}
