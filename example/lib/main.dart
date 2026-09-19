import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CircularHomePage(),
    );
  }
}

class CircularHomePage extends StatefulWidget {
  const CircularHomePage({super.key});

  @override
  State<CircularHomePage> createState() => _CircularHomePageState();
}

class _CircularHomePageState extends State<CircularHomePage> {
  static const int totalPage = 4;
  static const List<String> names = [
    'Home',
    'Type',
    'Duration',
    'Curve',
  ];

  static const List<IconData> icons = [
    Icons.home,
    Icons.movie,
    Icons.timer,
    Icons.multiline_chart,
  ];

  static const List<Color> colors = [
    Colors.blueGrey,
    Colors.teal,
    Colors.blue,
    Colors.brown,
  ];

  int _currentPage = 0;
  Duration duration = const Duration(milliseconds: 300);
  Curve curve = Curves.ease;
  TransitionType transitionType = TransitionType.circular;
  String selectedDuration = '300ms';
  String selectedTransactionType = 'Circular';
  String selectedCurve = 'Ease';

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
        setState(() {
          _currentPage = index;
        });
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        totalPage,
        (index) => BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: names[index],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(selectedTransactionType),
          backgroundColor: <Color>[
            Colors.blue,
            Colors.indigo,
            Colors.blueGrey,
            Colors.green,
          ][index],
        ),
        SliverFillRemaining(
          child: Container(
            color: colors[index],
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  names[index],
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
                if (index == 1)
                  _getMenuButton(
                    <String>['Circular', 'Slide', 'Fade'],
                    selectedTransactionType,
                    (value) => setState(() {
                      selectedTransactionType = value;
                      if (value == 'Circular') {
                        transitionType = TransitionType.circular;
                      } else if (value == 'Slide') {
                        transitionType = TransitionType.slide;
                      } else if (value == 'Fade') {
                        transitionType = TransitionType.fade;
                      }
                    }),
                  ),
                if (index == 2)
                  _getMenuButton(
                    <String>['300ms', '500ms', '1s', '2s'],
                    selectedDuration,
                    (value) => setState(() {
                      selectedDuration = value;
                      if (value == '300ms') {
                        duration = const Duration(milliseconds: 300);
                      } else if (value == '500ms') {
                        duration = const Duration(milliseconds: 500);
                      } else if (value == '1s') {
                        duration = const Duration(seconds: 1);
                      } else if (value == '2s') {
                        duration = const Duration(seconds: 2);
                      }
                    }),
                  ),
                if (index == 3)
                  _getMenuButton(
                    <String>[
                      'Ease',
                      'EaseIn',
                      'Elastic In Out',
                      'Bounce In Out',
                    ],
                    selectedCurve,
                    (value) => setState(() {
                      selectedCurve = value;
                      if (value == 'Ease') {
                        curve = Curves.ease;
                      } else if (value == 'EaseIn') {
                        curve = Curves.easeIn;
                      } else if (value == 'Elastic In Out') {
                        curve = Curves.elasticInOut;
                      } else if (value == 'Bounce In Out') {
                        curve = Curves.bounceInOut;
                      }
                    }),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMenuButton(
    List<String> list,
    String selectedValue,
    ValueChanged<String> onSelected,
  ) {
    return Theme(
      data: ThemeData.dark(),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: selectedValue,
        items: List.generate(
          list.length,
          (index) => DropdownMenuItem<String>(
            value: list[index],
            child: Text(list[index]),
          ),
        ),
        onChanged: (value) {
          if (value != null) onSelected(value);
        },
      ),
    );
  }
}
