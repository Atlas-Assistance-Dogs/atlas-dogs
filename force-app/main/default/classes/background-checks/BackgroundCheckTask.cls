global class BackgroundCheckTask implements Schedulable {
    BackgroundCheckService service;
    global BackgroundCheckTask() {
        service = new BackgroundCheckService();
    }
    @testVisible
    private BackgroundCheckTask(BackgroundCheckService service) {
        this.service = service;
    }
    
    global void execute(SchedulableContext SC) {
       service.createReminderTask();
    }
}
