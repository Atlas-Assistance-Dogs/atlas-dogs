public with sharing class Settings {
    @TestVisible
    public static Map<String, Decimal> programDurations {
        get {
            if (programDurations == null) {
                ProgramDuration__mdt[] durations = [
                    SELECT Months__c, Program__c
                    FROM ProgramDuration__mdt
                ];
                programDurations = new Map<String, Decimal>();
                for (ProgramDuration__mdt duration : durations) {
                    programDurations.put(
                        duration.Program__c,
                        duration.Months__c
                    );
                }
            }

            return programDurations;
        }
        private set {
            programDurations = value;
        }
    }
}
