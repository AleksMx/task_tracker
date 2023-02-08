import 'package:appflowy_board/appflowy_board.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';
import 'package:task_tracker/dashboard/presentation/widgets/dashboard_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (BuildContext context) => DashboardScreenCubit(),
          child: BlocBuilder<DashboardScreenCubit, DashboardScreenState>(
            builder: (BuildContext context, state) => const DashboardScreenView()
          )
        )
      )
    );
  }
}

class DashboardScreenView extends StatelessWidget {
  const DashboardScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTitleArea(context),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15),
              child: const DashboardWidget()
            )
          )
        ]
      )
    );
  }

  Widget getTitleArea(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('dashboard.title'.tr(), style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800]
        )),
        getSharingButton(context)
      ]
    );
  }

  Widget getSharingButton(BuildContext context) {
    return Material(
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          context.read<DashboardScreenCubit>().downloadReports();
        },
        child: const Icon(CupertinoIcons.cloud_download, color: Colors.blueAccent, size: 30),
      ),
    );
  }
}