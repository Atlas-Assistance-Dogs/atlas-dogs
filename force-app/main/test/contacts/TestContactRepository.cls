@isTest
private class TestContactRepository {
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContacts() {
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    System.assert(result.isEmpty());
  }
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContactsWithVolunteerAccess() {
    Contact bluey = new Contact(
      FirstName = 'Bluey',
      LastName = 'Heeler',
      Email = 'bluey@test.com'
    );
    insert bluey;
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    System.assert(result.isEmpty());
  }
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContactsWithCheckRequired() {
    Contact bluey = new Contact(
      FirstName = 'Bluey',
      LastName = 'Heeler',
      Email = 'bluey@test.com',
      VolunteerAccess__c = 'Active Projects- Academy'
    );
    insert bluey;
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    System.assert(result.isEmpty());
  }
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsCriminal() {
    Contact bluey = new Contact(
      FirstName = 'Bluey',
      LastName = 'Heeler',
      Email = 'bluey@test.com',
      VolunteerAccess__c = 'Background Check Required'
    );
    insert bluey;
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    Contact puppy = result[0];
    System.assertEquals(bluey.Id, puppy.Id);
    System.assertEquals(bluey.VolunteerAccess__c, puppy.VolunteerAccess__c);
  }
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsCredit() {
    Contact bluey = new Contact(
      FirstName = 'Bluey',
      LastName = 'Heeler',
      Email = 'bluey@test.com',
      VolunteerAccess__c = 'Credit Check Required'
    );
    insert bluey;
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    Contact puppy = result[0];
    System.assertEquals(bluey.Id, puppy.Id);
    System.assertEquals(bluey.VolunteerAccess__c, puppy.VolunteerAccess__c);
  }
  @isTest
  static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsBoth() {
    Contact bluey = new Contact(
      FirstName = 'Bluey',
      LastName = 'Heeler',
      Email = 'bluey@test.com',
      VolunteerAccess__c = 'Background Check Required;Credit Check Required'
    );
    insert bluey;
    ContactRepository repo = new ContactRepository();
    Contact[] result = repo.getContactsNeedingBackgroundChecks();
    Contact puppy = result[0];
    System.assertEquals(bluey.Id, puppy.Id);
    System.assert(
      bluey.VolunteerAccess__c.contains('Background Check Required')
    );
    System.assert(bluey.VolunteerAccess__c.contains('Credit Check Required'));
  }
  @isTest
  static void getActiveFacilitators_returnsEmptyList_whenNoContacts() {
    ContactRepository repo = new ContactRepository();
    Set<Id> facilitators = repo.getActiveFacilitators();

    System.assertEquals(new Set<Id>(), facilitators);
  }
  @isTest
  static void getActiveFacilitators_returnsEmptyList_whenNoFacilitators() {
    Contact client = new Contact(
      FirstName = 'Billy',
      LastName = 'Kid',
      Positions__c = 'Client'
    );
    insert client;

    ContactRepository repo = new ContactRepository();
    Set<Id> facilitators = repo.getActiveFacilitators();

    System.assertEquals(new Set<Id>(), facilitators);
  }
  @isTest
  static void getActiveFacilitators_returnsEmptyList_whenFacilitatorNotActive() {
    Contact[] facs = new List<Contact>{
      new Contact(
        FirstName = 'Jack',
        LastName = 'ONeil',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Inactive'
      ),
      new Contact(
        FirstName = 'Sam',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Initial Inquiry'
      ),
      new Contact(
        FirstName = 'Daniel',
        LastName = 'Jackson',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'In Training'
      ),
      new Contact(
        FirstName = 'Tealc',
        LastName = 'Na',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'None'
      ),
      new Contact(
        FirstName = 'Cameron',
        LastName = 'Mitchell',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Onboarding'
      ),
      new Contact(
        FirstName = 'Janet',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Suspended'
      ),
      new Contact(
        FirstName = 'Vala',
        LastName = 'Maldoran',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Discontinued'
      )
    };
    insert facs;

    ContactRepository repo = new ContactRepository();
    Set<Id> facilitators = repo.getActiveFacilitators();

    System.assertEquals(new Set<Id>(), facilitators);
  }
  @isTest
  static void getActiveFacilitators_returnsOnlyActive_whenOtherNotActive() {
    Contact[] facs = new List<Contact>{
      new Contact(
        FirstName = 'Jack',
        LastName = 'ONeil',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Inactive'
      ),
      new Contact(
        FirstName = 'Sam',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Initial Inquiry'
      ),
      new Contact(
        FirstName = 'Daniel',
        LastName = 'Jackson',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'In Training'
      ),
      new Contact(
        FirstName = 'Tealc',
        LastName = 'Na',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Certified-Active'
      ),
      new Contact(
        FirstName = 'Cameron',
        LastName = 'Mitchell',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Onboarding'
      ),
      new Contact(
        FirstName = 'Janet',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Suspended'
      ),
      new Contact(
        FirstName = 'Vala',
        LastName = 'Maldoran',
        Positions__c = 'Team Facilitator',
        FacilitatorStatus__c = 'Discontinued'
      )
    };
    insert facs;

    ContactRepository repo = new ContactRepository();
    Set<Id> facilitators = repo.getActiveFacilitators();

    System.assertEquals(new Set<Id>{ facs[3].id }, facilitators);
  }
  @isTest
  static void getActiveFacilitators_returnsAllActive_whenOtherPositions() {
    Contact[] facs = new List<Contact>{
      new Contact(
        FirstName = 'Jack',
        LastName = 'ONeil',
        Positions__c = 'Team Facilitator;Volunteer',
        FacilitatorStatus__c = 'Inactive'
      ),
      new Contact(
        FirstName = 'Sam',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator;Client',
        FacilitatorStatus__c = 'Initial Inquiry'
      ),
      new Contact(
        FirstName = 'Daniel',
        LastName = 'Jackson',
        Positions__c = 'Team Facilitator;Board Member',
        FacilitatorStatus__c = 'In Training'
      ),
      new Contact(
        FirstName = 'Tealc',
        LastName = 'Na',
        Positions__c = 'Team Facilitator;Trainer',
        FacilitatorStatus__c = 'Certified-Active'
      ),
      new Contact(
        FirstName = 'Cameron',
        LastName = 'Mitchell',
        Positions__c = 'Team Facilitator;Team Facilitator Lead',
        FacilitatorStatus__c = 'Onboarding'
      ),
      new Contact(
        FirstName = 'Janet',
        LastName = 'Carter',
        Positions__c = 'Team Facilitator;Client;Board Member;Volunteer',
        FacilitatorStatus__c = 'Certified-Active'
      ),
      new Contact(
        FirstName = 'Vala',
        LastName = 'Maldoran',
        Positions__c = 'Client',
        FacilitatorStatus__c = 'Discontinued'
      )
    };
    insert facs;

    ContactRepository repo = new ContactRepository();
    Set<Id> facilitators = repo.getActiveFacilitators();

    System.assertEquals(new Set<Id>{ facs[3].id, facs[5].id }, facilitators);
  }

