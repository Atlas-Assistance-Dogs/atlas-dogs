trigger CertificationTrigger on Certification__c(after insert) {
  CertificationService service = new CertificationService();
  if (Trigger.isInsert) {
    for (Certification__c cert : Trigger.new) {
      service.addCeus(cert);
    }
  }
}
