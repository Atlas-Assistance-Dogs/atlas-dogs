public inherited sharing class PublicAccessTestRepository {
  // returns the passing PATs in descending order by ValidUntil__c field
  public List<PublicAccessTest__c> getPassing(Id teamId) {
    return [
      SELECT Id, DateCompleted__c, Type__c, ValidUntil__c
      FROM PublicAccessTest__c
      WHERE Status__c = 'Passed' AND Team__c = :teamId
      ORDER BY ValidUntil__c DESC
    ];
  }
}
