public inherited sharing class CertificationRepository {
    public CertificationRepository() {

    }
    public List<Certification__c> getForContact(Id contactId) {
        return [SELECT Active__c, Contact__c, End__c, Start__c, TotalCeus__c, Type__c FROM Certification__c WHERE Contact__c = :contactId];
    }
}