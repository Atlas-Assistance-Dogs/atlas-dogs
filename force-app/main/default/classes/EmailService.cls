public inherited sharing class EmailService implements IEmailService {
    public EmailService() {
        
    }
    
    public EmailTemplate getTemplate(String name) {
        EmailTemplate template = [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = :name
        ];
        return template;
    }
    
    public void sendEmail(List<Messaging.SingleEmailMessage> emails){
        Messaging.sendEmail(emails);
    }
}