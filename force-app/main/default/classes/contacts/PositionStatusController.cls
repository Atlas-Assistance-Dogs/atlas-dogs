global with sharing class PositionStatusController {
  global final static String[] POSITION_LIST = ContactService.POSITION_LIST;

  @AuraEnabled(Cacheable=true)
  global static List<PositionStatus> getPositionStatusForContact(Id contactId) {
    ContactService contactService = new ContactService();
    return contactService.getPositionStatusForContact(contactId);
  }
}
