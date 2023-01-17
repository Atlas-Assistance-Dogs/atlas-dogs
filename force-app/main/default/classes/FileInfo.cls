public with sharing class FileInfo {
    @AuraEnabled
    public ContentDocumentLink cdl { get; set; }
    @AuraEnabled
    public ContentVersion cv { get; set; }
    @AuraEnabled
    public string category { get; set; }
    @AuraEnabled
    public string type { get; set; }
}
