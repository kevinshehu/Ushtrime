public with sharing class AccountTriggerHandler implements Database.Batchable<User> {
  public List<User> start(Database.BatchableContext BC) {
    List<User> userList = [SELECT Id, Email FROM User WHERE Alias = 'KSheh'];
    return userList;
  }

  public void execute(Database.BatchableContext bc, List<User> userList) {
    List<Messaging.Email> emailList = new List<Messaging.Email>();
    Id senderId = [SELECT Id FROM OrgWideEmailAddress LIMIT 1].Id;

    for (User temporary : userList) {
      if (temporary.Email != null) {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        String[] toAddress = new List<String>{ temporary.Email };
        emailMessage.setToAddresses(toAddress);

        String emailSub = 'Currency Amount changed.';
        emailMessage.setSubject(emailSub);

        String disname = 'Kevin Shehu';
        //emailMessage.setSenderDisplayName(disname);

        String content =
          'Currency of the account with ID: ' +
          temporary.Id +
          ' changed!';
        emailMessage.setHtmlBody(content);

        emailMessage.setOrgWideEmailAddressId(senderId);

        emailList.add(emailMessage);
      }
    }

    System.debug('emails to be sent >> ' + emailList);
    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
    System.debug('email results >> ' + results);
  }

  public void finish(Database.BatchableContext bc) {
    System.debug('End.');
  }
}
