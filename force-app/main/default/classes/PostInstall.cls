global class PostInstall implements InstallHandler {
    global void onInstall(InstallContext context) {
        if (context == null) {
            return;
        }
        if (context.previousVersion() == null) {
            return;
        }
        if (context.previousVersion().compareTo(new Version(1, 3)) <= 0) {
            // combine dog vaccine fields
            List<Dog__c> dogs = [
                SELECT
                    Name,
                    VaccineDueDA2PP__c,
                    VaccineDueDistemper__c,
                    VaccineDueHepatitis__c,
                    VaccineDueParainfluenza__c,
                    VaccineDueParvovirus__c
                FROM Dog__c
            ];
            for (Dog__c dog : dogs) {
                system.debug(dog);
                Date latest = later(
                    dog.VaccineDueDistemper__c,
                    dog.VaccineDueHepatitis__c
                );
                latest = later(latest, dog.VaccineDueParainfluenza__c);
                latest = later(latest, dog.VaccineDueParvovirus__c);
                dog.VaccineDueDA2PP__c = latest;
            }
            update dogs;
        }
    }

    private Date later(Date latest, Date vaccine) {
        if (latest == null) {
            return vaccine;
        }
        if (vaccine > latest) {
            return vaccine;
        }
        return latest;
    }
}
