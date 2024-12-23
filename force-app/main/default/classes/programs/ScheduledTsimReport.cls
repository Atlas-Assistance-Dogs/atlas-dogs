global class ScheduledTsimReport implements Schedulable {
  global void execute(SchedulableContext SC) {
    RelatedObjects report = ProgramAssignmentController.getReport(
      'Teams Set in Motion Client'
    );
    ReportService.createPaCsvReport(
      report,
      String.format('TSiM {0}', new List<Object>{ Datetime.now() })
    );
  }
}
