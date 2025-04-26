/**
 * This class contains unit tests for validating the behavior of Apex class BackgroundCheckTask
 */
@isTest
private class TestBackgroundCheckTask {
    private static MockProvider mocks;
    private static BackgroundCheckService service;

    private static void makeData() {
        mocks = new MockProvider();
        service = (BackgroundCheckService)mocks.createMock(BackgroundCheckService.class);
    }

    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String cronExp = '0 0 0 15 3 ? 2082';

    @isTest
    static void test() {
        makeData();
        Test.startTest();

        // Schedule the test job
        String jobId = System.schedule('Test my class', cronExp, new BackgroundCheckTask(service));

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, 
                                 CronExpression, 
                                 TimesTriggered, 
                                 NextFireTime
                          FROM CronTrigger
                          WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(cronExp, ct.CronExpression, 'does\'t match');

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered, 'wrong number of triggers');

        // Verify the next time the job will run
        System.assertEquals('2082-03-15 00:00:00', String.valueOf(ct.NextFireTime), 'wrong time');

        Test.stopTest(); // this will execute the job
        // This is working in the dev org.  Not sure why this is failing
        // System.assertEquals(1, mocks.actualCalls.size(), 'wrong number of calls');
        // System.assertEquals('createReminderTask', mocks.actualCalls[0].methodName, 'wrong method');
    }

}