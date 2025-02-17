public
inherited sharing class CertificationService {
private
  CertificationRepository certRepo;
private
  EmailService emailServ;
public
  CertificationService() {
    certRepo = new CertificationRepository();
    emailServ = new EmailService();
  }

  @TestVisible private CertificationService(CertificationRepository certRepo,
                                            EmailService emailServ) {
    this.certRepo = certRepo;
    this.emailServ = emailServ;
  }

public
  static Map<Id, List<Ceu__c>> sortCeus(List<Ceu__c> ceus) {
    Map<Id, List<Ceu__c>> contactCeuIds = new Map<Id, List<Ceu__c>>();
    for (Ceu__c ceu : ceus) {
      if (contactCeuIds.containsKey(ceu.Contact__c)) {
        List<Ceu__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
        contactCeus.add(ceu);
      } else {
        contactCeuIds.put(ceu.Contact__c, new List<Ceu__c>{ceu});
      }
    }
    return contactCeuIds;
  }

public
  static Map<Id, List<Certification__c>>
  sortCertifications(List<Certification__c> ceus) {
    Map<Id, List<Certification__c>> contactCeuIds =
        new Map<Id, List<Certification__c>>();
    for (Certification__c ceu : ceus) {
      if (contactCeuIds.containsKey(ceu.Contact__c)) {
        List<Certification__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
        contactCeus.add(ceu);
      } else {
        contactCeuIds.put(ceu.Contact__c, new List<Certification__c>{ceu});
      }
    }
    return contactCeuIds;
  }

  // add CEUs to the appropriate certifications
public
  void addCeus(List<Ceu__c> ceus) {
    Map<Id, List<Ceu__c>> contactCeuIds = sortCeus(ceus);
    List<Certification__c> certs =
        certRepo.getForContacts(contactCeuIds.keySet());
    List<CeuCertification__c> ccs = new List<CeuCertification__c>();
    for (Certification__c cert : certs) {
      List<Ceu__c> contactCeus = contactCeuIds.get(cert.Contact__c);
      for (Ceu__c ceu1 : contactCeus) {
        if (ceu1.DateCompleted__c >= cert.Start__c &&
            ceu1.DateCompleted__c <= cert.End__c) {
          CeuCertification__c cc = new CeuCertification__c(
              Ceu__c = ceu1.Id, Certification__c = cert.Id);
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
public
  void updateCeus(List<Ceu__c> ceus, Map<Id, Ceu__c> old) {
    List<CeuCertification__c> ceuCerts = certRepo.getCeuCerts(ceus);

    for (CeuCertification__c cc : ceuCerts) {
      if (cc.Ceu__r.Status__c == 'Approved') {
        cc.Approved__c = cc.Ceu__r.Quantity__c;
      }
    }
    certRepo.modify(ceuCerts);
  }

public
  void remindFacilitatorsToGetCeus() {
    Certification__c[] certs = certRepo.getActiveFacilitatorCerts();

    if (certs.isEmpty()) {
      return;
    }
    // Remind the contact for these certs to get their CEUs
    Id orgAddressId = emailServ.getOrgEmailAddressId();
    EmailTemplate template = emailServ.getTemplate('FacilitatorCeuReminder');

    List<Messaging.SingleEmailMessage> emails =
        new List<Messaging.SingleEmailMessage>();
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