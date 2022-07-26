public with sharing class OpportunityCallout {
  public static HttpResponse makePostCallout() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://www.test.com');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');

    HttpResponse response = http.send(request);

    // Parse the JSON response
    if (response.getStatusCode() == 201) {
      Opportunity opp = new Opportunity();

      Map<String, Object> results = (Map<String, Opportunity>) JSON.deserializeUntyped(
        response.getBody()
      );

      List<Object> oppList = (List<Object>) results.get('opp');

      System.debug(oppList);
    } else {
      System.debug(
        'The status code returned was not expected: ' +
        response.getStatusCode() +
        ' ' +
        response.getStatus()
      );
    }
    return response;
  }
}
