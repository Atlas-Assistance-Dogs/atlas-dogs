public inherited sharing class FileController {
  @AuraEnabled
  public static list<contentversion> accountFilesRetrieve(
    Id contactId,
    String position,
    String docType
  ) {
    system.debug('Contact Id ' + contactId);
    system.debug('position ' + position);
    system.debug('docType ' + docType);

    list<id> lstConDocs = new List<id>();
    for (ContentDocumentLink cntLink : [
      SELECT Id, ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :contactId
    ]) {
      lstConDocs.add(cntLink.ContentDocumentId);
    }

    system.debug('lstConDocs' + lstConDocs);
    if (!lstConDocs.isEmpty()) {
      return [
        SELECT Title, ContentDocumentId, Type__c, Positions__c, CreatedDate
        FROM ContentVersion
        WHERE
          ContentDocumentId IN :lstConDocs
          AND Positions__c INCLUDES (:position)
          AND Type__c = :docType
      ];
    } else {
      return null;
    }
  }

  @AuraEnabled
  public static void updateRecords(
    Id contactId,
    String position,
    String docType,
    String docName,
    List<Id> docId
  ) {
    system.debug('Account Id update' + contactId);
    system.debug('position update ' + position);
    system.debug('docType update ' + docType);
    system.debug('docName update ' + docName);
    system.debug('docId update ' + docId);
    Id parentId = contactId;
    List<ContentVersion> cvListUpdate = new List<ContentVersion>();
    List<ContentVersion> cvList = [
      SELECT Title, ContentDocumentId, Type__c, Positions__c
      FROM ContentVersion
      WHERE ContentDocumentId IN :docId
    ];
    for (ContentVersion cv : cvList) {
      cv.Type__c = docType;
      cv.Positions__c = position;
      cvListUpdate.add(cv);
    }
    try {
      update cvListUpdate;
    } catch (DmlException ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }

  @AuraEnabled
  public static String deleteRecords(List<String> docIds) {
    system.debug('docIds' + docIds);
    try {
      delete [SELECT Id FROM ContentDocument WHERE Id = :docIds];
      return 'SUCCESS';
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }

  @AuraEnabled
  public static list<contentversion> retrieveAllData(Id contactId) {
    Id parentId = contactId;
    list<id> lstConDocs = new List<id>();
    for (ContentDocumentLink cntLink : [
      SELECT Id, ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :parentId
    ]) {
      lstConDocs.add(cntLink.ContentDocumentId);
    }

    system.debug('lstConDocs' + lstConDocs);
    if (!lstConDocs.isEmpty()) {
      return [
        SELECT Title, ContentDocumentId, Type__c, Positions__c, CreatedDate
        FROM ContentVersion
        WHERE ContentDocumentId IN :lstConDocs
      ];
    } else {
      return null;
    }
  }
}
