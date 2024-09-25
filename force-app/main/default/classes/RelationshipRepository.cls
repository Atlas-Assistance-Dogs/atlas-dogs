public class RelationshipRepository implements IRelationshipRepository {

    public List<npe4__Relationship__c> getCurrentRelated(Set<Id> contactIds, String type) {
        return [
            SELECT Id, npe4__Contact__c, npe4__RelatedContact__c
            FROM npe4__Relationship__c
            WHERE
                npe4__Contact__c IN :contactIds
                AND npe4__Status__c = 'Current'
                AND npe4__Type__c = :type
        ];
    }
}