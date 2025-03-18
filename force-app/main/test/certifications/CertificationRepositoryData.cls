/**
 * This class contains methods to create test data for the certification repository
 */
@isTest
public class CertificationRepositoryData {
  public Contact con1;
  public Certification__c cert;
  public Ceu__c ceu;
  public CeuCertification__c cc;

  public CertificationRepositoryData() {
    con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con1;
    Date start = Date.today().addYears(-1).addMonths(3);
    Date ending = start.addYears(1);
    cert = new Certification__c(
      Status__c = 'Active',
      Contact__c = con1.Id,
      End__c = ending,
      Start__c = start,
      Type__c = 'Trainer'
    );
    insert cert;
    ceu = new Ceu__c(
      Authority__c = 'Atlas',
      Comments__c = 'Comments1',
      DateCompleted__c = Date.today().addMonths(-1),
      DateSubmitted__c = Date.today().addMonths(-1),
      ProgramDate__c = Date.today().addDays(-22),
      ProgramHours__c = 20,
      ProgramTitle__c = 'A Day in the Life of a Dog',
      Quantity__c = 20,
      Role__c = 'Presenter',
      Status__c = 'Approved',
      Contact__c = con1.Id
    );
    insert ceu;
    cc = new CeuCertification__c(
      Ceu__c = ceu.Id,
      Certification__c = cert.Id
    );
  }
}
