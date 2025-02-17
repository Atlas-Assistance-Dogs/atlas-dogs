trigger CeuTrigger on CEU__c (after insert, after update) {
    CertificationService service = new CertificationService();
    if (Trigger.isInsert) {
        service.addCeus(Trigger.new);
    }
    else {
        service.updateCeus(Trigger.new, Trigger.oldMap);
    }
}