public
inherited sharing class ContactService {
private
  ContactRepository contactRepo;
private
  RelationshipRepository relationshipRepo;
private
  EmailService emailServ;
  private CertificationService certService;
public
  ContactService() {
    contactRepo = new ContactRepository();
    relationshipRepo = new RelationshipRepository();
    emailServ = new EmailService();
    certService = new CertificationService();
  }

  @TestVisible private ContactService(ContactRepository contactRepo,
                                      RelationshipRepository relationshipRepo,
                                      EmailService emailServ,
                                      CertificationService certRService) {
    this.contactRepo = contactRepo;
    this.relationshipRepo = relationshipRepo;
    this.emailServ = emailServ;
    this.certService = certService;
  }

  // This copies the contact email and phone to the ContactAt email & phone,
  // as long as the Email and Phone are not blank and ContactAt is Home or
  // Alternate
public
  Contact updateContactAtEmail(Contact newContact) {
    string contact = newContact.Contact__c;
    if (contact == 'Home' && !string.isBlank(newContact.Email)) {
      newContact.npe01__HomeEmail__c = newContact.Email;
    } else if (contact == 'Alternate' && !string.isBlank(newContact.Email)) {
      newContact.npe01__AlternateEmail__c = newContact.Email;
    }
    return newContact;
  }

public
  Contact updateContactAtPhone(Contact newContact) {
    string contact = newContact.Contact__c;
    if (contact == 'Home' && !string.isBlank(newContact.Phone)) {
      newContact.HomePhone = newContact.Phone;
    } else if (contact == 'Alternate' && !string.isBlank(newContact.Phone)) {
      newContact.OtherPhone = newContact.Phone;
    }
    return newContact;
  }

  // Update email based on the ContactAt value
public
  Contact updateEmail(Contact newContact) {
    string contact = newContact.Contact__c;
    if (contact == 'Home') {
      if (!string.isBlank(newContact.npe01__HomeEmail__c)) {
        newContact.Email = newContact.npe01__HomeEmail__c;
      }
    } else if (contact == 'Alternate') {
      if (!string.isBlank(newContact.npe01__AlternateEmail__c)) {
        newContact.Email = newContact.npe01__AlternateEmail__c;
      }
    } else {
      // see if the type matches a relationship type
      List<npe4__Relationship__c> related =
          relationshipRepo.getCurrentRelated(newContact.Id, contact);
      if (!related.isEmpty()) {
        // use the first Contact that matches
        Contact person = related[0].npe4__RelatedContact__r;
        if (!string.isBlank(person.Email)) {
          newContact.Email = person.Email;
        }
      }
    }
    return newContact;
  }

  // Update the Contact's phone based on the current value from ContactAt
public
  Contact updatePhone(Contact newContact) {
    string contact = newContact.Contact__c;
    if (contact == 'Home') {
      if (!string.isBlank(newContact.HomePhone)) {
        newContact.Phone = newContact.HomePhone;
      }
    } else if (contact == 'Alternate') {
      if (!string.isBlank(newContact.OtherPhone)) {
        newContact.Phone = newContact.OtherPhone;
      }
    } else {
      // see if the type matches a relationship type
      List<npe4__Relationship__c> related =
          relationshipRepo.getCurrentRelated(newContact.Id, contact);
      if (!related.isEmpty()) {
        // use the first Contact that matches
        Contact person = related[0].npe4__RelatedContact__r;
        if (!string.isBlank(person.Phone)) {
          newContact.Phone = person.Phone;
        }
      }
    }
    return newContact;
  }

  // Update the email of a related contact
public
  void updateRelatedContactEmailPhone(Contact current, Boolean changedEmail,
                                      Boolean changedPhone) {
    List<npe4__Relationship__c> related =
        relationshipRepo.getCurrentRelated(current.Id);

    if (!related.isEmpty()) {
      List<Contact> contacts = new List<Contact>();
      for (npe4__Relationship__c relationship : related) {
        if (relationship.npe4__Contact__r.Contact__c ==
            relationship.npe4__Type__c) {
          if (changedEmail) {
            relationship.npe4__Contact__r.Email = current.Email;
          }
          if (changedPhone) {
            relationship.npe4__Contact__r.Phone = current.Phone;
          }
          contacts.add(relationship.npe4__Contact__r);
        }
      }
      update contacts;
    }
  }

  // Share the contact with the appropriate groups based on which positions they
  // have, and the positions they are emergency contacts for
public
  static Contact
  shareContactBasedOnPositions(Contact person,
                               Map<String, String> positionGroups) {
    // Create a set of the positions the user currently has
    Set<String> positions = new Set<String>();
    if (!String.isBlank(person.Positions__c)) {
      positions.addAll(person.Positions__c.split(';'));
    }
    Set<String> groups = new Set<String>();
    for (String position : positions) {
      String grp = positionGroups.get(position);
      if (grp != null) {
        groups.add(grp);
      }
    }

    // update this contact first, then its relations
    person = shareContactWithGroups(person, groups);
    return person;
  }

  // Get the positions of the contact relations
private
  Set<String> getRelationShipPositions(Contact record) {
    // Find who the contact is related to as an emergency contact
    npe4__Relationship__c[] related =
        relationshipRepo.getSharingPositions(record.Id);
    Set<String> positions = new Set<String>();
    if (!String.isBlank(record.Positions__c)) {
      positions.addAll(record.Positions__c.split(';'));
    }
    for (npe4__Relationship__c relation : related) {
      if (String.isBlank(relation.npe4__Contact__r.Positions__c)) {
        continue;
      }
      String[] pos = relation.npe4__Contact__r.Positions__c.split(';');
      positions.addAll(pos);
    }
    return positions;
  }

  // Get the groups that the category rules assign for the positions
public
  Map<String, String> getGroupsByPositions() {
    // Get the groups that can see each position
    List<CategoryRule__c> rules = [
      SELECT GroupName__c, Position__c FROM CategoryRule__c WHERE Position__c !=
      NULL
    ];
    Map<String, String> groupNames = new Map<String, String>();
    for (CategoryRule__c rule : rules) {
      groupNames.put(rule.Position__c, rule.GroupName__c);
    }
    return groupNames;
  }

private
  static Contact shareContactWithGroups(Contact contact,
                                        Set<String> groupNames) {
    contact.ShareBoard__c = groupNames.contains('Board');
    contact.SharePuppyRaiser__c = groupNames.contains('Puppy Raiser');
    contact.ShareStaff__c = groupNames.contains('Staff');
    contact.ShareStandalonePrograms__c =
        groupNames.contains('Standalone Programs');
    contact.ShareTeam__c = groupNames.contains('Team');
    contact.ShareTrainer__c = groupNames.contains('Trainer');
    contact.ShareVolunteer__c = groupNames.contains('Volunteer');
    return contact;
  }

public
  static void setSharingFields() {
    List<Contact> contacts = [
      SELECT IsBoardMember__c, IsClient__c, IsPuppyRaiser__c, IsStaff__c,
      IsStandalone__c, IsTeamFacilitator__c, IsTrainer__c, IsVolunteer__c,
      ShareBoard__c, SharePuppyRaiser__c, ShareStaff__c,
      ShareStandalonePrograms__c, ShareTeam__c, ShareTrainer__c,
      ShareVolunteer__c FROM Contact WHERE IsBoardMember__c =
          TRUE OR IsClient__c = TRUE OR IsPuppyRaiser__c = TRUE OR IsStaff__c =
              TRUE OR IsStandalone__c = TRUE OR IsTeamFacilitator__c =
                  TRUE OR IsTrainer__c = TRUE OR IsVolunteer__c = TRUE
    ];

    Map<Id, Contact> contactMap = new Map<Id, Contact>();

    for (Contact person : contacts) {
      person.ShareBoard__c = person.IsBoardMember__c;
      person.SharePuppyRaiser__c = person.IsPuppyRaiser__c;
      person.ShareStaff__c = person.IsStaff__c;
      person.ShareStandalonePrograms__c = person.IsStandalone__c;
      person.ShareTeam__c = person.IsClient__c || person.IsTeamFacilitator__c;
      person.ShareTrainer__c = person.IsTrainer__c;
      person.ShareVolunteer__c = person.IsVolunteer__c;
      contactMap.put(person.Id, person);
    }

    // Get related contacts
    npe4__Relationship__c[] related =
        [ SELECT Id, npe4__RelatedContact__c,
          npe4__RelatedContact__r.Positions__c,
          npe4__RelatedContact__r.ShareBoard__c,
          npe4__RelatedContact__r.SharePuppyRaiser__c,
          npe4__RelatedContact__r.ShareStaff__c,
          npe4__RelatedContact__r.ShareStandalonePrograms__c,
          npe4__RelatedContact__r.ShareTeam__c,
          npe4__RelatedContact__r.ShareTrainer__c,
          npe4__RelatedContact__r.ShareVolunteer__c,
          npe4__Contact__c FROM npe4__Relationship__c WHERE(
              npe4__Type__c LIKE '%Emergency Contact' OR npe4__Type__c =
                  'Guardian') AND npe4__Status__c =
              'Current' AND npe4__Contact__c IN:contactMap.keySet() ];
    for (npe4__Relationship__c relation : related) {
      Contact shared = contactMap.get(relation.npe4__Contact__c);
      Contact share = contactMap.get(relation.npe4__RelatedContact__c);
      if (share == null) {
        share = relation.npe4__RelatedContact__r;
      }
      share.ShareBoard__c = share.ShareBoard__c || shared.ShareBoard__c;
      share.SharePuppyRaiser__c =
          share.SharePuppyRaiser__c || shared.SharePuppyRaiser__c;
      share.ShareStaff__c = share.ShareStaff__c || share.ShareStaff__c;
      share.ShareStandalonePrograms__c =
          share.ShareStandalonePrograms__c || shared.ShareStandalonePrograms__c;
      share.ShareTeam__c = share.ShareTeam__c || shared.ShareTeam__c;
      share.ShareTrainer__c = share.ShareTrainer__c || shared.ShareTrainer__c;
      share.ShareVolunteer__c =
          share.ShareVolunteer__c || shared.ShareVolunteer__c;
      if (!contactMap.containsKey(relation.npe4__RelatedContact__c)) {
        contactMap.put(relation.npe4__RelatedContact__c, share);
      }
    }
    update contactMap.values();
  }

public
  static void setBoardTermValidUntil(Contact newContact, Date oldBoardDate) {
    if (newContact.LastBoardTermStartDate__c != null &&
        newContact.LastBoardTermStartDate__c != oldBoardDate) {
      AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
      // check to see if settings are missing
      if (settings.BoardTermEndMonth__c == null) {
        // TODO: get default value
        settings.BoardTermEndMonth__c = 4;
        upsert settings;
      }
      Integer endMonth = (Integer)settings.BoardTermEndMonth__c;
      integer month = newContact.LastBoardTermStartDate__c.month();
      Date minTerm = newContact.LastBoardTermStartDate__c.addYears(3);
      integer months = 0;
      if (month < endMonth) {
        months = endMonth - month;
      } else if (month > endMonth && endMonth > 0) {
        months = 12 + endMonth - month;
      }
      // We want to wind up at the last day of June in the year following 3
      // years of service. So, months + 1 takes us to July, toStartOfMonth()
      // takes us to July 1, and subtracting a day takes us to June 30.
      newContact.BoardTermValidUntil__c =
          minTerm.addMonths(months + 1).toStartOfMonth().addDays(-1);
    }
  }

public
  static void updateFirstAidValidUntil(Contact newContact,
                                       Date oldFirstAidDate) {
    if (newContact.FirstAidReceived__c == null) {
      newContact.FirstAidValidUntil__c = null;
      return;
    }
    if (newContact.FirstAidReceived__c != null &&
        newContact.FirstAidReceived__c != oldFirstAidDate) {
      AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
      // check to see if settings are missing
      if (settings.FirstAidRenewalYears__c == null) {
        // TODO: get default value
        settings.FirstAidRenewalYears__c = 2;
        upsert settings;
      }
      newContact.FirstAidValidUntil__c =
          newContact.FirstAidReceived__c.addYears(
              (integer)settings.FirstAidRenewalYears__c);
    }
  }

public
  void updateCertValidUntil(Contact person, Contact last) {
    Certification__c cert;

    if (person.IsTrainer__c && person.TrainerCertAgreementReceived__c != null &&
        person.TrainerCertAgreementReceived__c !=
            last.TrainerCertAgreementReceived__c) {
      cert = certService.updateCert(person, 'Trainer', person.TrainerCertValidUntil__c,
                        person.TrainerCertAgreementReceived__c);
      if (cert != null) {
        if (person.TrainerInitialCertificationDate__c == null) {
          person.TrainerInitialCertificationDate__c = cert.Start__c;
        }
        person.TrainerCertValidUntil__c = cert.End__c;
      }
    }

    if (person.IsTeamFacilitator__c &&
        person.FacilitatorCertAgreementReceived__c != null &&
        person.FacilitatorCertAgreementReceived__c !=
            last.FacilitatorCertAgreementReceived__c) {
      cert = certService.updateCert(
          person, 'Facilitator', person.FacilitatorCertValidUntil__c,
          person.FacilitatorCertAgreementReceived__c);
      if (cert != null) {
        if (person.FacilitatorInitialCertificationDate__c == null) {
          person.FacilitatorInitialCertificationDate__c = cert.Start__c;
        }
        person.FacilitatorCertValidUntil__c = cert.End__c;
      }
    }
  }

public
  List<PositionStatus> getPositionStatusForContact(Id contactId) {
    Contact person = contactRepo.getPositionStatusForContact(contactId);
    List<PositionStatus> statuses = getStatusForPositions(person);
    return statuses;
  }

  // We want the position status to be in this order, the Positions set for the
  // contact may not be in this order
public
  final static String[] POSITION_LIST = new List<string>{
      'Volunteer', 'Team Facilitator', 'Puppy Raiser', 'Board',
      'Client',    'Trainer',          'Standalone',   'Staff'};

private
  List<PositionStatus> getStatusForPositions(Contact person) {
    List<PositionStatus> statuses = new List<PositionStatus>();
    if (person.Positions__c == null) {
      return statuses;
    }
    Set<String> positions = new Set<string>(person.Positions__c.split(';'));
    for (string position : POSITION_LIST) {
      switch
        on(position) {
          when 'Volunteer' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields
                    .GW_Volunteers__Volunteer_Status__c.isAccessible()) {
              statuses.add(new PositionStatus(
                  position, person.GW_Volunteers__Volunteer_Status__c));
            }
          }
          when 'Team Facilitator' {
            if ((positions.contains(position) ||
                 positions.contains('Team Facilitator Lead')) &&
                Schema.sObjectType.Contact.fields.FacilitatorStatus__c
                    .isAccessible() &&
                Schema.sObjectType.Contact.fields
                    .FacilitatorCertAgreementReceived__c.isAccessible()) {
              string status =
                  fineTuneStatus(person.FacilitatorStatus__c,
                                 person.FacilitatorCertAgreementReceived__c);
              statuses.add(new PositionStatus(position, status));
            }
          }
          when 'Puppy Raiser' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields.PuppyRaiserStatus__c
                    .isAccessible()) {
              string status =
                  fineTuneStatus(person.PuppyRaiserStatus__c,
                                 person.PuppyCertAgreementReceived__c);
              statuses.add(new PositionStatus(position, status));
            }
          }
          when 'Board' {
            if (positions.contains('Board Member') &&
                Schema.sObjectType.Contact.fields.BoardMemberStatus__c
                    .isAccessible()) {
              statuses.add(
                  new PositionStatus(position, person.BoardMemberStatus__c));
            }
          }
          when 'Client' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields.ClientStatus__c
                    .isAccessible() &&
                Schema.sObjectType.Contact.fields
                    .ClientCertificationValidUntil__c.isAccessible()) {
              Date certDate = null;
              if (person.ClientCertificationValidUntil__c != null) {
                certDate =
                    person.ClientCertificationValidUntil__c.addDays(-365);
              }
              string status = fineTuneStatus(person.ClientStatus__c, certDate);
              statuses.add(new PositionStatus(position, status));
            }
          }
          when 'Trainer' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields.TrainerStatus__c
                    .isAccessible() &&
                Schema.sObjectType.Contact.fields
                    .TrainerCertAgreementReceived__c.isAccessible()) {
              string status =
                  fineTuneStatus(person.TrainerStatus__c,
                                 person.TrainerCertAgreementReceived__c);
              statuses.add(new PositionStatus(position, status));
            }
          }
          when 'Standalone' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields.StandaloneStatus__c
                    .isAccessible()) {
              statuses.add(
                  new PositionStatus(position, person.StandaloneStatus__c));
            }
          }
          when 'Staff' {
            if (positions.contains(position) &&
                Schema.sObjectType.Contact.fields.StaffStatus__c
                    .isAccessible()) {
              String status = person.StaffStatus__c;
              if (status == 'Employee' || status == 'Contractor') {
                status = 'Active';
              }
              statuses.add(new PositionStatus(position, status));
            }
          }
        }
    }
    return statuses;
  }

