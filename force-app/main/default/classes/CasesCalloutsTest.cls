@isTest
public class CasesCalloutsTest {
  @isTest
  static void testCaseCallout() {
    Test.setMock(HttpCalloutMock.class, new CasesCalloutsMock());

    Test.startTest();
    CasesCallouts.makeCallout(System.today(), System.today());
    Test.stopTest();

    List<Case> caseList = [
      SELECT Name__c, Source__c, Description, Language__c
      FROM Case
    ];

    System.assertEquals(1, caseList.size());
    System.assertEquals('Test Case', caseList[0].Name__c);
  }
}
