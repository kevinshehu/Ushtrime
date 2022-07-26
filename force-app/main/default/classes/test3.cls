public with sharing class test3 {
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContactList() {
    try {
      return [SELECT Id, Name, Email FROM Contact LIMIT 100];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
