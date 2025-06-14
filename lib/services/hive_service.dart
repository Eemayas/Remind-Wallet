import 'package:hive/hive.dart';
import 'package:remind_wallet/constant.dart';
import 'package:remind_wallet/global/utils/logger.dart';

import '../models/category_model.dart';

class HiveService {
  static const String className = 'HiveService';
  final Box _box = Hive.box(newHiveDatabase);

  Future<void> saveCategories({
    required List<CategoryModel> categories,
    required String key,
  }) async {
    final functionName = '$className.saveCategories';
    try {
      logStarting(
          functionName: functionName,
          message: 'Saving categories to key: $key');
      final jsonList = categories.map((cat) => cat.toJson()).toList();
      await _box.put(key, jsonList);
      logSuccess(
          functionName: functionName,
          message: 'Saved ${categories.length} categories',
          code: 200);
    } catch (e) {
      logError(
          functionName: functionName, message: e.toString(), errorCode: 500);
    }
  }

  List<CategoryModel> loadCategories({required String key}) {
    final functionName = '$className.loadCategories';
    try {
      logStarting(
          functionName: functionName,
          message: 'Loading categories for key: $key');
      final List<dynamic> raw = _box.get(key, defaultValue: []);
      final categories = raw
          .map(
              (json) => CategoryModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      logSuccess(
          functionName: functionName,
          message: 'Loaded ${categories.length} categories');
      return categories;
    } catch (e) {
      logError(
          functionName: functionName, message: e.toString(), errorCode: 500);
      return [];
    }
  }

  Map<String, dynamic> loadAllData() {
    final functionName = '$className.loadAllData';
    try {
      logStarting(functionName: functionName, message: 'Loading all Hive data');
      final Map<String, dynamic> allData = {};
      for (var key in _box.keys) {
        final value = _box.get(key);
        allData[key.toString()] = value;
      }
      logSuccess(
          functionName: functionName,
          message: 'Loaded all data with ${_box.keys.length} keys');
      return allData;
    } catch (e) {
      logError(
          functionName: functionName, message: e.toString(), errorCode: 500);
      return {};
    }
  }

  bool containsKey(String key) {
    final functionName = 'containsKey';
    try {
      final result = _box.containsKey(key);
      logInfo(
          functionName: functionName, message: 'Key "$key" exists: $result');
      return result;
    } catch (e) {
      logError(
          functionName: functionName, message: e.toString(), errorCode: 500);
      return false;
    }
  }
}
