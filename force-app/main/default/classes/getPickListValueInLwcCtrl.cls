public with sharing class getPickListValueInLwcCtrl {
    public getPickListValueInLwcCtrl() {

    }

    @AuraEnabled(cacheable = true)
    public static List < FetchValueWrapper > fetchPickListValue(sObject objInfo, string picklistFieldApi) {
        system.debug('objInfo'+objInfo);
        system.debug('picklistFieldApi'+picklistFieldApi);
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objInfo.getSObjectType().getDescribe();
 
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(picklistFieldApi).getDescribe().getPickListValues();
 
        // Create a list of wrapper to store picklist value/lable
        list < FetchValueWrapper > objWrapper = new list < FetchValueWrapper > ();
 
        for (Schema.PicklistEntry a: values) {
            FetchValueWrapper oFetchValueWrapper = new FetchValueWrapper();
            oFetchValueWrapper.slabel = a.getLabel();
            oFetchValueWrapper.svalue = a.getValue();
            objWrapper.add(oFetchValueWrapper);
        }
        system.debug('objWrapper'+objWrapper);
        return objWrapper;
 
    }
 // wrapper class 
    public with sharing class FetchValueWrapper {
        @auraEnabled public string slabel {get;set;}
        @auraEnabled public string svalue {get;set;}
    }
}