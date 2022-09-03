import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/details/widgets/doing_list.dart';
import 'package:todo/app/modules/details/widgets/done_list.dart';

import '../home/controller.dart';

class DetailsPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailsPage({super.key});
  // DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                      },
                    ),
                    const Text('Details'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
                child: Row(
                  children: [
                    Icon(
                      IconData(task.icon, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                    SizedBox(width: 3.0.wp),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  var totalTodos =
                      homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                  return Padding(
                    padding:
                        EdgeInsets.fromLTRB(16.0.wp, 3.0.wp, 16.0.wp, 0.0.wp),
                    child: Row(
                      children: [
                        Text(
                          '$totalTodos Tasks',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 3.0.wp),
                        Expanded(
                          child: StepProgressIndicator(
                            totalSteps: totalTodos == 0 ? 1 : totalTodos,
                            currentStep: homeCtrl.doneTodos.length,
                            size: 5,
                            padding: 0,
                            selectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withOpacity(0.5),
                                color,
                              ],
                            ),
                            unselectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade300,
                              ],
                              ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeCtrl.editCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey.shade400,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          var success = homeCtrl.addTodo(homeCtrl.editCtrl.text);
                          if (success) {
                            EasyLoading.showSuccess('Item added successfully');
                          } else {
                            EasyLoading.showError('Todo item already exists');
                          }
                          homeCtrl.editCtrl.clear();
                        }
                      },
                      icon: const Icon(Icons.done),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
