import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/utils/utils.dart';

part 'dashboard_add_task_state.dart';

class DashboardAddTaskCubit extends Cubit<DashboardAddTaskState> {
  final DashboardScreenCubit dashboardScreenCubit;
  final DashboardTaskState dashboardTaskInitState;

  TextEditingController textEditingController = TextEditingController();

  DashboardAddTaskCubit({
    required this.dashboardScreenCubit,
    required this.dashboardTaskInitState
  }) : super(DashboardAddTaskInitial());

  void addTask(BuildContext context) async {
    String title = textEditingController.text.trim();
    if (title.isEmpty) {
      Utils.showToast('Input task name');
      return;
    }

    bool isOk = await dashboardScreenCubit.addTask(title: title, initState: dashboardTaskInitState);
    if (!isOk || isClosed) {
      return;
    }

    Navigator.pop(context);
  }
}
