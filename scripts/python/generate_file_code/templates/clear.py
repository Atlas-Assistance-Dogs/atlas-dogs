# Templates for generating code to clear Last* dates

contact_code_start = '''
    private static void clearContactDate(ContentVersion cv, Id recordId) {
        if (cv.Category__c == 'Standalone') return;
 
        string field;
        if (cv.Type__c == 'ContactForm') {
            field = 'ContactFormReceived__c';
        }
        else {
            field = string.format('{0}{1}Received__c', new List<Object>{ cv.Category__c, cv.Type__c.replace(' ', '') });
        }
        string query = string.format('SELECT Id, {0} FROM Contact WHERE Id = :recordId', new List<Object>{ field });
        List<Contact> contacts = Database.query(query);

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
    private static void clearDogDate(ContentVersion cv, Id recordId) {
        string  field = string.format('{0}Received__c', new List<Object>{ cv.Type__c.replace(' ', '') });
        string query = string.format('SELECT Id, {0} FROM Dog__c WHERE Id = :recordId', new List<Object>{ field });
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
'''
"""Start of the dog ClearDateService code."""

dog_code_end = '''
        update dog;
    }
'''

test_template = '''
    @isTest
    public static void clearDate_{category}{type}_SetsDateToNull() {{
        ContentVersion cv = new ContentVersion(Category__c = '{category}', Type__c = '{type}');
        {object} record = new {object}({object_fields});
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