  @isTest
  public static void getPositionStatusForContact_returnsAllStatuses() {
    Contact vala = new Contact(
      FirstName = 'Vala',
      LastName = 'Maldoran',
      Positions__c = 'Team Facilitator;Client;Board Member;Volunteer;Trainer;Staff',
      BoardMemberStatus__c = 'Initial Inquiry',
      ClientCertificationValidUntil__c = Date.today().addMonths(3),
      ClientStatus__c = 'In ADSiM',
      FacilitatorCertAgreementReceived__c = Date.today().addMonths(-3),
      FacilitatorStatus__c = 'Discontinued',
      GW_Volunteers__Volunteer_Status__c = 'Active',
      LeadFacilitatorStatus__c = 'Active',
      PuppyCertAgreementReceived__c = Date.today().addYears(-1),
      PuppyRaiserStatus__c = 'Onboarding',
      StaffStatus__c = 'Employee',
      StandaloneStatus__c = 'In Training',
      TrainerCertAgreementReceived__c = Date.today().addMonths(-1),
      TrainerStatus__c = 'Certified-Active'
    );
    insert vala;

    ContactRepository repo = new ContactRepository();
    Contact actual = repo.getPositionStatusForContact(vala.Id);

    // Assert
    System.assertEquals(vala.Id, actual.Id);
    System.assertEquals(
      new Set<String>(vala.Positions__c.split(';')),
      new Set<String>(actual.Positions__c.split(';'))
    );
    System.assertEquals(vala.BoardMemberStatus__c, actual.BoardMemberStatus__c);
    System.assertEquals(
      vala.ClientCertificationValidUntil__c,
      actual.ClientCertificationValidUntil__c
    );
    System.assertEquals(vala.ClientStatus__c, actual.ClientStatus__c);
    System.assertEquals(
      vala.FacilitatorCertAgreementReceived__c,
      actual.FacilitatorCertAgreementReceived__c
    );
    System.assertEquals(vala.FacilitatorStatus__c, actual.FacilitatorStatus__c);
    System.assertEquals(
      vala.GW_Volunteers__Volunteer_Status__c,
      actual.GW_Volunteers__Volunteer_Status__c
    );
    System.assertEquals(
      vala.LeadFacilitatorStatus__c,
      actual.LeadFacilitatorStatus__c
    );
    System.assertEquals(
      vala.PuppyCertAgreementReceived__c,
      actual.PuppyCertAgreementReceived__c
    );
    System.assertEquals(vala.PuppyRaiserStatus__c, actual.PuppyRaiserStatus__c);
    System.assertEquals(vala.StaffStatus__c, actual.StaffStatus__c);
    System.assertEquals(vala.StaffStatus__c, actual.StaffStatus__c);
    System.assertEquals(
      vala.TrainerCertAgreementReceived__c,
      actual.TrainerCertAgreementReceived__c
    );
    System.assertEquals(vala.TrainerStatus__c, actual.TrainerStatus__c);
  }
}
