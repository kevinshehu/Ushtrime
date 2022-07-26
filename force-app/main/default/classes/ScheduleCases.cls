public with sharing class ScheduleCases {
  public void execute(SchedulableContext sc) {
    List<Case> caseList = [
      SELECT AccountId, Status, NumberOfDaysSinceUpdate__c
      FROM Case
      WHERE Status = 'Closed' AND NumberOfDaysSinceUpdate__c > 7
    ];

    for (Case temp : caseList) {
      delete caseList;
    }
  }
}
