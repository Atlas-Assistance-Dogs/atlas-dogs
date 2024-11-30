global class BackgroundCheckTask implements Schedulable {
    BackgroundCheckService service;
    global BackgroundCheckTask() {
        BackgroundCheckService service = new BackgroundCheckService();
    }
    global void execute(SchedulableContext SC) {
       service.createReminderTask();
    }
}
