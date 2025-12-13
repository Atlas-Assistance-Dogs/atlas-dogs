public inherited sharing class ContactRepository {
  public ContactRepository() {
  }
  public Contact getPositionStatusForContact(Id contactId) {
    return [
      SELECT
        Positions__c,
        BoardMemberStatus__c,
        ClientCertificationValidUntil__c,
        ClientStatus__c,
        FacilitatorCertAgreementReceived__c,
        FacilitatorStatus__c,
        LeadFacilitatorStatus__c,
        PuppyRaiserStatus__c,
        PuppyCertAgreementReceived__c,
        StaffStatus__c,
        StandaloneStatus__c,
        TSiMStatus__c,
        TrainerCertAgreementReceived__c,
        TrainerStatus__c,
        GW_Volunteers__Volunteer_Status__c
      FROM Contact
      WHERE Id = :contactId
    ];
  }

  public Set<Id> getActiveFacilitators() {
    List<Contact> active = [
      SELECT Id
      FROM Contact
      WHERE
        Positions__c INCLUDES ('Team Facilitator')
        AND FacilitatorStatus__c = 'Certified-Active'
    ];

    Set<Id> facilitators = new Set<Id>();
    for (Contact facilitator : active) {
      facilitators.add(facilitator.Id);
    }
    return facilitators;
  }

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

  public Contact[] getContactsNeedingBackgroundChecks() {
    // Check for any contacts that need background checks
    return [
      SELECT Id, Name, VolunteerAccess__c
      FROM Contact
      WHERE
        VolunteerAccess__c INCLUDES (
          'Credit Check Required',
          'Background Check Required'
        )
    ];
  }
}
