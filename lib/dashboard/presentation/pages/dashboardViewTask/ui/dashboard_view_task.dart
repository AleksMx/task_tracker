import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardViewTask/logic/dashboard_view_task_cubit.dart';

import 'dashboard_view_task_playing.dart';
import 'dashboard_view_task_wait.dart';

class DashboardViewTask extends StatelessWidget {
  final DashboardScreenCubit dashboardScreenCubit;
  final DashboardTaskModel dashboardTask;

  const DashboardViewTask({
    Key? key,
    required this.dashboardScreenCubit,
    required this.dashboardTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (BuildContext context) => DashboardViewTaskCubit(
          dashboardScreenCubit: dashboardScreenCubit,
          dashboardTask: dashboardTask
        ),
        child: const DashboardViewTaskView()
      )
    );
  }
}

class DashboardViewTaskView extends StatelessWidget {
  const DashboardViewTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewTaskCubit, DashboardViewTaskState>(
      builder: getContent
    );
  }

  Widget getContent(BuildContext context, state) {
    var logic = context.read<DashboardViewTaskCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(logic.dashboardTask.title, style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent
          )),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: getControlArea(context)
            )
          )
        ]
      )
    );
  }

  Widget getControlArea(BuildContext context) {
    var logic = context.read<DashboardViewTaskCubit>();
    if (logic.taskStarted) {
      return DashboardViewTaskPlaying();
    }

    return const DashboardViewTaskWait();
  }
}