public with sharing class ReportService {
  // Create the CSV for a ProgramReport (with rows of ProgramReportRow)
  public static void createPaCsvReport(RelatedObjects report, string name) {
    List<String> header = new List<String>{
      'Program',
      'Status',
      'Assigned Date',
      'First Name',
      'Last Name',
      'Preferred Name',
      'Pronoun',
      'Specified Pronoun',
      'Email',
      'Dog Name',
      'Dog Age',
      'Dog Breed',
      'Dog Gender'
    };
    List<List<Object>> rows = new List<List<Object>>();
    for (object item : report.items) {
      ProgramReportRow prr = (ProgramReportRow) item;
      List<Object> row = new List<Object>{
        prr.pa.Program__r.Name,
        prr.pa.Status__c,
        prr.pa.AssignedDate__c,
        prr.contact.FirstName,
        prr.contact.LastName,
        prr.contact.PreferredName__c,
        prr.contact.Pronoun__c,
        prr.contact.PronounOther__c,
        prr.contact.Email,
        prr.dog.Name,
        prr.dog.AgeYears__c,
        prr.dog.Breed__c,
        prr.dog.Gender__c
      };
      rows.add(row);
    }
    createCsv(header, rows, name);
  }
  /**
    @description create a CSV file from a list of Object Lists each Object List is a row in a list of lists. Each Object is a cell in the CSV
    */
  public static void createCsv(
    List<String> csvHeaders,
    List<List<Object>> csvRowList,
    String title
  ) {
    String headerRow = String.join(csvHeaders, ',') + '\n';
    String concantenatedStr = headerRow;
    Integer i = 0;
    Integer rowListSize = csvRowList.size();
    for (List<Object> row : csvRowList) {
      system.debug(row);
      if (csvHeaders.size() != row.size())
        throw new FileMakerException(
          'The row size needs to be the same size as the header'
        ); //check the row list is the same size as the header list
      concantenatedStr += String.join(row, ',');
      i++;
      if (i != rowListSize)
        concantenatedStr += '\n'; //add new line
    }
    title += '.csv';
    createFile(concantenatedStr, title);
  }

  /**
    @description create a file - generic
    */
  public static void createFile(String versionData, String title) {
    ContentVersion cv = new ContentVersion();
    cv.ContentLocation = 'S'; //denotes it resides on Salesforce
    cv.Title = title; //title of the file
    cv.PathOnClient = title; // full path within Salesforce this can just be the name of file to be in the library
    cv.VersionData = Blob.valueOf(versionData); //file data
    insert cv;
  }

  public class FileMakerException extends Exception {
  }
  /* These are utility methods that are not yet needed.  Commented out to avoid finding them again later
    // @description private method for looping through and creating the CSV string from a list of sOBjects
    private static String createSObjectString(List<String> csvFieldAPINames, List<sObject> csvRowList, String concantenatedStr){
        Integer i = 0;
        Integer rowListSize = csvRowList.size();
        Integer headerSize = csvFieldAPINames.size();
        for(sObject row :csvRowList){
            //assuming the rowList is in the correct format and each string in the list is a new record
            Map<string, object> objFieldMap = (Map<string, object>)JSON.deserializeUntyped(JSON.serialize(row));
            Integer j = 0;
            for(String objField :csvFieldAPINames){
                concantenatedStr += objFieldMap.get(objField) != null ? String.valueOf(objFieldMap.get(objField)) : '';
                j++;
                concantenatedStr += j != headerSize ? ',' : '';//add comma separator
            }
            i++;
            if(i != rowListSize) concantenatedStr += '\n';//add new line
        }
        return concantenatedStr;
    }
    // @description create a CSV from a list of sObjects in this method the CSV headers are the same as the api names of the fields to add
    public static void createCSV(List<String> csvHeaders, List<sObject> csvRowList, String title){
        String headerRow = String.join(csvHeaders,',') + '\n';
        String concantenatedStr = headerRow;
        concantenatedStr = createSObjectString(csvHeaders, csvRowList, concantenatedStr);
        title += '.csv';
        createFile(concantenatedStr, title);
    }
    */
}
