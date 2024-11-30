public inherited sharing class DogController {
    @AuraEnabled(cacheable=true)
    public static Dog__c getVaccinations(String recordId) {
        try {
            return [
                SELECT
                    Id,
                    VaccineDueDA2PP__c,
                    VaccineDueRabies__c,
                    PhysicalExamDue__c
                FROM Dog__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (QueryException exc) {
            AuraHandledException ahe = new AuraHandledException('');
            ahe.setMessage('Dog not found.'); // need to use setMessage for custom message
            throw ahe;
        }
    }

    public class SizeInfo {
        @AuraEnabled
        public Double weight{get; set;}
        @AuraEnabled
        public Double height{get; set;}
        @AuraEnabled
        public Boolean useSiUnits{get; set;}
        public SizeInfo(Dog__c dog, Boolean useSiUnits) {
            this.weight = dog.Weight__c;
            this.height = dog.Height__c;
            this.useSiUnits = useSiUnits;
        }
    }

    @AuraEnabled(cacheable=true)
    public static SizeInfo getSize(Id recordId){
        DogRepository repo = new DogRepository();
        Dog__c dog = repo.getSize(recordId);

        // Get lowest custom settings for this user
        AtlasSettings__c settings = AtlasSettings__c.getInstance();
        if (settings.ShowSiUnits__c == null) {
            settings.ShowSiUnits__c = false; // default to false
            upsert settings;
        }
        return new SizeInfo(dog, settings.ShowSiUnits__c);
    }

    @AuraEnabled
    public static Dog__c setSize(Id recordId, Double height, Double weight){
        DogRepository repo = new DogRepository();
        Dog__c dog = repo.getSize(recordId);
        dog.Height__c = height;
        dog.Weight__c = weight;
        dog = repo.modify(dog);
        return dog;
    }
}
