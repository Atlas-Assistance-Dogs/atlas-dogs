public inherited sharing class CeuService {
    private CertificationRepository certRepo;
    public CeuService() {
        certRepo = new CertificationRepository();
    }

    @TestVisible
    private CeuService(CertificationRepository certRepo) {
        this.certRepo = certRepo;
    }

    public static Map<Id, List<Ceu__c>> sortCeus(List<Ceu__c> ceus) {
        Map<Id, List<Ceu__c>> contactCeuIds = new Map<Id, List<Ceu__c>>();
        for (Ceu__c ceu : ceus) {
            if (contactCeuIds.containsKey(ceu.Contact__c)) {
                List<Ceu__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
                contactCeus.add(ceu);
            }
            else {
                contactCeuIds.put(ceu.Contact__c, new List<Ceu__c>{ ceu });
            }
        }
        return contactCeuIds;
    }

    public static Map<Id, List<Certification__c>> sortCertifications(List<Certification__c> ceus) {
        Map<Id, List<Certification__c>> contactCeuIds = new Map<Id, List<Certification__c>>();
        for (Certification__c ceu : ceus) {
            if (contactCeuIds.containsKey(ceu.Contact__c)) {
                List<Certification__c> contactCeus = contactCeuIds.get(ceu.Contact__c);
                contactCeus.add(ceu);
            }
            else {
                contactCeuIds.put(ceu.Contact__c, new List<Certification__c>{ ceu });
            }
        }
        return contactCeuIds;
    }

    // add CEUs to the appropriate certifications
    public void addCeus(List<Ceu__c> ceus) {
        Map<Id, List<Ceu__c>> contactCeuIds = sortCeus(ceus);
        List<Certification__c> certs = certRepo.getForContacts(contactCeuIds.keySet());
        List<CeuCertification__c> ccs = new List<CeuCertification__c>();
        for (Certification__c cert: certs) {
            List<Ceu__c> contactCeus = contactCeuIds.get(cert.Contact__c);
            for (Ceu__c ceu1: contactCeus) {
                if (ceu1.DateCompleted__c >= cert.Start__c && ceu1.DateCompleted__c <= cert.End__c) {
                    ccs.add(new CeuCertification__c(Ceu__c = ceu1.Id, Certification__c = cert.Id));
                    if (ceu1.Status__c == 'Approved') {
                        if (cert.TotalCeus__c == null) {
                            cert.TotalCeus__c = 0;
                        }
                        cert.TotalCeus__c = cert.TotalCeus__c + ceu1.Quantity__c;
                    }
                }
            }
        }
        certRepo.create(ccs);
        certRepo.modify(certs);
    }

    public void updateCeus(List<Ceu__c> ceus, Map<Id, Ceu__c> old) {
        deleteCeus(old.values());
        addCeus(ceus);
    }

    public void deleteCeus(List<Ceu__c> ceus) {
        Map<Id, List<Ceu__c>> contactCeuIds = sortCeus(ceus);
        List<Certification__c> certs = certRepo.getForContacts(contactCeuIds.keySet());
        List<CeuCertification__c> ccs = new List<CeuCertification__c>();
        for (Certification__c cert: certs) {
            List<Ceu__c> contactCeus = contactCeuIds.get(cert.Contact__c);
            for (Ceu__c ceu1: contactCeus) {
                if (ceu1.DateCompleted__c >= cert.Start__c && ceu1.DateCompleted__c <= cert.End__c) {
                    CeuCertification__c cc = certRepo.get(ceu1.Id, cert.Id);
                    if (cc != null) {
                        ccs.add(cc);
                        if (ceu1.Status__c == 'Approved' && cert.TotalCeus__c != null) {
                            cert.TotalCeus__c = cert.TotalCeus__c - ceu1.Quantity__c;
                        }
                    }
                }
            }
        }
        certRepo.remove(ccs);
        certRepo.modify(certs);
    }
}