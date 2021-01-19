public with sharing class courseAssignmentByAccount{
    
        @AuraEnabled(Cacheable=true)
        public static List <Account> getAcct(String strName) {
            String strNameLike = '%'+strName+'%';
            List<Account> acctList = [SELECT Id,Full_Name__c
                                       FROM Account
                                       Where Full_Name__c like :strNameLike];
            return acctList; }
    
}