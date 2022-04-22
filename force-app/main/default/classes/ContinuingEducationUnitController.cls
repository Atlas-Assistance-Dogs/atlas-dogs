public with sharing class ContinuingEducationUnitController {
    // This method is used by the related list component, and needs more than just the background check
    @AuraEnabled(Cacheable=true)
    public static List<ContinuingEducationUnit__c> getRelatedCeus(
        Id contactId
    ) {
        try {
            List<ContinuingEducationUnit__c> ceus = [
                SELECT
                    Authority__c,
                    AuthorityOther__c,
                    Comments__c,
                    DateCompleted__c,
                    DateSubmitted__c,
                    ProgramDate__c,
                    ProgramHours__c,
                    ProgramTitle__c,
                    Quantity__c,
                    Role__c,
                    Status__c,
                    Trainer__c
                FROM ContinuingEducationUnit__c
                WHERE Trainer__c = :contactId
            ];
            return ceus;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ContinuingEducationUnit__c createCeu(
        ContinuingEducationUnit__c record,
        List<Id> documentIds
    ) {
        try {
            insert record;
            if (documentIds != null) {
                FileController.relateFiles(documentIds, record.Id);
            }
            return record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ContinuingEducationUnit__c updateCeu(
        ContinuingEducationUnit__c record
    ) {
        try {
            update record;
            return record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCeu(Id recordId) {
        try {
            ContinuingEducationUnit__c ceu = [
                SELECT Id
                FROM ContinuingEducationUnit__c
                WHERE Id = :recordId
            ];
            delete ceu;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
