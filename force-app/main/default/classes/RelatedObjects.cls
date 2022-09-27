public with sharing class RelatedObjects {
    // Total number of records of the object
    @AuraEnabled
    public Integer total { get; set; }
    
    // Records of the object
    @AuraEnabled
    public List<Object> items { get; set; }

    public RelatedObjects() {
        items = new List<Object>();
        total = 0;
    }
}
