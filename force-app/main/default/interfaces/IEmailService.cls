public interface IEmailService {
    EmailTemplate getTemplate(String name);
    void sendEmail(List<Messaging.SingleEmailMessage> messages);
}