@isTest
private class TestContactController {
    @isTest
    public static void getContacts() {
        Test.startTest();

        PagedResult res = ContactController.getPagedContacts('Test', 1);
        System.assertEquals(res.records.size(), 2);

        List<Contact> conList2 = ContactController.getContactsByName('Test');
        System.assertEquals(conList2.size(), 2);

        List<Contact> conList3 = ContactController.getContactsWithPosition(
            'Trainer'
        );
        System.assertEquals(conList3.size(), 2);

        Test.stopTest();
    }

    @TestSetup
    static void makeData() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        List<Contact> conLst = new List<Contact>();

        Contact con = new Contact();

        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'abc@abc.com';
        con.Positions__c = 'Trainer;Client';

        conLst.add(con);

        Contact con2 = new Contact();

        con2.FirstName = 'Client';
        con2.LastName = 'TestData';
        con2.Email = 'abcde@abc.com';
        con2.Positions__c = 'Trainer;Volunteer';

        conLst.add(con2);

        insert conLst;
    }
}
