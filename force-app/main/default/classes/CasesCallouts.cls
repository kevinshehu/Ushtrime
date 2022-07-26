public with sharing class CasesCallouts {
  @future(callout=true)
  public static void makeCallout(Date fromdate, Date todate) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();

    String endpoint =
      'https://www.test.com?FROM=' +
      String.valueOf(fromdate) +
      '&TO=' +
      String.valueOf(todate);
    request.setEndPoint(endpoint);
    request.setMethod('GET');

    HttpResponse response = new HTTP().send(request);
    System.debug('>> Response: ' + response);

    List<Case> caseList = new List<Case>();

    if (response.getStatusCode() == 200) {
      List<Object> results = (List<Object>) JSON.deserializeUntyped(
        response.getBody()
      );

      for (Object i : results) {
        Map<String, Object> j = (Map<String, Object>) i;
        Case newCase = new Case();
        newCase.Name__c = (String) j.get('Name');
        newCase.Source__c = (String) j.get('Source');
        newCase.Description = (String) j.get('Description');
        newCase.Language__c = (String) j.get('Language');
        caseList.add(newCase);
      }
      upsert caseList;
    } else {
      throw new CalloutException('ERROR!');
    }
  }
}
