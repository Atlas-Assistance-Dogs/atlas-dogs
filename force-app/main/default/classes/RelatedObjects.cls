global with sharing class RelatedObjects {
  // Total number of records of the object
  @AuraEnabled
  global Integer total { get; set; }

  // Records of the object
  @AuraEnabled
  global List<Object> items { get; set; }

  global RelatedObjects() {
    items = new List<Object>();
    total = 0;
  }
}
