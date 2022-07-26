@isTest
public with sharing class ScheduleCasesTest {
  @isTest
  public static void insertTest() {
    Case c1 = new Case(AccountId = '0017Q00000Mus7SQAR', Status = 'Closed');

    Test.startTest();
    insert c1;
    Test.stopTest();

    Case caseD = [SELECT NumberOfDaysSinceUpdate__c FROM Case];

    System.assertEquals(0, caseD.NumberOfDaysSinceUpdate__c);
  }

  @isTest
  public static void updateTest() {
    Case c1 = new Case(AccountId = '0017Q00000Mus7SQAR', Status = 'Open');
    insert c1;

    c1.Status = 'Closed';

    Test.startTest();
    update c1;
    Test.stopTest();

    Case caseD = [SELECT LastUpdated__c, NumberOfDaysSinceUpdate__c FROM Case];

    System.assertEquals(0, caseD.NumberOfDaysSinceUpdate__c);
    System.assertEquals(system.today(), caseD.LastUpdated__c);
  }

  @isTest
  public static void bulkTest() {
    for (Integer i = 0; i < 300; i++) {
      Case c = new Case(AccountId = '0017Q00000Mus7SQAR', Status = 'Closed');
    }

    List<Case> caseList = [SELECT NumberOfDaysSinceUpdate__c FROM Case];

    for (Case temp : caseList) {
      System.assertEquals(
        0,
        temp.NumberOfDaysSinceUpdate__c,
        'Value should be 0.'
      );
    }
  }
}
