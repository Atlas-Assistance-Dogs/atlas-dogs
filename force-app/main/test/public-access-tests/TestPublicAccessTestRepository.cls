/**
 * This class contains unit tests for validating the behavior of Apex class PublicAccessTestRepository
 */
@isTest
private class TestPublicAccessTestRepository{
    static PublicAccessTestRepository repo = new PublicAccessTestRepository();
    @isTest
    static void getPassing_returnsEmptyListWhenNone(){
        Id teamId = MockProvider.createId(Team__c.class);
        List<PublicAccessTest__c> actual = repo.getPassing(teamId);
        // assert
        System.assertEquals(0, actual.size(), 'should be an empty list');
    }

    @isTest
    static void getPassing_returnsNoneWhenNonePassing(){
        Date expiration = Date.today().addYears(1);
        Team__c team = TestPatTrigger.setup(expiration);

        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = team.Handler__c, 
            DateCompleted__c = Date.today(), 
            Location__c = 'In Person', 
            Status__c = 'Failed', 
            Team__c = team.Id, 
            Type__c = 'Initial', 
            ValidUntil__c = expiration
        );
        insert pat;
        List<PublicAccessTest__c> actual = repo.getPassing(team.Id);
        // assert
        System.assertEquals(0, actual.size(), 'should be an empty list');
    }

    @isTest
    static void getPassing_returnsPassing(){
        Date expiration = Date.today().addYears(1);
        Team__c team = TestPatTrigger.setup(expiration);

        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = team.Handler__c, 
            DateCompleted__c = Date.today(), 
            Location__c = 'In Person', 
            Status__c = 'Passed', 
            Team__c = team.Id, 
            Type__c = 'Initial', 
            ValidUntil__c = expiration
        );
        insert pat;
        List<PublicAccessTest__c> result = repo.getPassing(team.Id);
        // assert
        System.assertEquals(1, result.size(), 'should have one element');
        PublicAccessTest__c actual = result[0];
        System.assertEquals(pat.Id, actual.Id, 'pat Ids should match');
        System.assertEquals(pat.DateCompleted__c, actual.DateCompleted__c, 'pat DateCompleted should match');
        System.assertEquals(pat.Type__c, actual.Type__c, 'pat Type should match');
        System.assertEquals(pat.ValidUntil__c, actual.ValidUntil__c, 'pat ValidUntil__c should match');
    }

}