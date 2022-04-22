public with sharing class BackgroundCheckController {
    // This method is used by the related list component, and needs more than just the background check
    @AuraEnabled(Cacheable=true)
    public static List<BackgroundCheck> getRelatedChecks(Id contactId) {
        try {
            List<BackgroundCheck__c> checks = [
                SELECT Contact__c, Date__c, Notes__c, Status__c
                FROM BackgroundCheck__c
                WHERE Contact__c = :contactId
            ];

            List<BackgroundCheck> bgChecks = new List<BackgroundCheck>();
            for (BackgroundCheck__c bgc : checks) {
                BackgroundCheck outCheck = new BackgroundCheck();
                outCheck.recordId = bgc.Id;
                outCheck.completedDate = bgc.Date__c;
                outCheck.status = bgc.Status__c;
                outCheck.noFile = true;
                List<ContentVersion> files = FileController.getRelatedFiles(
                    bgc.Id
                );
                if (files != null && !files.isEmpty()) {
                    outCheck.documentId = files[0].ContentDocumentId;
                    outCheck.fileName = files[0].Title;
                    outCheck.noFile = false;
                }
                bgChecks.add(outCheck);
            }
            return bgChecks;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCheck(Id recordId) {
        try {
            delete [SELECT Id FROM BackgroundCheck__c WHERE Id = :recordId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id addBackgroundCheck(
        BackgroundCheck__c check,
        Id documentId
    ) {
        try {
            insert check;
            if (documentId != null) {
                FileController.relateFile(documentId, check.Id);
            }
            return check.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateBackgroundCheck(BackgroundCheck__c check) {
        try {
            update check;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
