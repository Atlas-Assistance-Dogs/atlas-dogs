/* Methods for finding and updating contacts */
public inherited sharing class ContactController {
    // Get the page size if available.  If not defined, return the default.
    private static Integer getPageSize() {
        AtlasSettings__c settings = AtlasSettings__c.getInstance();
        if (settings == null) {
            settings = new AtlasSettings__c();
        }
        return (Integer) settings.PageSize__c;
    }

    @AuraEnabled(cacheable=true)
    public static PagedResult getPagedContacts(
        String searchKey,
        Integer pageNumber
    ) {
        String searchId = searchKey.trim();
        String searchCriteria = (String.isBlank(searchId)
            ? '%'
            : '%' + searchId + '%');

        Integer pageSize = getPageSize();
        Integer offset = (pageNumber - 1) * pageSize;

        pagedResult result = new pagedResult();
        result.pageNumber = pageNumber;
        result.pageSize = pageSize;
        result.totalItemCount = Database.countQuery(
            'SELECT count() FROM Contact'
        );

        String query = 'SELECT Id, Name FROM Contact Where Name Like :searchCriteria WITH SECURITY_ENFORCED ORDER BY Name LIMIT :pageSize OFFSET :offset';
        List<Contact> records = Database.query(query);

        result.records = records;

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsWithPosition(String position) {
        return [
            SELECT Id, Name
            FROM Contact
            WHERE Positions__c INCLUDES (:position)
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];
    }

    // Return all the contacts with matching name
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactsByName(String strName) {
        String strNameLike = '%' + strName + '%';
        List<Contact> acctList = [
            SELECT Id, Name
            FROM Contact
            WHERE Name LIKE :strNameLike
        ];
        return acctList;
    }

    @AuraEnabled(Cacheable=true)
    public static List<ProgramAssignment__c> getProgramAssignments(
        Id contactId
    ) {
        try {
            return [
                SELECT
                    AssignedDate__c,
                    CompletionDate__c,
                    ExpectedCompletion__c,
                    Program2__c,
                    Program2__r.Name,
                    Program2__r.Standalone__c,
                    Status__c
                FROM ProgramAssignment__c
                WHERE Contact__c = :contactId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}