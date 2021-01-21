public with sharing class retrieveFiles {
    public retrieveFiles() {

    }

    @AuraEnabled
    public static list<contentversion> accountFilesRetrieve(Id accountId,String userType,String docType){
       system.debug('Account Id '+accountId);
        system.debug('userType '+userType);
        system.debug('docType '+docType);
        
        
       Id parentId = accountId;
       list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:parentId]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        
        system.debug('lstConDocs'+lstConDocs);
        if(!lstConDocs.isEmpty()) {
           
            return [SELECT  Title, ContentDocumentId,Type__c,UserType__c,CreatedDate 
                    FROM ContentVersion 
                    WHERE ContentDocumentId IN :lstConDocs 
                    AND UserType__c =:userType
                    AND Type__c = :docType
                    ];
        }
        else {
            return null;
        }
     
    }
    @AuraEnabled
    public static void updateRecords(Id accountId,String userType,String docType,String docName,List<Id> docId){
        system.debug('Account Id update'+accountId);
        system.debug('userType update '+userType);
        system.debug('docType update '+docType);
        system.debug('docName update '+docName);
        system.debug('docId update '+docId);
        Id parentId = accountId;
        List<ContentVersion> cvListUpdate = new  List<ContentVersion>();
        List<ContentVersion> cvList = [SELECT  Title, ContentDocumentId,Type__c,UserType__c 
                                       FROM ContentVersion 
                                       WHERE ContentDocumentId IN: docId];
        for(ContentVersion cv:cvList){
            cv.Type__c = docType;
            cv.UserType__c = userType;
            cvListUpdate.add(cv);
        }
        try{
        update cvListUpdate;
        }
         catch(DmlException ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static String deleteRecords(List<String> docIds ){
        system.debug('docIds'+docIds);
         try{
            delete [SELECT Id FROM ContentDocument WHERE Id=:docIds];
            return 'SUCCESS';
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static list<contentversion> retrieveAllData(Id accountId){
        Id parentId = accountId;
       list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:parentId]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        
        system.debug('lstConDocs'+lstConDocs);
        if(!lstConDocs.isEmpty()) {
           
            return [SELECT  Title, ContentDocumentId,Type__c,UserType__c,CreatedDate 
                    FROM ContentVersion 
                    WHERE ContentDocumentId IN :lstConDocs 
                   
                    ];
        }
        else {
            return null;
        }
        
    }
}