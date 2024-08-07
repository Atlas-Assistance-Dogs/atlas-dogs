## Templates for updating the Last* file date and testing the code.

contact_code_start = '''
    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDates(List<ContentVersion> cvs, Id recordId) {{
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {{
            ids.add(cv.Id);
        }}
        List<Contact> contacts = [
            SELECT Id,
                {fields}
            FROM Contact
            WHERE Id = :recordId
        ];

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the Date, order asc so we update the field with the last received
        cvs = [
            SELECT Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id IN :ids
            ORDER BY Date__c
        ];

        for (ContentVersion cv : cvs) {{'''

contact_code_end = '''        }
        update contact;
    }
'''

dog_code_start = '''
    // Update the last received docDate for the dog for the document type
    private static void updateDogDates(List<ContentVersion> cvs, Id recordId) {{
        // this is related to a dog
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {{
            ids.add(cv.Id);
        }}
        List<Dog__c> dogs = [
            SELECT Id, {fields}
            FROM Dog__c
            WHERE Id = :recordId
        ];

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c
               FROM ContentVersion
               WHERE Id IN :ids
               ORDER BY Date__c
        ];

        //#region Generated dog
        for (ContentVersion cv : cvs) {{
'''
"""Start of the dog FileService code."""

dog_code_end = '''        }
        update dog;
    }
'''

team_code_start = '''
    // Update the last received docDate for the team for the document type
    private static void updateTeamDates(List<ContentVersion> cvs, Id recordId) {{
        // this is related to a team
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {{
            ids.add(cv.Id);
        }}
        List<Team__c> teams = [
            SELECT Id, Client__c, Dog__c,
                    {fields}
            FROM Team__c
            WHERE Id = :recordId
        ];

        if (teams.size() == 0)
            return;
        Team__c team = teams[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c, ContentDocumentId
               FROM ContentVersion
               WHERE Id IN :ids
               ORDER BY Date__c
        ];

        //#region Generated team
        for (ContentVersion cv : cvs) {{
'''
"""Start of the team FileService code."""

team_code_end = '''        }
        update team;
    }
'''

test_template = '''
    @isTest
    public static void updateDate_{category}{type}_SetsDateWhenNull() {{
        {setup}{object} record = new {object}({object_fields});
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('{category}', '{type}', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT {field}
            FROM {object}
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.{field},
            '{field} not set'
        );
    }}

    @isTest
    public static void updateDate_{category}{type}_SetsDateWhenNewer() {{
        {setup}{object} record = new {object}({object_fields}, {field} = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('{category}', '{type}', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT {field}
            FROM {object}
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.{field},
            '{field} not set'
        );
    }}

    @isTest
    public static void updateDate_{category}{type}_LeavesDateWhenOlder() {{
        {setup}{object} record = new {object}({object_fields}, {field} = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('{category}', '{type}', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT {field}
            FROM {object}
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.{field},
            '{field} set to an older date'
        );
    }}
'''

test_team_setup_method = '''    private static Dog__c dog;
    private static Contact client;

    private static void createTeamMembers() {
        dog = new Dog__c(Name = 'Fido');
        insert dog;

        client = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert client;
    }
'''

test_team_setup = '''createTeamMembers();
        '''

test_file_start = '''@isTest
public with sharing class TestFileService{category}Fields {{

'''
