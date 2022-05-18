

contact_fields = {
        'Dog': ['HealthFormReceived__c', 'VacExamsReceived__c', 'XrayReceived__c'],
    'ADSiM': ['ADSiMApplicationReceived__c',
            'ADSiMPreApplicationReceived__c',
            'ADSiMProgAgreementReceived__c',
            'ContactFormReceived__c'],
    'Board': ['BoardAgreementReceived__c',
            'BoardApplicationReceived__c',
            'BoardCoIReceived__c',
            'BoardResumeReceived__c',
            'BoardToNReceived__c',
            'ContactFormReceived__c'],
    'Client': ['ClientApplicationReceived__c',
            'ClientCertAgreementReceived__c',
            'ClientLOMIReceived__c',
            'ClientPreApplicationReceived__c',
            'ClientProgAgreementReceived__c',
            'ClientSurveyReceived__c',
            'ClientVAPWReceived__c',
            'ContactFormReceived__c'],
    'Facilitator': ['FacilitatorApplicationReceived__c',
            'FacilitatorCertAgreementReceived__c',
            'FacilitatorInfrNoticeReceived__c',
            'FacilitatorPracticumReceived__c',
            'FacilitatorProfGrowthPlanReceived__c',
            'FacilitatorProgAgreementReceived__c',
            'FacilitatorReferenceReceived__c',
            'ContactFormReceived__c'],
    'Puppy': ['PuppyApplicationReceived__c',
            'PuppyCertAgreementReceived__c',
            'PuppyInfrNoticeReceived__c',
            'PuppyProgAgreementReceived__c',
            'PuppyReferenceReceived__c',
            'ContactFormReceived__c'],
    'Staff': ['StaffAgreementReceived__c',
            'StaffApplicationReceived__c',
            'StaffI9Received__c',
            'StaffOfferReceived__c',
            'StaffResumeReceived__c',
            'StaffW4Received__c',
            'ContactFormReceived__c'],
    'TSiM': ['TSiMApplicationReceived__c',
            'TSiMProgAgreementReceived__c',
            'ContactFormReceived__c'],
    'Trainer': ['TrainerApplicationReceived__c',
            'TrainerCertAgreementReceived__c',
            'TrainerInfrNoticeReceived__c',
            'TrainerProgAgreementReceived__c',
            'TrainerReferenceReceived__c',
            'ContactFormReceived__c'],
    'Volunteer': ['VolunteerAgreementReceived__c',
            'VolunteerApplicationReceived__c',
            'VolunteerResumeReceived__c',
            'ContactFormReceived__c']}

new_dog = "Name = 'Fido'"

new_contact = "FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com'"

template = '''
    @isTest
    public static void updateDate_{category}{type}_SetsDateWhenNull() {{
        {object} record = new {object}({object_fields});
        insert record;
        ContentVersion cv = createLink('{category}', '{type}', Date.today(), record.Id);
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
        ContentVersion cv = createLink('{category}', '{type}', Date.today(), record.Id);
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
        ContentVersion cv = createLink('{category}', '{type}', Date.today(), record.Id);
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

test_file = open('TestFileServiceFields.cls', 'w')

test_file.write('''@isTest
public with sharing class TestFileServiceFields {
    private static ContentVersion createLink(
        string category,
        string type,
        Date docDate,
        Id recordId
    ) {
        ContentVersion cv = new ContentVersion(
            Title = 'Test Category Type',
            PathOnClient = 'TestDocument3.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 3'),
            Category__c = category,
            Type__c = type,
            Date__c = docDate
        );
        insert cv;

        ContentVersion temp = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = temp.ContentDocumentId,
            LinkedEntityId = recordId
        );
        insert link;

        return cv;
    }

''')

for category, fields in contact_fields.items():
    for field in fields:
        doc_type = field.replace(category, '').replace('Received__c', '')
        if category == 'Dog':
                object_fields = new_dog
                name = 'Dog__c'
        else:
                object_fields = new_contact
                name = 'Contact'

        test_file.write(template.format(category = category, type = doc_type, field = field, object_fields = object_fields, object = name))

test_file.write('}')
test_file.close()
