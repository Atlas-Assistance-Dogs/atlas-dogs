

test_template = '''
    @isTest
    public static void updateDate_{category}{type}_SetsDateWhenNull() {{
        {object} record = new {object}({object_fields});
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
        {object} record = new {object}({object_fields}, {field} = Date.today().addDays(-1));
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
        {object} record = new {object}({object_fields}, {field} = Date.today());
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

test_file_start = '''@isTest
public with sharing class TestFileService{category}Fields {{

'''

new_dog = "Name = 'Fido'"

new_contact = "FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com'"


class CategoryType:
    """Create code to update or test a category/type"""
    category = ''
    doc_type = 'ContactForm'
    name = 'contact'
    field = ''
    object = 'Contact'
    fields = new_contact

    def __init__ (self, cat, typ):
        self.category = cat
        self.doc_type = typ
        self.fields = new_contact

        if cat == 'Dog':
            self.name = 'dog'
            self.field = typ + 'Received__c'
            self.object = 'Dog__c'
            self.fields = new_dog

        elif typ == 'ContactForm':
            self.name = 'contact'
            self.field = typ + 'Received__c'
            self.object = 'Contact'

        else:
            self.name = 'contact'
            self.field = cat + typ + 'Received__c'
            self.object = 'Contact'

    def code(self):
        template = '''
        if (cv.Type__c == '{type}' && isLater({object}.{field}, cv.Date__c)){{
            {object}.{field} = cv.Date__c;
        }}
'''
        return template.format(field = self.field, type = self.doc_type, object = self.name)

    def test(self):
        return test_template.format(category = self.category, type = self.doc_type, field = self.field, object_fields = self.fields, object = self.object)

class Category:
    '''Class to generate test code for all types for a category'''
    category = ''
    types = []
    name = 'contact'
    object = 'Contact'

    def __init__(self, cat, types):
        self.category = cat
        self.types = [CategoryType(cat, typ) for typ in sorted(types)]
        if cat == 'Dog':
            self.name = 'dog'
            self.object = 'Dog__c'

    def check(self):
        template = '''        
            if (cv.Category__c == '{category}'){{
                update{category}Date(cv, {name});
            }}
'''
        return template.format(category = self.category, name = self.name)


    def method(self):
        template = '''
    // Update the last date when the category is {category}
    private static void update{category}Date(ContentVersion cv, {object} {name}) {{
'''
        definition = template.format(category = self.category, object = self.object, name = self.name)
        types = [typ.code() for typ in self.types if typ.doc_type != 'ContactForm']
        end = '    }\n'
        return definition + ''.join(types) + end


    def test(self, test_file):
        test_file.write(test_file_start.format(category = self.category))
        for typ in self.types:
            test_file.write(typ.test())
        test_file.write('}')
