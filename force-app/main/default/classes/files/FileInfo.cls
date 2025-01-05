global with sharing class FileInfo {
  @AuraEnabled
  global ContentDocumentLink cdl { get; set; }
  @AuraEnabled
  global ContentVersion cv { get; set; }
  @AuraEnabled
  global string category { get; set; }
  @AuraEnabled
  global string type { get; set; }
}
