import 'package:adhtp_general_analysis/page/about.dart';
import 'package:adhtp_general_analysis/page/ai_assistant.dart';
import 'package:adhtp_general_analysis/page/main_questionare.dart';
import 'package:adhtp_general_analysis/page/history.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class NavigatorServices extends StatefulWidget {
  const NavigatorServices({super.key});
  @override
  State<NavigatorServices> createState() => _NavigatorServicesState();
}

class _NavigatorServicesState extends State<NavigatorServices>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedIndex = 0;
  final List<Widget> _windgetOption = <Widget>[
    MainQuestionare(),
    HistoryResults(),
    AiAssistant(),
    AboutPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("ADHTP General Analysis")),
      bottomNavigationBar:
          MediaQuery.of(context).size.width <= 590
              ? NavigationBar(
                onDestinationSelected:
                    (i) => setState(() => _selectedIndex = i),
                selectedIndex: _selectedIndex,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history_outlined),
                    selectedIcon: Icon(Icons.history_rounded),
                    label: 'History',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search_outlined),
                    selectedIcon: Icon(Icons.search_rounded),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.info_outline_rounded),
                    selectedIcon: Icon(Icons.info_rounded),
                    label: 'About',
                  ),
                ],
              )
              : null,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (MediaQuery.of(context).size.width > 590 &&
              MediaQuery.of(context).size.width <= 810)
            NavigationRail(
              selectedIndex: _selectedIndex,
              groupAlignment: 0,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: Text('My Parcel'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search_rounded),
                  label: Text('Search'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline_rounded),
                  selectedIcon: Icon(Icons.info_rounded),
                  label: Text('About'),
                ),
              ],
            ),
          if (MediaQuery.of(context).size.width > 810)
            NavigationDrawer(
              backgroundColor: Theme.of(context).colorScheme.surface,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              selectedIndex: _selectedIndex,
              children: const <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(28, 16, 16, 0)),
                NavigationDrawerDestination(
                  label: Text('Home'),
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                ),
                NavigationDrawerDestination(
                  label: Text('My Parcel'),
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                ),
                NavigationDrawerDestination(
                  label: Text('Search'),
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search_rounded),
                ),
                NavigationDrawerDestination(
                  label: Text('About'),
                  icon: Icon(Icons.info_outline_rounded),
                  selectedIcon: Icon(Icons.info_rounded),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
                  child: Divider(),
                ),
              ],
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth < 590 ? 0 : 30),
              ),
              child: PageTransitionSwitcher(
                transitionBuilder:
                    (child, animation, secondaryAnimation) =>
                        SharedAxisTransition(
                          transitionType: SharedAxisTransitionType.vertical,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        ),
                child: _windgetOption.elementAt(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
