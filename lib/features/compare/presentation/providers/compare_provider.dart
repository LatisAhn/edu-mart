import 'package:flutter/foundation.dart';
import '../../domain/entities/camp_compare_entity.dart';

class CompareProvider extends ChangeNotifier {
  final List<CampCompareEntity> _compareList = [];
  static const int maxCompareItems = 3;

  List<CampCompareEntity> get compareList => _compareList;
  
  bool get isFull => _compareList.length >= maxCompareItems;
  bool get isEmpty => _compareList.isEmpty;
  int get itemCount => _compareList.length;

  void addToCompare(CampCompareEntity camp) {
    if (_compareList.length < maxCompareItems && !_compareList.any((item) => item.campId == camp.campId)) {
      _compareList.add(camp);
      notifyListeners();
    }
  }

  void removeFromCompare(String campId) {
    _compareList.removeWhere((item) => item.campId == campId);
    notifyListeners();
  }

  void clearAll() {
    _compareList.clear();
    notifyListeners();
  }

  bool isInCompareList(String campId) {
    return _compareList.any((item) => item.campId == campId);
  }
}
