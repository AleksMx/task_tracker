import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardAddTask/logic/dashboard_add_task_cubit.dart';


class DashboardAddTask extends StatelessWidget {
  final DashboardScreenCubit dashboardScreenCubit;
  final DashboardTaskState dashboardTaskInitState;

  const DashboardAddTask({
    Key? key,
    required this.dashboardScreenCubit,
    required this.dashboardTaskInitState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (BuildContext context) => DashboardAddTaskCubit(
          dashboardScreenCubit: dashboardScreenCubit,
          dashboardTaskInitState: dashboardTaskInitState
        ),
        child: const DashboardAddTaskView()
      )
    );
  }
}

class DashboardAddTaskView extends StatelessWidget {
  const DashboardAddTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardAddTaskCubit, DashboardAddTaskState>(
      builder: getContent
    );
  }

  Widget getContent(BuildContext context, state) {
    var logic = context.read<DashboardAddTaskCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Task', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent
          )),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Text('Name', style: TextStyle(color: Colors.grey[800], fontSize: 15))
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: CupertinoTextField(
              controller: logic.textEditingController,
              placeholder: 'Please enter task name',
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
            )
          ),
          Expanded(child: Container()),
          Container(
            child: getAddButton(context)
          )
        ]
      )
    );
  }

  Widget getAddButton(BuildContext context) {
    var logic = context.read<DashboardAddTaskCubit>();

    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15));

    return ElevatedButton(
      style: style,
      onPressed: () {
        logic.addTask(context);
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
}