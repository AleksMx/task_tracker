import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardAddTask/ui/dashboard_add_task.dart';

class DashboardWidgetAddTaskButton extends StatelessWidget {
  final DashboardTaskState dashboardTaskState;

  const DashboardWidgetAddTaskButton({
    Key? key,
    required this.dashboardTaskState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 14),
      shadowColor: Colors.transparent
    );

    return ElevatedButton(
      style: style,
      onPressed: () {
        addTaskDialog(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Icon(CupertinoIcons.add),
         Container(
           margin: const EdgeInsets.only(left: 5),
           child: Text('dashboard.addTask'.tr())
         )
        ]
      )
    );
  }

  void addTaskDialog(BuildContext context) async {
    var logic = context.read<DashboardScreenCubit>();

    await showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) => Container(
        width: double.infinity,
        height: 350,
        color: Colors.white,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: DashboardAddTask(
          dashboardScreenCubit: logic,
          dashboardTaskInitState: dashboardTaskState
        )
      )
    );
  }
}