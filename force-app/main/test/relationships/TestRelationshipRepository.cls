/**
 * This class contains unit tests for RelationshipRepository
 */
@isTest
private class TestRelationshipRepository {
  static RelationshipRepository repo = new RelationshipRepository();

  @isTest
  static void getForPair_returnsEmpty_whenBadIds() {
    List<npe4__Relationship__c> actual = repo.getForPair(
      MockProvider.createId(Dog__c.class),
      MockProvider.createId(Account.class),
      'made-up'
    );
    System.assertEquals(0, actual.size(), 'should be empty');
  }
  @isTest
  static void getForPair_returnsEmpty_whenNoRelationship() {
    Contact ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    Contact cookie = new Contact(FirstName = 'Cookie', LastName = 'Monster');
    insert new List<Contact>{ ace, cookie };

    List<npe4__Relationship__c> actual = repo.getForPair(
      ace.Id,
      cookie.Id,
      'made-up'
    );
    System.assertEquals(0, actual.size(), 'should be empty');
  }
  @isTest
  static void getForPair_returnsEmpty_whenRelationshipTypeDoesntMatch() {
    Contact ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    Contact cookie = new Contact(FirstName = 'Cookie', LastName = 'Monster');
    insert new List<Contact>{ ace, cookie };

    npe4__Relationship__c relate = new npe4__Relationship__c(
      npe4__Contact__c = ace.Id,
      npe4__Type__c = 'Spouse',
      npe4__Status__c = 'Current',
      npe4__RelatedContact__c = cookie.Id
    );
    insert relate;

    List<npe4__Relationship__c> actual = repo.getForPair(
      ace.Id,
      cookie.Id,
      'made-up'
    );
    System.assertEquals(0, actual.size(), 'should be empty');
  }
  @isTest
  static void getForPair_returnsRelationship_whenRelationshipTypeMatches() {
    Contact ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    Contact cookie = new Contact(FirstName = 'Cookie', LastName = 'Monster');
    insert new List<Contact>{ ace, cookie };

    npe4__Relationship__c relate = new npe4__Relationship__c(
      npe4__Contact__c = ace.Id,
      npe4__Type__c = 'Spouse',
      npe4__Status__c = 'Current',
      npe4__RelatedContact__c = cookie.Id
    );
    insert relate;

    List<npe4__Relationship__c> result = repo.getForPair(
      ace.Id,
      cookie.Id,
      'Spouse'
    );
    System.assertEquals(1, result.size(), 'should have one record');
    npe4__Relationship__c actual = result[0];
    System.assertEquals(
      relate.npe4__Contact__c,
      actual.npe4__Contact__c,
      'wrong contact'
    );
    System.assertEquals(
      relate.npe4__RelatedContact__c,
      actual.npe4__RelatedContact__c,
      'wrong related contact'
    );
    System.assertEquals(
      relate.npe4__Type__c,
      actual.npe4__Type__c,
      'wrong type'
    );
    System.assertEquals(
      relate.npe4__Status__c,
      actual.npe4__Status__c,
      'wrong status'
    );
  }
  @isTest
  static void getCurrentRelated_returnsRelationship_whenRelationshipTypeMatches() {
    Contact ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    Contact cookie = new Contact(
      FirstName = 'Cookie',
      LastName = 'Monster',
      Email = 'cookie@test.com',
      Phone = '800-555-1234'
    );
    insert new List<Contact>{ ace, cookie };

    npe4__Relationship__c relate = new npe4__Relationship__c(
      npe4__Contact__c = ace.Id,
      npe4__Type__c = 'Spouse',
      npe4__Status__c = 'Current',
      npe4__RelatedContact__c = cookie.Id
    );
    insert relate;

    List<npe4__Relationship__c> result = repo.getCurrentRelated(
      ace.Id,
      'Spouse'
    );
    System.assertEquals(1, result.size(), 'should have one record');
    npe4__Relationship__c actual = result[0];
    System.assertEquals(
      cookie.Email,
      actual.npe4__RelatedContact__r.Email,
      'no email'
    );
    System.assertEquals(
      cookie.Phone,
      actual.npe4__RelatedContact__r.Phone,
      'no phone'
    );
    System.assertEquals(
      relate.npe4__RelatedContact__c,
      actual.npe4__RelatedContact__c,
      'wrong related contact'
    );
    System.assertEquals(
      relate.npe4__Type__c,
      actual.npe4__Type__c,
      'wrong type'
    );
  }
  @isTest
  static void getCurrentRelated_returnsRelationship_whenNoType() {
    Contact ace = new Contact(
      FirstName = 'Ace',
      LastName = 'GSD',
      Email = 'ace@test.com',
      Phone = '888-555-1234'
    );
    Contact cookie = new Contact(
      FirstName = 'Cookie',
      LastName = 'Monster',
      Email = 'cookie@test.com',
      Phone = '800-555-1234'
    );
    insert new List<Contact>{ ace, cookie };

    npe4__Relationship__c relate = new npe4__Relationship__c(
      npe4__Contact__c = ace.Id,
      npe4__Type__c = 'Husband',
      npe4__Status__c = 'Current',
      npe4__RelatedContact__c = cookie.Id
    );
    insert relate;

    List<npe4__Relationship__c> result = repo.getCurrentRelated(cookie.Id);
    System.assertEquals(1, result.size(), 'should have one record');
    npe4__Relationship__c actual = result[0];
    System.assertEquals(
      cookie.Email,
      actual.npe4__RelatedContact__r.Email,
      'no email'
    );
    System.assertEquals(
      cookie.Phone,
      actual.npe4__RelatedContact__r.Phone,
      'no phone'
    );
    System.assertEquals(
      ace.Email,
      actual.npe4__Contact__r.Email,
      'no email'
    );
    System.assertEquals(
      ace.Phone,
      actual.npe4__Contact__r.Phone,
      'no phone'
    );
    System.assertEquals(
      relate.npe4__RelatedContact__c,
      actual.npe4__RelatedContact__c,
      'wrong related contact'
    );
    System.assertEquals(
      relate.npe4__Type__c,
      actual.npe4__Type__c,
      'wrong type'
    );
  }
}
