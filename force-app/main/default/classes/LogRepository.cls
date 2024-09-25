public class LogRepository implements ILogRepository {

    public List<Log__c> getRecent(String recordType, Integer days) {
        Date cutoff = Date.today().addDays(0 - days);
        return [
            SELECT
                Team__c,
                Team__r.Client__c,
                Team__r.Facilitator__c,
                Team__r.Name,
                Team__r.Dog__c
            FROM Log__c
            WHERE
                RecordType.DeveloperName = :recordType
                AND Date__c > :cutoff
        ];
    }
}