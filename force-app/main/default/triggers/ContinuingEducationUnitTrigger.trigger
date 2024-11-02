trigger ContinuingEducationUnitTrigger on CEU__c (after insert, after update) {
    CeuRepository repo = new CeuRepository();

    Set<Id> contactIds = new Set<Id>();
    for (CEU__c ceu : Trigger.new) {
        contactIds.add(ceu.Contact__c);
    }
    // Get the relevant data for these contacts
    List<Contact> contacts = [SELECT CeuHours__c, CeuStatus__c, FacilitatorCertAgreementReceived__c, TrainerCertAgreementReceived__c FROM Contact WHERE Id IN :contactIds];
    // Map the contacts for quick reference below
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    for (Contact trainer : contacts) { // ok, they aren't necessarily trainers
        trainer.CeuHours__c = 0; // reset the CeuHours here
        contactMap.put(trainer.Id, trainer);
    }
    // Get all the approved CEUs for these contacts in the last 365 days
    List<Ceu__c> thisYears = repo.getThisYear(contactIds);
    for (CEU__c ceu : thisYears) {
        Contact trainer = contactMap.get(ceu.Contact__c);
        Date startDate = trainer.FacilitatorCertAgreementReceived__c;
        if (startDate == null) {
            startDate = trainer.TrainerCertAgreementReceived__c;
        }
        if (startDate == null || ceu.DateCompleted__c.daysBetween(startDate) >= 0) {
            trainer.CeuHours__c = trainer.CeuHours__c + ceu.Quantity__c;
            if (trainer.CeuHours__c == 0) {
                trainer.CeuStatus__c = 'Expired';
            }
            else if (trainer.CeuHours__c < 10) {
                trainer.CeuStatus__c = 'In Progress';
            }
            else {
                trainer.CeuStatus__c = 'Current';
            }
        }
    }
}