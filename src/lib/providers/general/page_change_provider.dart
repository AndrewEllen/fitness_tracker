import 'package:fitness_tracker/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PageChange with ChangeNotifier {
  Widget _pageWidget = HomePage();
  List<Widget> _pageWidgetCache = [HomePage()];
  int _pageWidgetCacheIndex = 0;

  Widget get pageWidget => _pageWidget;
  List<Widget> get pageWidgetCache => _pageWidgetCache;
  int get pageWidgetCacheIndex => _pageWidgetCacheIndex;


  void changePageRemovePreviousCache(Widget newPage) {
    _pageWidget = newPage;

    _pageWidgetCache.add(_pageWidget);
    _pageWidgetCache.removeAt(_pageWidgetCache.length-2);

    _pageWidgetCacheIndex = _pageWidgetCache.length - 1;

    print(_pageWidgetCache);
    notifyListeners();
  }

  void changePageClearCache(Widget newPage) {
    _pageWidget = newPage;

    _pageWidgetCache = [_pageWidget];
    _pageWidgetCacheIndex = 0;

    notifyListeners();
  }

  void changePageCache(Widget newPage) {
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

    _pageWidgetCache.removeLast();
    _pageWidgetCacheIndex = _pageWidgetCache.length-1;

    if (_pageWidgetCache.length == 0) {
      _pageWidgetCache.add(HomePage());
      _pageWidgetCacheIndex = _pageWidgetCache.length-1;
    }

    notifyListeners();
  }

}