trigger ProgramAssignmentTrigger on ProgramAssignment__c(
  before insert,
  before update
) {
  for (ProgramAssignment__c progAssign : Trigger.new) {
    if (progAssign.Program__c == null) {
      continue; // skip any without a program
    }
    Program__c program = [
      SELECT Months__c
      FROM Program__c
      WHERE Id = :progAssign.Program__c
      LIMIT 1
    ];

    if (progAssign.AssignedDate__c == null) {
      progAssign.AssignedDate__c = Date.today();
    }

    if (progAssign.ExpectedCompletion__c == null) {
      progAssign.ExpectedCompletion__c = progAssign.AssignedDate__c.addDays(
        (Integer) (program.Months__c * 30)
      );
    }
  }
}
