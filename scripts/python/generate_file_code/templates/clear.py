# Templates for generating code to clear Last* dates

contact_code_start = '''
    private static void clearContactDate(ContentVersion cv, Id recordId) {{
        List<Contact> contacts = [
            SELECT Id,
                {fields}
            FROM Contact
            WHERE Id = :recordId];

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
'''

contact_code_end = '''
        if (cv.Type__c == 'ContactForm'){
            contact.ContactFormReceived__c = null;
        }
        update contact;
    }
'''


dog_code_start = '''
    private static void clearDogDate(ContentVersion cv, Id recordId) {{
        List<Dog__c> dogs = [
            SELECT Id, {fields}
            FROM Dog__c
            WHERE Id = :recordId];

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
'''
"""Start of the dog ClearDateService code."""

dog_code_end = '''
        update dog;
    }
'''


team_code_start = '''
    private static void clearTeamDate(ContentVersion cv, Id recordId) {{
        List<Team__c> teams = [
            SELECT Id, Client__c, Dog__c,
                   {fields}
            FROM Team__c
            WHERE Id = :recordId];

        if (teams.size() == 0)
            return;
        Team__c team = teams[0];
'''
"""Start of the team ClearDateService code."""

team_code_end = '''
        update team;
    }
'''

test_template = '''
    @isTest
    public static void clearDate_{category}{type}_SetsDateToNull() {{
        ContentVersion cv = new ContentVersion(Category__c = '{category}', Type__c = '{type}');
        {setup}{object} record = new {object}({object_fields});
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT {field}
            FROM {object}
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.{field},
            '{field} not cleared'
        );
    }}
'''

test_file_start = '''@isTest
public with sharing class TestClearDateService{category}Fields {{
'''