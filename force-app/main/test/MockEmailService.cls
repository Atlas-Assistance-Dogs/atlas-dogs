public inherited sharing class MockEmailService implements IEmailService {
    public MockEmailService() {

    }
    public String templateId {get; set;}

    public EmailTemplate getTemplate(String name) {
        EmailTemplate template = new EmailTemplate(
            Id = templateId,
            Name = name,
            Body = 'Here we go round the mulberry bush'
        );
        return template;
    }

    public final List<Messaging.SingleEmailMessage> sentEmails = new List<Messaging.SingleEmailMessage>();

    public void sendEmail(List<Messaging.SingleEmailMessage> emails){
        sentEmails.addAll(emails);
    }
}