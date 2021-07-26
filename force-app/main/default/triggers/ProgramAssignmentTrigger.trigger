trigger ProgramAssignmentTrigger on ProgramAssignment__c(
    before insert,
    before update
) {
    System.debug(Trigger.new);
    for (ProgramAssignment__c progAssign : Trigger.new) {
        ProgramDuration__mdt prgDuration = [
            SELECT Months__c
            FROM ProgramDuration__mdt
            WHERE Program__c = :progAssign.Program__c
            LIMIT 1
        ];

        if (progAssign.AssignedDate__c == null) {
            progAssign.AssignedDate__c = Date.today();
        }
        Date reminder;
        if (progAssign.ExpectedCompletion__c == null) {
            if (prgDuration.Months__c < 1) {
                progAssign.ExpectedCompletion__c = progAssign.AssignedDate__c.addDays(
                    (Integer) (prgDuration.Months__c * 30)
                );
                reminder = progAssign.ExpectedCompletion__c.addDays(
                    (Integer) (prgDuration.Months__c * 15)
                );
            } else {
                progAssign.ExpectedCompletion__c = progAssign.AssignedDate__c.addMonths(
                    (Integer) prgDuration.Months__c
                );
                reminder = progAssign.ExpectedCompletion__c.addMonths(-1);
            }
        }
    }
}
