import 'package:appflowy_board/appflowy_board.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:task_tracker/dashboard/domain/repositories/reports_repository.dart';
import 'package:task_tracker/utils/utils.dart';

part 'dashboard_screen_state.dart';

class DashboardScreenCubit extends Cubit<DashboardScreenState> {
  late AppFlowyBoardController boardController;
  late AppFlowyBoardScrollController boardScrollController;

  DashboardScreenCubit() : super(DashboardScreenInitial()) {
    boardController = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move item from $fromIndex to $toIndex');
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        debugPrint('Move [$groupId]:$fromIndex to [$groupId]:$toIndex');
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move [$fromGroupId]:$fromIndex to [$toGroupId]:$toIndex');

        AppFlowyGroupController group = boardController.getGroupController(toGroupId)!;
        AppFlowyGroupItem groupItem = group.items[toIndex];
        final textItem = groupItem as TextItem;
        _afterItemMoved(textItem, group);
      },
    );

    boardScrollController = AppFlowyBoardScrollController();

    _loadData();
  }

  void _loadData() async {
    List<DashboardTaskModel>? tasks = await DashboardRepository().getTasks();
    if (tasks == null) {
      Utils.showToast('Network error');
      return;
    }

    _initBoardController(tasks);
  }

  void _initBoardController(List<DashboardTaskModel> tasks) {
    boardController.clear();
    boardController.addGroup(AppFlowyGroupData(
      id: "To Do",
      customData: {
        'state': DashboardTaskState.toDo
      },
      items: getTasksWithState(tasks, DashboardTaskState.toDo),
      name: 'test'
    ));
    boardController.addGroup(AppFlowyGroupData(
      id: "In Progress",
      customData: {
        'state': DashboardTaskState.inProgress
      },
      items: getTasksWithState(tasks, DashboardTaskState.inProgress),
      name: 'test2'
    ));
    boardController.addGroup(AppFlowyGroupData(
      id: "Done",
      customData: {
        'state': DashboardTaskState.done
      },
      items: getTasksWithState(tasks, DashboardTaskState.done),
      name: 'test3'
    ));
  }

  List<AppFlowyGroupItem> getTasksWithState(List<DashboardTaskModel> tasks, DashboardTaskState taskState) {
    List<AppFlowyGroupItem> list = [];
    for (var task in tasks) {
      if (task.state != taskState) {
        continue;
      }
      list.add(TextItem(
        dashboardTask: task
      ));
    }
    return list;
  }

  Future<bool> addTask({
    required String title,
    required DashboardTaskState initState
  }) async {
    bool isOk = await DashboardRepository().addTask(title: title, initState: initState);
    if (!isOk) {
      return false;
    }
    _loadData();
    return true;
  }

  Future<bool> saveTaskWorkTime({
    required DashboardTaskModel dashboardTask,
    required DashboardTaskWorkModel taskWork
  }) async {
    bool isOk = await DashboardRepository().saveTaskWorkTime(
        dashboardTask: dashboardTask,
        taskWork: taskWork
    );
    if (!isOk) {
      return false;
    }
    _loadData();
    return true;
  }

  void _afterItemMoved(TextItem textItem, AppFlowyGroupController group) async {
    DashboardTaskState state = group.groupData.customData['state'] as DashboardTaskState;
    bool isOk = await DashboardRepository().setTaskState(
      taskId: textItem.dashboardTask.id,
      state: state
    );
    if (!isOk) {
      return;
    }
    _loadData();
    return;
  }

  void downloadReports() async {
    ReportsSaveResult? reportsSaveResult = await ReportsRepository().downloadAndSaveReport();
    if (reportsSaveResult == null) {
      Utils.showToast('Can not save report');
      return;
    }

    Utils.showToast('Report saved by path: ${reportsSaveResult.savedPath}');
  }
}

class TextItem extends AppFlowyGroupItem {
  final DashboardTaskModel dashboardTask;

  TextItem({
    required this.dashboardTask
  });

  @override
  String get id => dashboardTask.id.toString();
}