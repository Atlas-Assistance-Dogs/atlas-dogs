public with sharing class CeuService {
    public CeuService() {

    }

    // add CEUs to the appropriate certifications
    public void addCeus(List<Ceu__c> ceus) {
        List<CeuCertification__c> ccs = new List<CeuCertification__c>();
        Set<Id> contactIds = new Set<Id>();
        for (Ceu__c ceu : ceus) {
            contactIds.add(ceu.Contact__c);
        }

    }

    public void updateCeus(List<Ceu__c> ceus, Map<Id, Ceu__c> old) {

    }
}