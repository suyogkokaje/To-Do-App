import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/task.dart';
import '../../data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editCtrl = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_)=>taskRepository.writeTasks(tasks));
  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();
  }

  void changeDeleting(bool value){
    deleting.value = value;
  }

  void changeTask(Task? select){
    task.value = select;
  }

  void deleteTask(Task task){
    tasks.remove(task);
  }

  updateTask(Task task, String title){
    var todos = task.todos??[];
    if(containTodo(todos,title)){
      return false;
    }
    var todo = {'title':title,'done':false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title){
    return todos.any((e)=>e['title']==title);
  }

  bool addTask(Task task){
    if(tasks.contains(task)){
      return false;
    }
    tasks.add(task);
    return true;
  }
}