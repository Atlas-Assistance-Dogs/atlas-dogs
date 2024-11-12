public inherited sharing class EmailService {
    public EmailService() {
    }

    public ID getOrgEmailAddressId() {
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        String emailName = settings.OrgWideEmailName__c;
        if (emailName == null) {
            settings.OrgWideEmailName__c = 'Atlas Assistance Dogs';
            upsert settings;
        }
        Id addressId = null;
        OrgWideEmailAddress[] addresses = [
            SELECT Id
            FROM OrgWideEmailAddress
            WHERE DisplayName = :emailName
        ];
        if (addresses.size() > 0) {
            addressId = addresses[0].Id;
        }
        return addressId;
    }
    public EmailTemplate getTemplate(String name) {
        EmailTemplate__mdt et = EmailTemplate__mdt.getInstance(name);
        EmailTemplate template = [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = :et.Template__c
        ];
        return template;
    }
    public void sendEmail(List<Messaging.SingleEmailMessage> emails){
        Messaging.sendEmail(emails);
    }
}