import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';

import '../../../data/models/task.dart';
import '../../home/controller.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final Task task;
  DoingList({Key? key, required this.task}) : super(key: key);
  // DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(task.color);
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doingTodos.isEmpty
          ? Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.wp),
                    child: Text(
                      'Nothing to do!',
                      style: TextStyle(
                        fontSize: 40.0.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doingTodos.map((e) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 3.0.wp, horizontal: 9.0.wp),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            fillColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey),
                            value: e['done'],
                            onChanged: (value) {
                              homeCtrl.doneTodo(e['title']);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                          child: Text(
                            e['title'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(
                      thickness: 2,
                    ),
                  )
              ],
            ),
    );
  }
}
