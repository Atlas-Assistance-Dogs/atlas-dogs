/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestFileControllerRestrictions {
    class MyPickListInfo {
        public Boolean active;
        public Boolean defaultValue;
        public String label;
        public String validFor;
        public String value;
    }
    public static Map<String, List<String>> getCategoryTypeDependencies() {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe()
            .get('ContentVersion');

        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap()
            .get('Category__c')
            .getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap()
            .get('Type__c')
            .getDescribe();

        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

        for (Schema.PicklistEntry currControllingValue : controllingValues) {
            controllingInfo.put(
                currControllingValue.getValue(),
                new List<String>()
            );
        }

        for (Schema.PicklistEntry currDependentValue : dependentValues) {
            String jsonString = JSON.serialize(currDependentValue);

            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(
                jsonString,
                MyPickListInfo.class
            );

            String hexString = EncodingUtil.convertToHex(
                    EncodingUtil.base64Decode(info.validFor)
                )
                .toUpperCase();

            Integer baseCount = 0;

            for (Integer curr : hexString.getChars()) {
                Integer val = 0;

                if (curr >= 65) {
                    val = curr - 65 + 10;
                } else {
                    val = curr - 48;
                }

                if ((val & 8) == 8) {
                    controllingInfo.get(
                            controllingValues[baseCount + 0].getValue()
                        )
                        .add(currDependentValue.getValue());
                }
                if ((val & 4) == 4) {
                    controllingInfo.get(
                            controllingValues[baseCount + 1].getValue()
                        )
                        .add(currDependentValue.getValue());
                }
                if ((val & 2) == 2) {
                    controllingInfo.get(
                            controllingValues[baseCount + 2].getValue()
                        )
                        .add(currDependentValue.getValue());
                }
                if ((val & 1) == 1) {
                    controllingInfo.get(
                            controllingValues[baseCount + 3].getValue()
                        )
                        .add(currDependentValue.getValue());
                }

                baseCount += 4;
            }
        }

        return controllingInfo;
    }
    public static List<ContentVersion> insertRecords() {
        // get a map of the category and type labels
        Map<String, List<String>> allCategories = getCategoryTypeDependencies();
        List<ContentVersion> documents = new List<ContentVersion>();
        Integer count = 1;
        for (String category : allCategories.keySet()) {
            List<String> types = allCategories.get(category);
            for (String docType : types) {
                List<Object> parameters = new List<Object>{ count };
                documents.add(
                    new ContentVersion(
                        Title = String.format('TestDocument{0}', parameters),
                        PathOnClient = String.format(
                            'TestDocument{0}.jpg',
                            parameters
                        ),
                        Origin = 'H',
                        VersionData = Blob.valueOf('Document Body'),
                        Category__c = category,
                        Type__c = docType,
                        Date__c = Date.today().addDays(-count)
                    )
                );
                count = count + 1;
            }
        }

        insert documents;

        // We need to do the query here to get the ContentDocumentId's
        documents = [
            SELECT
                Id,
                ContentDocumentId,
                Title,
                PathOnClient,
                Origin,
                VersionData,
                Category__c,
                Type__c,
                Date__c
            FROM ContentVersion
        ];
        return documents;
    }

    // This method is used to setup the getRelatedFilesWith... tests.  The file records have all category/type combinations
    private static RelatedObjects getRelatedFilesWithGroups(string[] groups) {
        TestUtilities.insertCategoryRules();

        List<ContentVersion> documents = insertRecords();

        // Get the ids of all these documents
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : documents) {
            ids.add(cv.ContentDocumentId);
        }
        Contact ronan = new Contact(
            FirstName = 'Ronan',
            LastName = 'Dax',
            email = 'ronan@test.com',
            Positions__c = 'Board Member;Client;Puppy Raiser;Standalone;Staff;Team Facilitator;Team Facilitator Lead;Trainer;Volunteer',
            ShareBoard__c = true,
            SharePuppyRaiser__c = true,
            ShareStaff__c = true,
            ShareStandalonePrograms__c = true,
            ShareTeam__c = true,
            ShareTrainer__c = true,
            ShareVolunteer__c = true
        );
        insert ronan;
        FileController.relateFiles(ids, ronan.Id);

        User testUser = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToGroups(testUser, groups);
        RelatedObjects related = new RelatedObjects();
        Test.startTest();
        System.runAs(new User(Id = testUser.Id)) {
            related = FileController.getRelatedFiles(ronan.Id, 6);
        }
        Test.stopTest();

        return related;
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForAll() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Board', 'Volunteer', 'Trainer' }
        );
        System.assert(related.items.size() < 6);
        System.assertEquals(3, related.total);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForBoard() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Board' }
        );

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals('Board', ((FileInfo) related.items[0]).category);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForVolunteer() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Volunteer' }
        );

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals(
            'Volunteer',
            ((FileInfo) related.items[0]).category
        );
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForStaff() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Trainer' }
        );

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals('Trainer', ((FileInfo) related.items[0]).category);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForNone() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Team' }
        );

        System.assertEquals(0, related.items.size());
        System.assertEquals(0, related.total);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardTrainer() {
        RelatedObjects related = getRelatedFilesWithGroups(
            new List<string>{ 'Board', 'Trainer' }
        );

        System.assertEquals(2, related.items.size());
        System.assertEquals(2, related.total);
    }
}
