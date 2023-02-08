import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';

class DashboardRepository {
  int idCounter = 0;

  static final DashboardRepository _singleton = DashboardRepository._internal();

  factory DashboardRepository() {
    return _singleton;
  }

  Dio? _dio;

  Dio get dio {
    _dio ??= Dio();
    _dio!.options.baseUrl = 'http://77.244.220.94:3000/';
    _dio!.options.connectTimeout = 5000;
    _dio!.options.receiveTimeout = 3000;
    return _dio!;
  }

  DashboardRepository._internal();

  Future<List<DashboardTaskModel>?> getTasks() async {
    Response response = await dio.get('/tasks');
    List<dynamic> tasksData = response.data['tasks'];
    List<DashboardTaskModel> tasks = [];
    for (var task in tasksData) {
      tasks.add(DashboardTaskModel.fromJSON(task));
    }
    return tasks;
  }

  Future<bool> addTask({
    required String title,
    required DashboardTaskState initState
  }) async {
    Response response = await dio.post('/task', data: {
      'title': title,
      'state': initState.toIndex()
    });
    return response.data['success'] ?? false;
  }

  Future<bool> saveTaskWorkTime({
    required DashboardTaskModel dashboardTask,
    required DashboardTaskWorkModel taskWork
  }) async {
    Response response = await dio.post('/addTaskWork', data: {
      'taskId': dashboardTask.id,
      'startTime': taskWork.startTime,
      'endTime': taskWork.endTime
    });
    return response.data['success'] ?? false;
  }

  Future<bool> setTaskState({
    required int taskId,
    required DashboardTaskState state
  }) async {
    Response response = await dio.post('/setTaskState', data: {
      'taskId': taskId,
      'state': state.toIndex()
    });
    return response.data['success'] ?? false;
  }
}