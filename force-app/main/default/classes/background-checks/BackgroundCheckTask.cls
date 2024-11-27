global class BackgroundCheckTask implements Schedulable {
    global void execute(SchedulableContext SC) {
        BackgroundCheckService service = new BackgroundCheckService();
        service.createReminderTask();
    }
}
