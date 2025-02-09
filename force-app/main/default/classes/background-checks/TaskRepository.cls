public with sharing class TaskRepository {
  public TaskRepository() {
  }
  public Task[] create(Task[] tasks) {
    insert tasks;
    return tasks;
  }
}
