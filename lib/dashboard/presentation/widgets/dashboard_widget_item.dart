import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardViewTask/ui/dashboard_view_task.dart';
import 'package:task_tracker/utils/utils.dart';

class DashboardWidgetItem extends StatelessWidget {
  final TextItem textItem;

  const DashboardWidgetItem({Key? key, required this.textItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewTaskDialog(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.drag_indicator, size: 20, color: Colors.blueAccent),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 3),
                child: Text(textItem.dashboardTask.title, style: TextStyle(color: Colors.blue[800]))
              )
            )
          ]
        )
      ),
    );
  }

  void viewTaskDialog(BuildContext context) async {
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
        child: DashboardViewTask(
          dashboardScreenCubit: logic,
          dashboardTask: textItem.dashboardTask
        )
      )
    );
  }
}