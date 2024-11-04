public with sharing class ContactRepository {

    public Contact getClientStatus(Id contactId) {
        List<Contact> clients = [
            SELECT
                ClientStatus__c,
                ClientDog__c,
                ClientCertificationValidUntil__c,
                ClientFacilitatorAvailability__c,
                ClientInitialCertificationDate__c
            FROM Contact
            WHERE Id = :contactId
        ];
        if (!clients.isEmpty()) {
            return clients[0];
        }
        return null;
    }

    public Contact modify(Contact cntct) {
        upsert cntct;
        return cntct;
    }
}