public with sharing class ContactRepository {
    public ContactRepository() {
        
    }
    public Contact getPositionStatusForContact(
        Id contactId
    ) {
        return [
            SELECT
                Positions__c,
                BoardMemberStatus__c,
                ClientCertificationValidUntil__c,
                ClientStatus__c,
                FacilitatorCertAgreementReceived__c,
                FacilitatorStatus__c,
                PuppyRaiserStatus__c,
                PuppyCertAgreementReceived__c,
                StandaloneStatus__c,
                TrainerCertAgreementReceived__c,
                TrainerStatus__c,
                GW_Volunteers__Volunteer_Status__c
            FROM Contact
            WHERE Id = :contactId
        ];
    }
    
    public Set<Id> getActiveFacilitators() {
        List<Contact> active = [
            SELECT Id FROM Contact
            WHERE Positions__c INCLUDES ('Team Facilitator')
            AND FacilitatorStatus__c = 'Certified-Active'
        ];
        
        Set<Id> facilitators = new Set<Id>();
        for (Contact facilitator : active) {
            facilitators.add(facilitator.Id);
        }
        return facilitators;
    }
}