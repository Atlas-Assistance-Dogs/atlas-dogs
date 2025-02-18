public inherited sharing class CertificationService {
  private CertificationRepository certRepo;
  private EmailService emailServ;
  public CertificationService() {
    certRepo = new CertificationRepository();
    emailServ = new EmailService();
  }

  @TestVisible
  private CertificationService(
    CertificationRepository certRepo,
    EmailService emailServ
  ) {
    this.certRepo = certRepo;
    this.emailServ = emailServ;
  }

  public static Map<Id, List<Ceu__c>> sortCeus(List<Ceu__c> ceus) {
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

  public static Map<Id, List<Certification__c>> sortCertifications(
    List<Certification__c> ceus
  ) {
    Map<Id, List<Certification__c>> contactCeuIds = new Map<Id, List<Certification__c>>();
    for (Certification__c ceu : ceus) {
      if (contactCeuIds.containsKey(ceu.Contact__c)) {
        List<Certification__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
        contactCeus.add(ceu);
      } else {
        contactCeuIds.put(ceu.Contact__c, new List<Certification__c>{ ceu });
      }
    }
    return contactCeuIds;
  }

  // add CEUs to the appropriate certifications
  public void addCeus(List<Ceu__c> ceus) {
    Map<Id, List<Ceu__c>> contactCeuIds = sortCeus(ceus);
    List<Certification__c> certs = certRepo.getForContacts(
      contactCeuIds.keySet()
    );
    List<CeuCertification__c> ccs = new List<CeuCertification__c>();
    for (Certification__c cert : certs) {
      List<Ceu__c> contactCeus = contactCeuIds.get(cert.Contact__c);
      for (Ceu__c ceu1 : contactCeus) {
        if (
          ceu1.DateCompleted__c >= cert.Start__c &&
          ceu1.DateCompleted__c <= cert.End__c
        ) {
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
    certRepo.modify(certs);
  }

  // Since there is a rollup summary an Approved, check that it is set properly
  // We will not worry about changing the certification at this time, since
  // that is not likely to happen
  public void updateCeus(List<Ceu__c> ceus, Map<Id, Ceu__c> old) {
    List<CeuCertification__c> ccs = certRepo.getCeuCerts(ceus);

    for (CeuCertification__c cc : ccs) {
      if (cc.Ceu__r.Status__c == 'Approved') {
        cc.Approved__c = cc.Ceu__r.Quantity__c;
      } else {
        cc.Approved__c = 0;
      }
    }
    certRepo.modify(ccs);
  }

  private class Dates {
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

  public Certification__c updateCert(
    Contact person,
    String type,
    Date validUntil,
    Date certDate
  ) {
    Certification__c cert = certRepo.getActiveCert(person.Id, type);
    Dates dates = new Dates();
    if (cert == null) {
      if (validUntil == null) {
        // create cert and exit
        cert = certRepo.create(
          new Certification__c(
            Contact__c = person.Id,
            Type__c = type,
            Status__c = 'Active',
            Start__c = certDate,
            End__c = certDate.addYears(dates.years)
          )
        );
        return cert;
      } else {
        // create cert for current validUntil and continue
        cert = certRepo.create(
          new Certification__c(
            Contact__c = person.Id,
            Type__c = type,
            Status__c = 'Active',
            Start__c = validUntil.addYears(-dates.years),
            End__c = validUntil
          )
        );
      }
    }
    Integer days = certDate.daysBetween(cert.End__c);
    if (days >= -dates.early && days <= dates.leeway) {
      // complete old cert
      cert.Status__c = 'Complete';
      certRepo.modify(cert);

      cert = certRepo.create(
        new Certification__c(
          Contact__c = person.Id,
          Type__c = type,
          Status__c = 'Active',
          Start__c = cert.End__c,
          End__c = cert.End__c.addYears(dates.years)
        )
      );
      return cert;
    }
    if (days > dates.leeway) {
      // complete old cert and start new one
      // complete old cert
      cert.Status__c = 'Complete';
      certRepo.modify(cert);

      cert = certRepo.create(
        new Certification__c(
          Contact__c = person.Id,
          Type__c = type,
          Status__c = 'Active',
          Start__c = certDate,
          End__c = certDate.addYears(dates.years)
        )
      );
      return cert;
    }
    return null;
  }

  public void remindFacilitatorsToGetCeus() {
    Certification__c[] certs = certRepo.getActiveFacilitatorCerts();

    if (certs.isEmpty()) {
      return;
    }
    // Remind the contact for these certs to get their CEUs
    Id orgAddressId = emailServ.getOrgEmailAddressId();
    EmailTemplate template = emailServ.getTemplate('FacilitatorCeuReminder');

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Certification__c cert : certs) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      if (orgAddressId != null) {
        mail.setOrgWideEmailAddressId(orgAddressId);
      }
      mail.setTargetObjectId(cert.Contact__c);
      mail.setWhatId(cert.Id);
      mail.setTemplateId(template.Id);

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
