import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/utils/utils.dart';

part 'dashboard_view_task_state.dart';

class DashboardViewTaskCubit extends Cubit<DashboardViewTaskState> {
  final DashboardScreenCubit dashboardScreenCubit;
  final DashboardTaskModel dashboardTask;

  bool taskStarted = false;
  int? startTime;

  Timer? _timer;

  DashboardViewTaskCubit({
    required this.dashboardScreenCubit,
    required this.dashboardTask
  }) : super(DashboardViewTaskInitial());

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();
    }

    return super.close();
  }

  void startTask() {
    taskStarted = true;
    startTime = Utils.getTimeMs();

    _timer = Timer.periodic(const Duration(milliseconds: 250), _tickTimer);
    _tickTimer(0);

    emit(DashboardViewTaskInitial());
  }

  String? lastTimeFromStart;
  void _tickTimer(_) {
    String timeFromStart = Utils.formatTimeToFinishEx(getTimeFromStart());
    if (timeFromStart == lastTimeFromStart) {
      return;
    }
    lastTimeFromStart = timeFromStart;
    emit(DashboardViewTaskInitial());
  }

  void stopTask(BuildContext context) {
    _timer!.cancel();
    _timer = null;

    //
    taskStarted = false;
    int endTime = Utils.getTimeMs();
    
    int workTime = endTime - startTime!;
    if (workTime < 1000) {
      Utils.showToast('You\'re too fast');
      emit(DashboardViewTaskInitial());
      return;
    }

    dashboardScreenCubit.saveTaskWorkTime(
      dashboardTask: dashboardTask,
      taskWork: DashboardTaskWorkModel(
        startTime: startTime! ~/ 1000,
        endTime: endTime ~/ 1000
      )
    );

    Navigator.pop(context);
  }

  int getTimeFromStart() {
    return (Utils.getTimeMs() - startTime!) ~/ 1000;
  }
}
