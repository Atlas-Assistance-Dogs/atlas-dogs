trigger DogUpdateTrigger on Dog__c(before insert, before update) {
    AtlasSettings__c settings = AtlasSettings__c.getInstance();
    if (settings.VaccineRenewalYears__c == null) {
        settings = new AtlasSettings__c();
        insert settings;
        settings = AtlasSettings__c.getInstance();
    }
    System.debug(settings.VaccineRenewalYears__c);

    if (Trigger.isInsert) {
        System.debug(Trigger.new);
        for (Dog__c dog : Trigger.new) {
            if (
                dog.VaccineDueDistemper__c == null &&
                dog.VaccineLatestDistemper__c != null
            ) {
                dog.VaccineDueDistemper__c = dog.VaccineLatestDistemper__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineDueHepatitis__c == null &&
                dog.VaccineLatestHepatitis__c != null
            ) {
                dog.VaccineDueHepatitis__c = dog.VaccineLatestHepatitis__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineDueParainfluenza__c == null &&
                dog.VaccineLatestParainfluenza__c != null
            ) {
                dog.VaccineDueParainfluenza__c = dog.VaccineLatestParainfluenza__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineDueParvovirus__c == null &&
                dog.VaccineLatestParvovirus__c != null
            ) {
                dog.VaccineDueParvovirus__c = dog.VaccineLatestParvovirus__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineDueRabies__c == null &&
                dog.VaccineLatestRabies__c != null
            ) {
                dog.VaccineDueRabies__c = dog.VaccineLatestRabies__c.addYears(
                    (Integer) settings.RabiesRenewalYears__c
                );
            }
            if (
                dog.PhysicalExamDue__c == null &&
                dog.PhysicalExamLatest__c != null
            ) {
                dog.PhysicalExamDue__c = dog.PhysicalExamLatest__c.addYears(
                    (Integer) settings.DogExamRenewalYears__c
                );
            }
        }
    }

    if (Trigger.isUpdate) {
        for (Dog__c dog : Trigger.new) {
            Dog__c oldDog = Trigger.oldMap.get(dog.Id);
            if (
                dog.VaccineLatestDistemper__c != null &&
                dog.VaccineLatestDistemper__c !=
                oldDog.VaccineLatestDistemper__c
            ) {
                dog.VaccineDueDistemper__c = dog.VaccineLatestDistemper__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineLatestHepatitis__c != null &&
                dog.VaccineLatestHepatitis__c !=
                oldDog.VaccineLatestHepatitis__c
            ) {
                dog.VaccineDueHepatitis__c = dog.VaccineLatestHepatitis__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineLatestParainfluenza__c != null &&
                dog.VaccineLatestParainfluenza__c !=
                oldDog.VaccineLatestParainfluenza__c
            ) {
                dog.VaccineDueParainfluenza__c = dog.VaccineLatestParainfluenza__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineLatestParvovirus__c != null &&
                dog.VaccineLatestParvovirus__c !=
                oldDog.VaccineLatestParvovirus__c
            ) {
                dog.VaccineDueParvovirus__c = dog.VaccineLatestParvovirus__c.addYears(
                    (Integer) settings.VaccineRenewalYears__c
                );
            }
            if (
                dog.VaccineLatestRabies__c != null &&
                dog.VaccineLatestRabies__c != oldDog.VaccineLatestRabies__c
            ) {
                dog.VaccineDueRabies__c = dog.VaccineLatestRabies__c.addYears(
                    (Integer) settings.RabiesRenewalYears__c
                );
            }
            if (
                dog.PhysicalExamLatest__c != null &&
                dog.PhysicalExamLatest__c != oldDog.PhysicalExamLatest__c
            ) {
                dog.PhysicalExamDue__c = dog.PhysicalExamLatest__c.addYears(
                    (Integer) settings.DogExamRenewalYears__c
                );
            }
        }
    }
}
