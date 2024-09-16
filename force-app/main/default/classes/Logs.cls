public inherited sharing class Logs extends ApplicationSObjectDomain implements ILogs {
    // 1. Boilerplate code
    public static ILogs newInstance(List<Log__c> records) {
        return (ILogs) Application.Domain.newInstance(records);
    }

    public static ILogs newInstance(Set<Id> recordIds) {
        return (ILogs) Application.Domain.newInstance(recordIds);
    }

    public Logs(List<Log__c> records) {
        super(records);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Logs(sObjectList);
        }
    }

    // 2. Trigger methods
    public override void onBeforeInsert() {
        this.validateUserSso(getRecords());
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        this.validateUserSso(getChangedRecords(new Set<String>{ 'SSOId__c' }));
    }

    // 3. Domain methods
    public Map<String, Boolean> validateUserSso() {
        return validateUserSso((List<Log__c>) getRecords());
    }
    public Map<String, Boolean> validateUserSso(List<Log__c> Logs) {
        // run sso validation here
        return new Map<String, Boolean>();
    }
}
