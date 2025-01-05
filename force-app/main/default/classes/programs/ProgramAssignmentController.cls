/* Methods for finding and updating contacts */
public inherited sharing class ProgramAssignmentController {
  @AuraEnabled(Cacheable=true)
  public static List<ProgramAssignment__c> getProgramAssignments(Id contactId) {
    try {
      return [
        SELECT
          AssignedDate__c,
          CompletionDate__c,
          ExpectedCompletion__c,
          Program__c,
          Program__r.Name,
          Program__r.Standalone__c,
          Status__c
        FROM ProgramAssignment__c
        WHERE Contact__c = :contactId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getReport(string name) {
    List<ProgramAssignment__c> pas = [
      SELECT
        Program__r.Name,
        Contact__c,
        Status__c,
        AssignedDate__c,
        Contact__r.Name,
        Contact__r.MailingAddress,
        Contact__r.AbilityStatus__c,
        Contact__r.SpecifiedAbilityStatus__c,
        Contact__r.FirstName,
        Contact__r.LastName,
        Contact__r.PreferredName__c,
        Contact__r.Pronoun__c,
        Contact__r.PronounOther__c,
        Contact__r.Email
      FROM ProgramAssignment__c
      WHERE Program__r.Name = :name AND Status__c IN ('In Progress', 'Pending')
      ORDER BY AssignedDate__c
    ];

    RelatedObjects related = new RelatedObjects();
    related.total = pas.size();

    for (ProgramAssignment__c pa : pas) {
      ProgramReportRow row = new ProgramReportRow();
      row.pa = pa;
      row.contact = pa.Contact__r;
      try {
        DogRelationShip__c relatedDog = [
          SELECT
            Dog__c,
            Dog__r.Name,
            Dog__r.AgeYears__c,
            Dog__r.Breed__c,
            Dog__r.Gender__c
          FROM DogRelationShip__c
          WHERE
            Contact__c = :pa.Contact__c
            AND Type__c INCLUDES ('Owner', 'Client', 'Handler')
          LIMIT 1
        ];
        row.dog = relatedDog.Dog__r;
      } catch (Exception exc) {
      }
      related.items.add(row);
    }
    return related;
  }
  /*
    public static void sendReportEmail(RelatedObjects report, string email) {
        String generatedCSVFile = '';
        String fileRow = '';

        for (company__c company : extractcompanyMemList) {
            fileRow = '';
            fileRow = fileRow + ',' + company.Id;
            fileRow = fileRow + ',' + company.Name;
            fileRow = fileRow.replaceFirst(',', '');
            generatedCSVFile = generatedCSVFile + fileRow + '\n';
        }

        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(generatedCSVFile);
        String csvName = 'report.csv';
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ 'Your Email Id' };
        String subject = 'Report';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('Report');
        email.setFileAttachments(
            new List<Messaging.EmailFileAttachment>{ csvAttachment }
        );
        Messaging.SendEmailResult[] r = Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ email }
        );
    }*/
}
