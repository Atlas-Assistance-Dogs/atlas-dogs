public inherited sharing class CEURepository {
    public CEURepository() {

    }

    public List<CEU__c> getForContact(Id contactId, Integer max) {
        if (max == null) {
            max = 6;
        }
        return [
            SELECT
                Authority__c,
                AuthorityOther__c,
                Comments__c,
                DateCompleted__c,
                DateSubmitted__c,
                Name,
                ProgramDate__c,
                ProgramHours__c,
                ProgramTitle__c,
                Quantity__c,
                Role__c,
                Status__c,
                Contact__c
            FROM CEU__c
            WHERE Contact__c = :contactId
            LIMIT :max
        ];
    }

    public Integer getCountForContact(Id contactId) {
        return [SELECT Count() FROM CEU__c WHERE Contact__c = :contactId];
    }

    public CEU__c[] getForCertification(Id certId) {
        CeuCertification__c[] ccs = [SELECT CEU__r.Authority__c,
        CEU__r.AuthorityOther__c,
        CEU__r.Comments__c,
        CEU__r.DateCompleted__c,
        CEU__r.DateSubmitted__c,
        CEU__r.Name,
        CEU__r.ProgramDate__c,
        CEU__r.ProgramHours__c,
        CEU__r.ProgramTitle__c,
        CEU__r.Quantity__c,
        CEU__r.Role__c,
        CEU__r.Status__c,
        CEU__r.Contact__c FROM CeuCertification__c WHERE Certification__c = :certId];
        List<CEU__c> ceus = new List<CEU__c>();
        for (CeuCertification__c cc : ccs) {
            ceus.add(cc.CEU__r);
        }
        return ceus;
    }
}