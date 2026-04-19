import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';

import 'package:mayekawa/config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> importCsvToDatabase() async {
  final databaseHelper = DatabaseHelper.instance;

  // === 获取 Documents 路径
  final directory = await getApplicationSupportDirectory();
  final csvFilePath = '${directory.path}/customers.csv';

  // === 从后端拉取最新的customers数据
  print("Fetching latest customer data from backend...");

  const String apiUrl = "${Config.apiBaseUrl}/get-customers";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    //转为csv格式
    List<List<dynamic>> csvRows = [
      ['id', 'code', 'name', 'address'],
      ...jsonData.map((item) => [
            item['id'],
            item['code'],
            item['name'] ?? '',
            item['address'] ?? '',
          ]),
    ];

    final csvString = const ListToCsvConverter().convert(csvRows);

    // 保存为csv文件
    final file = File(csvFilePath);
    await file.writeAsString(csvString);
    print("Customer CSV updated locally at $csvFilePath");
  } else {
    print("Failed to fetch customer data from backend");
    return;
  }

  //检查是否已经导入过数据
  final existingData = await databaseHelper.getAllCustomers();
  if (existingData.isNotEmpty) {
    // 清空customer表格数据
    await databaseHelper.deleteAllCustomers();
    print("Previous customer-data deleted successfully.");
  }

  final existingData2 = await databaseHelper.getAllModels();
  if (existingData2.isNotEmpty) {
    // 清空model表格数据
    await databaseHelper.deleteAllModels();
    print("Previous model-data deleted successfully.");
  }

  //读取CSV---Customer
  print("Starting customer CSV import...");

  final csvData = await File(csvFilePath).readAsString();

  //解析CSV数据
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  //忽略第一行表头，构造map列表
  List<Map<String, dynamic>> customers = rows.skip(1).map((row) {
    return {
      "id": row[0],
      "code": row[1],
      "name": row[2] ?? '',
      "address": row[3] ?? '',
    };
  }).toList();

  //插入数据库
  await databaseHelper.insertCustomers(customers);

  //读取CSV---Model
  print("Starting model CSV import...");
  final csvData2 =
      await rootBundle.loadString("assets/models.csv", cache: false);

  //解析CSV数据
  List<List<dynamic>> modelRows = const CsvToListConverter().convert(csvData2);

  //忽略第一行表头，构造map列表
  List<Map<String, dynamic>> models = modelRows.skip(1).map((modelRow) {
    return {
      "id": modelRow[0],
      "model": modelRow[1],
    };
  }).toList();

  //插入数据库
  await databaseHelper.insertModels(models);

  print("CSV import completed successfully");
}
