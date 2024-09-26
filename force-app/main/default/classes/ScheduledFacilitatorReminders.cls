global class ScheduledFacilitatorReminders implements Schedulable {
    global void execute(SchedulableContext SC) {
        TeamRepository  teamRepo = new TeamRepository();
        LogRepository logRepo = new LogRepository();
        RelationshipRepository relationshipRepo = new RelationshipRepository();
        EmailService emailSrv = new EmailService();
        TeamService service = new TeamService(teamRepo, logRepo, relationshipRepo, emailSrv);

        service.remindFacilitators();
    }
}
