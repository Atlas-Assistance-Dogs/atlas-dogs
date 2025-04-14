public class RelationshipRepository {
  public List<npe4__Relationship__c> getForPair(
    Id contactId,
    Id relatedId,
    String type
  ) {
    return [
      SELECT
        Id,
        npe4__Contact__c,
        npe4__Type__c,
        npe4__Status__c,
        npe4__RelatedContact__c
      FROM npe4__Relationship__c
      WHERE
        npe4__Contact__c = :contactId
        AND npe4__RelatedContact__c = :relatedId
        AND npe4__Type__c = :type
    ];
  }

  public List<npe4__Relationship__c> getCurrentRelated(
    Id contactId,
    String type
  ) {
    return [
      SELECT
        Id,
        npe4__RelatedContact__c,
        npe4__RelatedContact__r.Email,
        npe4__RelatedContact__r.Phone,
        npe4__Type__c
      FROM npe4__Relationship__c
      WHERE
        npe4__Type__c = :type
        AND npe4__Contact__c = :contactId
        AND npe4__Status__c = 'Current'
    ];
  }

  public List<npe4__Relationship__c> getCurrentRelated(Id contactId) {
    return [
      SELECT
        Id,
        npe4__Contact__c,
        npe4__Contact__r.Contact__c,
        npe4__Contact__r.Email,
        npe4__Contact__r.Phone,
        npe4__RelatedContact__c,
        npe4__RelatedContact__r.Email,
        npe4__RelatedContact__r.Phone,
        npe4__Type__c
      FROM npe4__Relationship__c
      WHERE npe4__RelatedContact__c = :contactId AND npe4__Status__c = 'Current'
    ];
  }

  public npe4__Relationship__c[] getSharingPositions(Id contactId) {
    // Find who the contact is related to as an emergency contact
    return [
      SELECT Id, npe4__Contact__r.Positions__c
      FROM npe4__Relationship__c
      WHERE
        (npe4__Type__c LIKE '%Emergency Contact'
        OR npe4__Type__c = 'Guardian')
        AND npe4__Status__c = 'Current'
        AND npe4__RelatedContact__c = :contactId
    ];
  }

  public List<npe4__Relationship__c> getCurrentRelated(
    Set<Id> contactIds,
    String type
  ) {
    return [
      SELECT Id, npe4__Contact__c, npe4__RelatedContact__c
      FROM npe4__Relationship__c
      WHERE
        npe4__Contact__c IN :contactIds
        AND npe4__Status__c = 'Current'
        AND npe4__Type__c = :type
    ];
  }
  public npe4__Relationship__c create(npe4__Relationship__c relationship) {
    upsert relationship;
    return relationship;
  }
  public npe4__Relationship__c modify(npe4__Relationship__c relationship) {
    update relationship;
    return relationship;
  }
}
