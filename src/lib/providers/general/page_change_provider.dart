import 'package:fitness_tracker/exports.dart';
import 'package:flutter/cupertino.dart';

import '../../pages/diet/diet_recipe_creator.dart';

class PageChange with ChangeNotifier {
  Widget _pageWidget = const DietHomePage();
  List<Widget> _pageWidgetCache = [const DietHomePage()];
  int _pageWidgetCacheIndex = 0;

  late int _confirmationCounter = 0;

  Widget get pageWidget => _pageWidget;
  List<Widget> get pageWidgetCache => _pageWidgetCache;
  int get pageWidgetCacheIndex => _pageWidgetCacheIndex;

  late bool _confirmation = false;

  bool get confirmation => _confirmation;

  void changePageRemovePreviousCache(Widget newPage) {
    _pageWidget = newPage;

    _pageWidgetCache.add(_pageWidget);
    _pageWidgetCache.removeAt(_pageWidgetCache.length-2);

    _pageWidgetCacheIndex = _pageWidgetCache.length - 1;

    print(_pageWidgetCache);
    notifyListeners();
  }

  void changePageClearCache(Widget newPage) {

    _confirmation = false;

    _pageWidget = newPage;

    _pageWidgetCache = [_pageWidget];
    _pageWidgetCacheIndex = 0;

    notifyListeners();
  }

  void changePageCache(Widget newPage) {

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
      if (_pageWidgetCache.length > 5) {
        _pageWidgetCache.removeAt(0);
        _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      }
    }

    print(_pageWidgetCache);
    notifyListeners();
  }

  void backPage() {

    if (_pageWidgetCache.last.runtimeType == FoodRecipeCreator) {

      if (_confirmationCounter >= 1) {
        _confirmation = false;
        _confirmationCounter = 0;
        _pageWidgetCache.removeLast();
        _pageWidgetCacheIndex = _pageWidgetCache.length-1;

        if (_pageWidgetCache.isEmpty) {
          _pageWidgetCache.add(const HomePage());
          _pageWidgetCacheIndex = _pageWidgetCache.length-1;
        }

        notifyListeners();
      } else {
        _confirmationCounter++;
      }

    } else {

      _confirmation = false;
      _pageWidgetCache.removeLast();
      _pageWidgetCacheIndex = _pageWidgetCache.length-1;

      if (_pageWidgetCache.isEmpty) {
        _pageWidgetCache.add(const HomePage());
        _pageWidgetCacheIndex = _pageWidgetCache.length-1;
      }

      notifyListeners();
    }

  }

}