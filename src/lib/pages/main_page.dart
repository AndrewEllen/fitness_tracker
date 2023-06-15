import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness_tracker/providers/user_nutrition_data.dart';
import 'package:fitness_tracker/widgets/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/page_change_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<CurvedNavigationBarState> _NavigationBarKey = GlobalKey();
  bool _loading = true;

  final pages = [
    WorkoutsHomePage(),
    DietHomePage(),
    const HomePage(),
    MeasurementsHomePage(),
    const InformationHomePage(),
  ];

  int _currentNavigatorIndex = 2;
  int _previousIndex = 2;

  static const List<Widget> itemsUnselected = [
    Icon(Icons.fitness_center, size: 30, color: Colors.white,),
    Icon(MdiIcons.foodApple, size: 30, color: Colors.white,),
    Icon(Icons.home, size: 30, color: Colors.white,),
    Icon(MdiIcons.ruler, size: 30, color: Colors.white,),
    Icon(MdiIcons.informationOutline, size: 30, color: Colors.white,),
  ];

  static final List<Widget> itemsSelected = [
    const Icon(Icons.fitness_center, size: 40, color: Colors.white,),
    const Icon(MdiIcons.foodApple, size: 40, color: Colors.white,),
    const Icon(Icons.home, size: 40, color: Colors.white,),
    const Icon(MdiIcons.ruler, size: 40, color: Colors.white,),
    const Icon(MdiIcons.informationOutline, size: 40, color: Colors.white,),
  ];

  late List<Widget> items;

  @override
  void initState() {
    items = [...itemsUnselected];
    items[_currentNavigatorIndex] = itemsSelected[_currentNavigatorIndex];

    //todo replace below hardcoded values with data from database

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _loading = false;
      });
    });

    super.initState();
  }

  navBarColor(int index) {
    setState(() {
      _previousIndex = _currentNavigatorIndex;
      _currentNavigatorIndex = index;
      context.read<PageChange>().changePageClearCache(pages[index]);

      items[_currentNavigatorIndex] = itemsSelected[_currentNavigatorIndex];
      items[_previousIndex] = itemsUnselected[_previousIndex];
    });

    //_PageController.jumpToPage(_currentNavigatorIndex);
  }

  Future<bool> _onBackKey() async {
    if (context.read<PageChange>().pageWidgetCacheIndex == 0) {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: appTertiaryColour,
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          title: const Text('Are you sure?'),
          content: const Text('Do you want to close the app?'),
          actions: <Widget>[
            AppButton(
              onTap: () => Navigator.of(context).pop(false),
              buttonText: "No",
            ),
            AppButton(
              onTap: () => SystemNavigator.pop(),
              buttonText: "Yes",
            ),
          ],
        ),
      )) ?? false;
    } else {
      context.read<PageChange>().backPage();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: _onBackKey,
            child: Scaffold(
              backgroundColor: appPrimaryColour,
              bottomNavigationBar: CurvedNavigationBar(
                  key: _NavigationBarKey,
                  backgroundColor: appTertiaryColour.withAlpha(100),
                  buttonBackgroundColor: appSecondaryColour,
                  //buttonBackgroundColor: Colors.transparent,
                  color: appTertiaryColour,
                  index: _currentNavigatorIndex,
                  height: 46,
                  animationDuration: const Duration(milliseconds: 300),
                  items: items,
                  onTap: (index) {
                    navBarColor(index);
                  }
              ),
              body: _loading
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: appSecondaryColour,
                  ))
                  : IndexedStack(
                children: context.read<PageChange>().pageWidgetCache,
                index: context.watch<PageChange>().pageWidgetCacheIndex,
              ),
              ),
          ),
    );
  }
}