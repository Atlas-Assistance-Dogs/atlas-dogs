public inherited sharing class BackgroundCheckRepository {
  public BackgroundCheckRepository() {
  }

  public BackgroundCheck__c[] getMatchingChecksForContacts(
    Set<Id> contactIds,
    Date threshold
  ) {
    return [
      SELECT Id, Date__c, Contact__c, Type__c, Contact__r.Name
      FROM BackgroundCheck__c
      WHERE
        Contact__c IN :contactIds
        AND Date__c > :threshold
        // AND Status__c = 'Pass' We are not checking status at this time
        AND ((Contact__r.VolunteerAccess__c INCLUDES ('Credit Check Required')
        AND Type__c = 'Credit')
        OR (Contact__r.VolunteerAccess__c INCLUDES ('Background Check Required')
        AND Type__c = 'Criminal'))
      ORDER BY Date__c DESC // get the most recent first
    ];
  }
}
