public inherited sharing class PublicAccessTestRepository {
    
    public List<PublicAccessTest__c> getPassing(Id teamId) {
        return [
            SELECT Id, DateCompleted__c, Type__c, ValidUntil__c
            FROM PublicAccessTest__c
            WHERE Status__c = 'Passed' AND Team__c = :teamId
            ORDER BY ValidUntil__c DESC
        ];
    }
}