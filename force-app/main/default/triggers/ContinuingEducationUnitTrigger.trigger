trigger ContinuingEducationUnitTrigger on ContinuingEducationUnit__c (before insert) {
    for (ContinuingEducationUnit__c ceu : Trigger.new) {
        if (ceu.Name == null) {
            String authority = ceu.Authority__c;
            if (ceu.Authority__c == 'Other') {
                authority = ceu.AuthorityOther__c;
            }
            ceu.Name = String.format('{0}-{1}', new List<Object> {authority, ceu.ProgramDate__c.format()});
        }
    }
}