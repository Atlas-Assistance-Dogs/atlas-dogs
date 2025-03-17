public inherited sharing class CertificationRepository {
  public List<Certification__c> getForContact(Id contactId) {
    return [
      SELECT Status__c, Contact__c, End__c, Start__c, Approved__c, Type__c
      FROM Certification__c
      WHERE Contact__c = :contactId
      ORDER BY End__c DESC
    ];
  }
  public List<Certification__c> getForContacts(List<Contact> contacts) {
    Set<Id> contactIds = new Set<Id>();
    for (Contact person : contacts) {
      contactIds.add(person.Id);
    }
    return getForContacts(contactIds);
  }
  public List<Certification__c> getForContacts(Set<Id> contactIds) {
    return [
      SELECT Status__c, Contact__c, End__c, Start__c, Approved__c, Type__c
      FROM Certification__c
      WHERE Contact__c IN :contactIds
      ORDER BY End__c DESC
    ];
  }
  public Certification__c create(Certification__c cert) {
    if (cert == null)
      return null;
    insert cert;
    return cert;
  }
  public List<Certification__c> create(List<Certification__c> certs) {
    if (certs == null)
      return null;
    insert certs;
    return certs;
  }
  public List<Certification__c> modify(List<Certification__c> certs) {
    if (certs == null)
      return null;
    update certs;
    return certs;
  }
  public Certification__c modify(Certification__c cert) {
    if (cert == null)
      return null;
    update cert;
    return cert;
  }
  public List<CeuCertification__c> create(List<CeuCertification__c> ccs) {
    if (ccs == null)
      return null;
    insert ccs;
    return ccs;
  }
  public CeuCertification__c get(Id ceuId, Id certificationId) {
    if (ceuId == null || certificationId == null)
      return null;
    CeuCertification__c[] ccs = [
      SELECT Ceu__c, Certification__c
      FROM CeuCertification__c
      WHERE Ceu__c = :ceuId AND Certification__c = :certificationId
      LIMIT 1
    ];
    if (ccs.isEmpty()) {
      return null;
    }
    return ccs[0];
  }

  public void remove(List<CeuCertification__c> ccs) {
    delete ccs;
  }

  public void modify(List<CeuCertification__c> ccs) {
    update ccs;
  }

  public Certification__c getActiveCert(Id contactId, String type) {
    Certification__c[] certs = [
      SELECT Id, Contact__c, Start__c, End__c
      FROM Certification__c
      WHERE Status__c = 'Active' AND Type__c = :type AND Contact__c = :contactId
    ];
    if (certs.isEmpty()) {
      return null;
    }
    return certs[0];
  }

  public Certification__c[] getActiveFacilitatorCerts() {
    return [
      SELECT Id, Contact__c
      FROM Certification__c
      WHERE Status__c = 'Active' AND Type__c = 'Facilitator'
    ];
  }

  // We are using a master detail rollup for the total CEUs in a certification.
  // But to do this, we need to put the number of approved CEUs in the connecting
  // table (CeuCertification__c)
  // So here, we get the list of CeuCertification__c for the CEUs
  public List<CeuCertification__c> getCeuCerts(List<Ceu__c> ceus) {
    List<Id> ceuIds = new List<Id>();
    for (Ceu__c ceu : ceus) {
      ceuIds.add(ceu.Id);
    }
    List<CeuCertification__c> ccs = [
      SELECT
        Certification__c,
        Ceu__c,
        CEU__r.DateCompleted__c,
        CEU__r.Quantity__c,
        CEU__r.Status__c
      FROM CeuCertification__c
      WHERE Ceu__c IN :ceuids
    ];
    return ccs;
  }
}