private
  static string fineTuneStatus(string status, Date certDate) {
    Date today = Date.today();
    if (status == 'Active' || (status == 'Certified' && certDate != null)) {
      if (certDate.addDays(365) < today) {
        status = 'Action Needed';
      } else if (certDate.addDays(270) < today) {
        status = 'Action Needed Soon';
      }
    }
    return status;
  }
  /*
  public
    void updateCertifications(List<Contact> contacts, Map<Id, Contact> old) {
      List<Certification__c> currentCerts = certRepo.getForContacts(contacts);
      Map<Id, List<Certification__c>> contactCerts =
          CertificationService.sortCertifications(currentCerts);
      List<Certification__c> newCerts = new List<Certification__c>();
      List<Certification__c> updateCerts = new List<Certification__c>();
      for (Contact person : contacts) {
        Contact previous = old.get(person.Id);

        if (person.TrainerCertValidUntil__c !=
            previous.TrainerCertValidUntil__c) {
          // create a certification
          newCerts.add(new Certification__c(
              Contact__c = person.Id, End__c = person.TrainerCertValidUntil__c,
              Start__c = person.TrainerCertValidUntil__c.addYears(-1),
              Type__c = 'Trainer'));
        }

        if (person.FacilitatorCertValidUntil__c !=
            previous.FacilitatorCertValidUntil__c) {
          // create a certification
          newCerts.add(new Certification__c(
              Contact__c = person.Id,
              End__c = person.FacilitatorCertValidUntil__c,
              Start__c = person.FacilitatorCertValidUntil__c.addYears(-1),
              Type__c = 'Facilitator'));
        }
      }
      certRepo.create(newCerts);
    }*/
}
