@isTest
global class CasesCalloutsMock implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(
      '{"Name":"Test Case","Source": "External", "Description":"PROBLEM!!!", "Language":"English"}'
    );
    res.setStatusCode(200);
    return res;
  }
}
