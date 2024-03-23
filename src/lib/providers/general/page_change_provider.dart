import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter/cupertino.dart';

import '../../pages/diet/diet_recipe_creator.dart';
import '../../pages/diet_new/diet_home.dart';
import '../../pages/workout_new/workout_home.dart';

class PageChange with ChangeNotifier {

  final pages = [
    WorkoutHomePageNew(),
    DietHomePage(),
    const HomePage(),
    const MeasurementsHomePage(),
  ];

  late bool _navigationBarCache = true;
  bool get navigationBarCache => _navigationBarCache;

  final double defaultScale = 0.9;
  final double defaultBackScale = 1.1;

  late double _transitionScaleFactor = defaultScale;

  double get transitionScaleFactor => _transitionScaleFactor;

  late bool _dataLoadingFromSplashPage = true;

  bool get dataLoadingFromSplashPage => _dataLoadingFromSplashPage;

  late bool _caloriesCalculated = false;

  bool get caloriesCalculated => _caloriesCalculated;

  Widget _pageWidget = DietHomePage();
  List<Widget> _pageWidgetCache = [DietHomePage()];
  int _pageWidgetCacheIndex = 0;

  late int _confirmationCounter = 0;

  Widget get pageWidget => _pageWidget;
  List<Widget> get pageWidgetCache => _pageWidgetCache;
  int get pageWidgetCacheIndex => _pageWidgetCacheIndex;

  late bool _confirmation = false;

  bool get confirmation => _confirmation;

  void setCaloriesCalculated(bool _dataLoaded) {

    _caloriesCalculated = _dataLoaded;

    notifyListeners();
  }

  void setDataLoadingStatus(bool _dataLoaded) {

    _dataLoadingFromSplashPage = _dataLoaded;

    notifyListeners();
  }

  void changePageRemovePreviousCache(Widget newPage) {

    if (_navigationBarCache) {
      _navigationBarCache = false;
      _pageWidgetCache = [_pageWidget];
    }

    setTransitionScale(defaultScale);

    _pageWidget = newPage;

    _pageWidgetCache.add(_pageWidget);
    _pageWidgetCache.removeAt(_pageWidgetCache.length-2);

    _pageWidgetCacheIndex = _pageWidgetCache.length - 1;

    FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
    debugPrint(_pageWidgetCache.toString());
    notifyListeners();
  }

  void navigatorBarNavigationReset(int navigatorIndex) {

    setTransitionScale(defaultBackScale);

    _navigationBarCache = true;

    _pageWidgetCache = pages;
    _pageWidgetCacheIndex = navigatorIndex;

    _pageWidget = pages[navigatorIndex];

    FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
    debugPrint(_pageWidgetCache.toString());
    notifyListeners();
  }

  void changePageClearCache(Widget newPage) {

    if (_navigationBarCache) {
      _navigationBarCache = false;
      _pageWidgetCache = [_pageWidget];
    }

    setTransitionScale(defaultBackScale);
    _confirmation = false;
    _pageWidget = newPage;

    _pageWidgetCache = [_pageWidget];
    _pageWidgetCacheIndex = 0;

    FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
    debugPrint(_pageWidgetCache.toString());
    notifyListeners();
  }

  void changePageCache(Widget newPage) {

    if (_navigationBarCache) {
      _navigationBarCache = false;
      _pageWidgetCache = [_pageWidget];
    }

    setTransitionScale(defaultScale);

    if (newPage.runtimeType == FoodRecipeCreator && _confirmation == false) {
      _confirmation = true;
    }

    _pageWidget = newPage;

    if (_pageWidgetCache.isEmpty) {
      _pageWidgetCache.add(_pageWidget);
      _pageWidgetCacheIndex = _pageWidgetCache.length-1;
    } else if (newPage != _pageWidgetCache.last) {
      _pageWidgetCache.add(newPage);
      _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      //if (_pageWidgetCache.length > 5) {
      //  _pageWidgetCache.removeAt(0);
      //  _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      //}
    }

    FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
    debugPrint(_pageWidgetCache.toString());
    notifyListeners();
  }

  void setTransitionScale(double scale) {

    _transitionScaleFactor = scale;
    notifyListeners();

  }

  void backPage() {

    setTransitionScale(defaultBackScale);

    if (_pageWidgetCache.last.runtimeType == FoodRecipeCreator) {

      if (_confirmationCounter >= 1) {
        _confirmation = false;
        _confirmationCounter = 0;
        _pageWidgetCache.removeLast();
        ///TODO this may throw errors if cache is ever 0 after removeLast
        _pageWidgetCacheIndex = _pageWidgetCache.length-1;

        if (_pageWidgetCache.isEmpty) {
          _pageWidgetCache.add(const HomePage());
          _pageWidgetCacheIndex = _pageWidgetCache.length-1;
        }

        FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
        debugPrint(_pageWidgetCache.toString());
        notifyListeners();
      } else {
        _confirmationCounter++;
      }

    } else {

      _confirmation = false;
      _pageWidgetCache.removeLast();
      ///TODO this may throw errors if cache is ever 0 after removeLast
      _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      if (_pageWidgetCache.isEmpty) {
        _pageWidgetCache.add(const HomePage());
        _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      }

      FirebaseAnalytics.instance.logEvent(name: 'navigated_to_'+(_pageWidgetCache[_pageWidgetCacheIndex].runtimeType.toString()).replaceAll(" ", "_"));
      debugPrint(_pageWidgetCache.toString());
      notifyListeners();
    }
    //setTransitionScale(0.8);
  }

}