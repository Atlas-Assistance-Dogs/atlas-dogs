public inherited sharing class MockEmailService implements IEmailService {
    public MockEmailService() {

    }

    public EmailTemplate getTemplate(String name) {
        EmailTemplate template = new EmailTemplate(
            Id = 'templateId',
            Name = name
        );
        return template;
    }

    public final List<Messaging.SingleEmailMessage> sentEmails = new List<Messaging.SingleEmailMessage>();

    public void sendEmail(List<Messaging.SingleEmailMessage> emails){
        sentEmails.addAll(emails);
    }
}