trigger ProgramAssignmentTrigger on ProgramAssignment__c(
    before insert,
    before update
) {
    System.debug(Trigger.new);
    for (ProgramAssignment__c progAssign : Trigger.new) {
        if (progAssign.Program__c == null) {
            continue; // skip any without a program
        }
        Decimal duration = Settings.programDurations.get(progAssign.Program__c);
        if (progAssign.AssignedDate__c == null) {
            progAssign.AssignedDate__c = Date.today();
        }

        if (progAssign.ExpectedCompletion__c == null) {
            progAssign.ExpectedCompletion__c = progAssign.AssignedDate__c.addDays(
                (Integer) (duration * 30)
            );
        }
    }
}
