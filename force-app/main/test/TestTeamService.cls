/* Test the methods used in the TeamController and TeamTrigger */
@isTest
public class TestTeamService {
    private static Contact joe;
    private static Contact jack;
    private static Dog__c buddy;
    private static Team__c joe_buddy;

    private static void createTeam() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            email = 'joe@test.org'
        );
        jack = new Contact(
            FirstName = 'Jack',
            LastName = 'Nimble',
            email = 'jack@test.org'
        );
        buddy = new Dog__c(Name = 'Buddy');
        insert new List<Contact>{ joe, jack };
        insert buddy;
        joe_buddy = new Team__c(
            Client__c = joe.Id,
            Dog__c = buddy.Id,
            Facilitator__c = jack.Id,
            Status__c = 'In Training',
            TrainingStartDate__c = Date.today()
        );
        insert joe_buddy;
        // TODO: prevent creating duplicate relationships
        // npe4__Relationship__c relationship = new npe4__Relationship__c(
        //     npe4__Contact__c = joe.Id,
        //     npe4__RelatedContact__c = jack.Id,
        //     npe4__Status__c = 'Current',
        //     npe4__Type__c = 'Team Faciliator'
        // );
        // insert relationship;
    }
}
