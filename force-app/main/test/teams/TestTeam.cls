/**
 * This class contains utilities for testing objects that include Teams.
 */
@isTest
public class TestTeam {
  public static Team__c create() {
    Contact debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen');
    Contact ken = new Contact(FirstName = 'Ken', LastName = 'King');
    Contact wanda = new Contact(FirstName = 'Wanda', LastName = 'Around');
    List<Contact> contacts = new List<Contact>{ debbie, ken, wanda };
    insert contacts;

    Dog__c ace = new Dog__c(Name = 'Ace');
    insert ace;

    Team__c team = new Team__c(
      Client__c = ken.Id,
      Dog__c = ace.Id,
      Handler__c = debbie.Id,
      Facilitator__c = wanda.Id,
      Name = 'Camelot',
      PatValidUntil__c = Date.today().addMonths(12),
      PatCount__c = 21,
      PrimaryCertification__c = 'Allergen Alert',
      SecondaryCertification__c = 'Autism',
      Status__c = 'Certified',
      TrainingStartDate__c = Date.today()
    );
    insert team;
    return [
      SELECT
        id,
        Client__c,
        Dog__c,
        Dog__r.Name,
        Handler__c,
        Handler__r.FirstName,
        Handler__r.LastName,
        Facilitator__c,
        Facilitator__r.FirstName,
        Facilitator__r.LastName,
        Name,
        PatCount__c,
        PatValidUntil__c,
        PrimaryCertification__c,
        SecondaryCertification__c,
        Status__c,
        TrainingStartDate__c
      FROM Team__c
      WHERE id = :team.Id
    ];
  }
}
