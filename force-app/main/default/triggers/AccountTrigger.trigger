trigger AccountTrigger on Account(after update) {
  Map<Id, Account> oldAcc = Trigger.oldMap;

  for (Account acc : Trigger.new) {
    if (
      acc.Total_Account_Turnover__c !=
      oldAcc.get(acc.Id).Total_Account_Turnover__c
    ) {
      AccountTriggerHandler myBatchObject = new AccountTriggerHandler();
      Id batchId = Database.executeBatch(myBatchObject, 30);
    }
  }
}
