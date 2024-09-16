@IsTest
private class TestLogs {
    // test that generating a new instance works
    // this will fail if the Custom Metadata records have not been setup
    @IsTest
    static void newInstanceTest() {
        ILogs instanceByIds = Logs.newInstance(
            new Set<Id>{ fflib_IDGenerator.generate(Log__c.SObjectType) }
        );
        ILogs instanceByRecords = Logs.newInstance(new List<Log__c>());
    }

    @IsTest
    static void insertAndUpdateOnRecords() {
        // Test insert, update and delete fires off triggers properly
       /* List<Log__c> Logs = new List<Log__c>{
            GenericTestFactory.createLog(),
            GenericTestFactory.createLog(),
            GenericTestFactory.createLog()
        };
        insert Logs;
        update Logs;
        delete Logs;*/
    }

    @IsTest
    static void validateUserSsoTest() {
        // TODO: mock selector and/or service methods before running the domain class method
     /*   List<Log__c> Logs = new List<Log__c>{
            GenericTestFactory.createLog(),
            GenericTestFactory.createLog(),
            GenericTestFactory.createLog()
        };

        ILogs LogsDomain = (ILogs) Application.Domain.newInstance(Logs);
        LogsDomain.validateUserSso();*/
    }
}
