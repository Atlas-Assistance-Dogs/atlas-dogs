## Script to update test files for the FileService class.  This needs to be run in the root directory of the project.
import shutil
from xml.dom import minidom
  
doc = minidom.parse("force-app/main/default/objects/ContentVersion/fields/Type__c.field-meta.xml")
  
setting_elements = doc.getElementsByTagName("valueSettings")
settings = {}
for setting in setting_elements:
    name = setting.getElementsByTagName("valueName")[0].firstChild.data
    categories = setting.getElementsByTagName("controllingFieldValue")
    for category_element in categories:
        category = category_element.firstChild.data
        if category in settings:
            settings[category].append(name)
        else:
            settings[category] = [name]

new_dog = "Name = 'Fido'"

new_contact = "FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com'"

template = '''
    @isTest
    public static void updateDate_{category}{type}_SetsDateWhenNull() {{
        {object} record = new {object}({object_fields});
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('{category}', '{type}', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = TestFileServiceFields.createLink('{category}', '{type}', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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

base_file = 'force-app/main/test/TestFileService[]Fields.cls'

test_file_start = '''@isTest
public with sharing class TestFileService[]Fields {

'''
meta_path = 'force-app/main/test/TestFileServiceFields.cls-meta.xml'

for category, types in settings.items():
    if category == 'Standalone':
        continue

    test_file = open(base_file.replace('[]', category), 'w')
    test_file.write(test_file_start.replace('[]', category))

    for doc_type in types:
        if category == 'Dog':
            field = doc_type + 'Received__c'
            object_fields = new_dog
            name = 'Dog__c'
        elif doc_type == 'ContactForm':
            field = doc_type + 'Received__c'
            object_fields = new_contact
            name = 'Contact'
        else:
            field = category + doc_type + 'Received__c'
            object_fields = new_contact
            name = 'Contact'

        test_file.write(template.format(category = category, type = doc_type, field = field, object_fields = object_fields, object = name))

    test_file.write('}')
    test_file.close()

    ## make sure there is a meta file for the test class

    shutil.copy(meta_path, meta_path.replace('Fields', category + 'Fields')) #copy the file to destination dir

