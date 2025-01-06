trigger CeuTrigger on CEU__c (after insert, after update, after delete) {
    CeuService service = new CeuService();
    if (Trigger.isInsert) {
        service.addCeus(Trigger.new);
    }
    else if (Trigger.isUpdate) {
        service.updateCeus(Trigger.new, Trigger.oldMap);
    }
    else {
        service.deleteCeus(Trigger.new);
    }
}