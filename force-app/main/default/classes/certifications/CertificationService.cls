public inherited sharing class CertificationService {
  private CertificationRepository certRepo;
  private CeuRepository ceuRepo;
  private EmailService emailServ;

  public CertificationService() {
    certRepo = new CertificationRepository();
    ceuRepo = new CeuRepository();
    emailServ = new EmailService();
  }

  @TestVisible
  private CertificationService(CertificationRepository certRepo, EmailService emailServ, CeuRepository ceuRepo) {
    this.certRepo = certRepo;
    this.emailServ = emailServ;
    this.ceuRepo = ceuRepo;
  }

  // Create a map of CEUs by ContactId, with each contact id
  // having a list of the CEUs.
  // This method is used when gathering CEUs for a list of contacts.
  public Map<Id, List<Ceu__c>> sortCeus(List<Ceu__c> ceus) {
    Map<Id, List<Ceu__c>> contactCeuIds = new Map<Id, List<Ceu__c>>();
    for (Ceu__c ceu : ceus) {
      if (contactCeuIds.containsKey(ceu.Contact__c)) {
        List<Ceu__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
        contactCeus.add(ceu);
      } else {
        contactCeuIds.put(ceu.Contact__c, new List<Ceu__c>{ ceu });
      }
    }
    return contactCeuIds;
  }

  // Create a map of Certifications by ContactId, with each contact id
  // having a list of the Certifications.
  // This method is used when gathering Certifications for a list of contacts.
  public Map<Id, List<Certification__c>> sortCertifications(List<Certification__c> certs) {
    Map<Id, List<Certification__c>> contactCertIds = new Map<Id, List<Certification__c>>();
    for (Certification__c cert : certs) {
      if (contactCertIds.containsKey(cert.Contact__c)) {
        List<Certification__c> contactCerts = contactCertIds.get(cert.Contact__c);
        contactCerts.add(cert);
      } else {
        contactCertIds.put(cert.Contact__c, new List<Certification__c>{ cert });
      }
    }
    return contactCertIds;
  }

  // add CEUs to the appropriate certifications
  public void addCeus(List<Ceu__c> ceus) {
    Map<Id, List<Ceu__c>> contactCeuIds = sortCeus(ceus);
    List<Certification__c> certs = certRepo.getForContacts(contactCeuIds.keySet());
    List<CeuCertification__c> ccs = new List<CeuCertification__c>();
    for (Certification__c cert : certs) {
      List<Ceu__c> contactCeus = contactCeuIds.get(cert.Contact__c);
      for (Ceu__c ceu1 : contactCeus) {
        if (cert.Status__c == 'Active' && ceu1.DateCompleted__c >= cert.Start__c && ceu1.DateCompleted__c <= cert.End__c && certRepo.ceuNotAssignedToCert(ceu1.Id, cert.Type__c)) {
          CeuCertification__c cc = new CeuCertification__c(
            Ceu__c = ceu1.Id, 
            Certification__c = cert.Id
          );
          if (ceu1.Status__c == 'Approved') {
            cc.Approved__c = ceu1.Quantity__c;
          }
          ccs.add(cc);
        }
      }
    }
    certRepo.create(ccs);
  }

  // Since there is a rollup summary on Approved, check that it is set properly
  public void updateCeus(List<Ceu__c> ceus) {
    List<CeuCertification__c> ccs = certRepo.getCeuCerts(ceus);
    List<CeuCertification__c> goodConnections = new List<CeuCertification__c>();
    List<CeuCertification__c> badConnections = new List<CeuCertification__c>();
    Set<Id> contactIds = new Set<Id>();

    for (CeuCertification__c cc : ccs) {
      if (cc.Ceu__r.Status__c == 'Approved') {
        cc.Approved__c = cc.Ceu__r.Quantity__c;
      } else {
        cc.Approved__c = 0;
      }
      if (cc.Ceu__r.DateCompleted__c >= cc.Certification__r.Start__c && cc.Ceu__r.DateCompleted__c <= cc.Certification__r.End__c) {
        goodConnections.add(cc);
      } else {
        badConnections.add(cc);
        contactIds.add(cc.Ceu__r.Contact__c);
      }
    }
    // note that the CeuCertifications in badConnections are references,
    // so correcting them here also corrects them in the ccs list.
    if (!badConnections.isEmpty()) {
      goodConnections.addAll(correctConnections(badConnections, contactIds));
    }

    // Now use the repo to flag CEUs that are tied to the wrong Certification
    certRepo.modify(goodConnections);
  }

  // note that the CeuCertifications in badConnections are references,
  // so correcting them here also corrects them in the ccs list.
  private List<CeuCertification__c> correctConnections(List<CeuCertification__c> badConnections, Set<Id> contactIds) {
    List<CeuCertification__c> loose = new List<CeuCertification__c>();
    List<CeuCertification__c> corrected = new List<CeuCertification__c>();
    List<Certification__c> certs = certRepo.getForContacts(contactIds);
    for (CeuCertification__c cc : badConnections) {
      Ceu__c ceu1 = cc.Ceu__r;
      for (Certification__c cert : certs) {
        if (ceu1.Contact__c == cert.Contact__c && ceu1.DateCompleted__c >= cert.Start__c && ceu1.DateCompleted__c <= cert.End__c) {
          cc.Certification__c = cert.Id;
          corrected.add(cc);
        } else {
          loose.add(cc);
        }
      }
    }
    if (!loose.isEmpty()) {
      certRepo.remove(loose);
    }
    return corrected;
  }

  private inherited sharing class Dates {
    public Integer years { get; set; }

    public Integer early { get; set; }

    public Integer leeway { get; set; }

    public Dates() {
      // check to see if settings are missing
      Boolean updateSettings = false;
      AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
      if (settings.CertRenewalYears__c == null) {
        // TODO: get default value
        settings.CertRenewalYears__c = 1;
        updateSettings = true;
      }
      if (settings.EarlyRenewal__c == null) {
        // TODO: get default value
        settings.EarlyRenewal__c = 90;
        updateSettings = true;
      }
      if (settings.RenewalLeeway__c == null) {
        // TODO: get default value
        settings.RenewalLeeway__c = 30;
        updateSettings = true;
      }
      if (updateSettings) {
        upsert settings;
      }
      this.years = (Integer) settings.CertRenewalYears__c;
      this.early = (Integer) settings.EarlyRenewal__c;
      this.leeway = (Integer) settings.RenewalLeeway__c;
    }

  }

  /* This is called when a Trainer or Facilitator contact is updated.
   * If the contact has an initial certification date but not a valid until date:
   *   Creates a new certification off the initial certification and exit.
   * If the contact has a certification agreement but no initial certification and no valid until:
   *   Create a new certification off the agreement and exit.
   * It update the current certification (if there is an active one, otherwise it creates a cert for the just-completed period).
   *   If the new certDate is within the leeway period, it completes the old cert and creates a new one starting when the old ends.
   *   If the new certDate is after the leeway, it completes the old cert and creates a new one starting on the certDate
   *   If the new certDate is somewhere else, it leaves the current cert in effect.
   */
  public Certification__c updateCert(Id contactId, String type, Date initial, Date validUntil, Date certDate) {
    // date the latest agreement was received
    Dates dates = new Dates();
    Certification__c cert;
    if (initial != null && validUntil == null) {
      // create cert and exit
      cert = certRepo.create(new Certification__c(
        Contact__c = contactId, 
        Type__c = type, 
        Status__c = 'Active', 
        Start__c = initial, 
        End__c = initial.addYears(dates.years)
      ));
      return cert;
    }

    if (certDate == null) {
      return cert; // nothing to do
    }

    // We don't have an initial cert, so create one off certDate
    if (validUntil == null) {
      // create cert for current agreement and continue
      cert = certRepo.create(new Certification__c(
        Contact__c = contactId, 
        Type__c = type, 
        Status__c = 'Active', 
        Start__c = certDate, 
        End__c = certDate.addYears(dates.years)
      ));
      return cert;
    }

    // See if we should complete the current cert and start a new one
    Integer days = validUntil.daysBetween(certDate);

    // Stop checking if the certDate is before the leeway,
    // which it will be until a new certDate is entered
    if (days < -dates.early) {
      return cert;
    }

    // We need the active cert now so we can complete it
    cert = certRepo.getActiveCert(contactId, type);
    // complete old cert
    if (cert != null) {
      cert.Status__c = 'Complete';
      certRepo.modify(cert);
      System.debug('completing old cert');
      validUntil = cert.End__c;
    }

    // We can continue off the old cert date if within the leeway
    if (days <= dates.leeway) {
      cert = certRepo.create(new Certification__c(
        Contact__c = contactId, 
        Type__c = type, 
        Status__c = 'Active', 
        Start__c = validUntil, 
        End__c = validUntil.addYears(dates.years)
      ));
      return cert;
    }

    // We'll start a new cert off the certDate since we've passed the leeway
    cert = certRepo.create(new Certification__c(
      Contact__c = contactId, 
      Type__c = type, 
      Status__c = 'Active', 
      Start__c = certDate, 
      End__c = certDate.addYears(dates.years)
    ));
    return cert;
  }

  // Add existing CEUs to a new certification. This should only be
  // called for new certifications
  public void addCeus(Certification__c cert) {
    // SOQL doesn't allow date comparisons in a query, so get all
    // the CEUs for the contact and filter them out
    List<Ceu__c> ceus = ceuRepo.getForContact(cert.Contact__c, 10000);
    List<CeuCertification__c> ccs = new List<CeuCertification__c>();
    for (Ceu__c ceu : ceus) {
      if (ceu.DateCompleted__c >= cert.Start__c && ceu.DateCompleted__c <= cert.End__c && certRepo.ceuNotAssignedToCert(ceu.Id, cert.Type__c)) {
        Integer approved = 0;
        if (ceu.Status__c == 'Approved') {
          approved = (Integer) ceu.Quantity__c;
        }
        ccs.add(new CeuCertification__c(
          Ceu__c = ceu.Id, 
          Certification__c = cert.Id, 
          Approved__c = approved
        ));
      }
    }
    certRepo.create(ccs);
  }

  public void remindToGetCeus() {
    Certification__c[] certs = certRepo.getActiveCerts();

    if (certs.isEmpty()) {
      return;
    }
    // Remind the contact for these certs to get their CEUs
    Id orgAddressId = emailServ.getOrgEmailAddressId();
    EmailTemplate facTemplate = emailServ.getTemplate('CeuFacilitatorReminder');
    EmailTemplate trainTemplate = emailServ.getTemplate('CeuTrainerReminder');

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Certification__c cert : certs) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      if (orgAddressId != null) {
        mail.setOrgWideEmailAddressId(orgAddressId);
      }
      mail.setTargetObjectId(cert.Contact__c);
      mail.setWhatId(cert.Id);
      if (cert.Type__c == 'Facilitator') {
        mail.setTemplateId(facTemplate.Id);
      } else {
        mail.setTemplateId(trainTemplate.Id);
      }

      // Record ID for which letter will be generated
      mail.setBccSender(false);
      mail.setUseSignature(false);
      if (orgAddressId == null) {
        mail.setSenderDisplayName('Atlas Assistance Dogs');
      }
      mail.setSaveAsActivity(false);
      emails.add(mail);
    }
    emailServ.sendEmail(emails);
  }

}