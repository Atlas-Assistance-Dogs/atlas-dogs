public inherited sharing class CertificationRepository {
    public CertificationRepository() {

    }
    public List<Certification__c> getForContact(Id contactId) {
        return [SELECT Active__c, Contact__c, End__c, Start__c, TotalCeus__c, Type__c FROM Certification__c WHERE Contact__c = :contactId];
    }
    public List<Certification__c> getForContacts(List<Contact> contacts) {
        Set<Id> contactIds = new Set<Id>();
        for (Contact person: contacts) {
            contactIds.add(person.Id);
        }
        return getForContacts(contactIds);
    }
    public List<Certification__c> getForContacts(Set<Id> contactIds) {
        return [SELECT Active__c, Contact__c, End__c, Start__c, TotalCeus__c, Type__c FROM Certification__c WHERE Contact__c IN :contactIds];
    }
    public Certification__c create(Certification__c certs) {
        if (certs == null) return null;
        insert certs;
        return certs;
    }
    public List<Certification__c> create(List<Certification__c> certs) {
        if (certs == null) return null;
        insert certs;
        return certs;
    }
    public List<Certification__c> modify(List<Certification__c> certs) {
        if (certs == null) return null;
        update certs;
        return certs;
    }
    public Certification__c modify(Certification__c certs) {
        if (certs == null) return null;
        update certs;
        return certs;
    }
    public List<CeuCertification__c> create(List<CeuCertification__c> ccs) {
        if (ccs == null) return null;
        insert ccs;
        return ccs;
    }
    public CeuCertification__c get(Id ceuId, Id certificationId) {
        if (ceuId == null || certificationId == null) return null;
        return [SELECT Ceu__c, Certification__c FROM CeuCertification__c WHERE Ceu__c = :ceuId AND Certification__c = :certificationId LIMIT 1];
    }
    public void remove(List<CeuCertification__c> ccs) {
        delete ccs;
    }
    public Certification__c getActiveCert(Id contactId, String type) {
        return [SELECT Id, Contact__c FROM Certification__c WHERE Status__c = 'Active' AND Type__c = :type AND Contact__c = :contactId];
    }
    public Certification__c[] getActiveFacilitatorCerts() {
        return [SELECT Id, Contact__c FROM Certification__c WHERE Status__c = 'Active' AND Type__c = 'Facilitator'];
    }
}