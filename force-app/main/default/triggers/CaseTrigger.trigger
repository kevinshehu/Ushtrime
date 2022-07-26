trigger CaseTrigger on Case(before update, before insert) {
  for (Case temporary : Trigger.new) {
    temporary.LastUpdated__c = Date.today();
  }
}
