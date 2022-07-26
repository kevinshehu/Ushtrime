// Test methods per triggerin e Account Total Turnover Amount

@isTest
public with sharing class AccountSiteTest {
  @TestSetup
  static void makeData() {
    // User userA = TestFactory.createUser('System Administrator', '', true);
  }

  @istest
  public static void positive() {
    // create new account
    User userA = TestFactory.createUser('System Administrator', '', true);

    Account account = new Account(Name = 'Test Account');
    insert account;

    // // create new site
    // Site__c site = new Site__c(Name = 'Test Site', Active__c = true);
    // insert site;

    // Account_Site__c accountSite1 = new Account_Site__c(
    //   Name = 'Account Site 1',
    //   Account_name__c = account.id,
    //   Site_name__c = site.id,
    //   Turnover_Amount__c = 100
    // );

    // Account_Site__c accountSite2 = new Account_Site__c(
    //   Name = 'Account Site 2',
    //   Account_name__c = account.id,
    //   Site_name__c = site.id,
    //   Turnover_Amount__c = 500
    // );

    // List<Account_Site__c> accSiteList = new List<Account_Site__c>{
    //   accountSite1,
    //   accountSite2
    // };

    // Test.startTest();
    // // trigger insert event
    // insert accSiteList;
    // Test.stopTest();

    // List<Account> accountD = [
    //   SELECT Name, Total_Account_Turnover__c
    //   FROM Account
    //   LIMIT 1
    // ];
    // List<Site__c> siteD = [SELECT Name, Active__c FROM Site__c LIMIT 1];
    // List<Account_Site__c> accountSiteD = [
    //   SELECT Name, Account_name__c, Site_name__c, Turnover_Amount__c
    //   FROM Account_Site__c
    //   LIMIT 2
    // ];

    // // check account
    // System.assertEquals('Test Account', accountD[0].Name, '');
    // System.assertEquals(
    //   600,
    //   accountD[0].Total_Account_Turnover__c,
    //   'Total Turnover incorrect.'
    // );

    // // check site
    // System.assertEquals('Test Site', siteD[0].Name, '');
    // System.assertEquals(true, siteD[0].Active__c, '');

    // // check account site 1
    // System.assertEquals('Account Site 1', accountSiteD[0].Name, '');
    // System.assertEquals(accountD[0].Id, accountSiteD[0].Account_name__c, '');
    // System.assertEquals(siteD[0].Id, accountSiteD[0].Site_name__c, '');
    // System.assertEquals(100, accountSiteD[0].Turnover_Amount__c, '');

    // // check account site 2
    // System.assertEquals('Account Site 2', accountSiteD[1].Name, '');
    // System.assertEquals(accountD[0].Id, accountSiteD[0].Account_name__c, '');
    // System.assertEquals(siteD[0].Id, accountSiteD[0].Site_name__c, '');
    // System.assertEquals(500, accountSiteD[1].Turnover_Amount__c, '');
  }

  @istest
  public static void negative() {
    // create new account
    Account account = new Account(
      Name = 'Test Account',
      Total_Account_Turnover__c = null
    );
    insert account;
    Account account2 = new Account(
      Name = 'Test Account 2',
      Total_Account_Turnover__c = null
    );
    insert account2;

    // create new site
    Site__c site = new Site__c(Name = 'Test Site', Active__c = true);
    insert site;

    Account_Site__c accountSite1 = new Account_Site__c(
      Name = 'Account Site 1',
      Account_name__c = account.id,
      Site_name__c = site.id,
      Turnover_Amount__c = 100
    );

    Account_Site__c accountSite2 = new Account_Site__c(
      Name = 'Account Site 2',
      Account_name__c = account.id,
      Site_name__c = site.id,
      Turnover_Amount__c = 500
    );

    Account_Site__c accountSite3 = new Account_Site__c(
      Name = 'Account Site 3',
      Account_name__c = account2.id,
      Site_name__c = site.id,
      Turnover_Amount__c = null
    );

    List<Account_Site__c> accSiteList = new List<Account_Site__c>{
      accountSite1,
      accountSite2,
      accountSite3
    };
    insert accSiteList;

    // trigger update event
    accountSite2.Turnover_Amount__c = 50;
    accountSite3.Turnover_Amount__c = 50;

    Test.startTest();
    update accSiteList;
    System.debug(accSiteList);
    Test.stopTest();

    List<Account> accountD = [
      SELECT Name, Total_Account_Turnover__c
      FROM Account
      ORDER BY Name
    ];
    List<Site__c> siteD = [SELECT Name, Active__c FROM Site__c LIMIT 1];
    List<Account_Site__c> accountSiteD = [
      SELECT Name, Account_name__c, Site_name__c, Turnover_Amount__c
      FROM Account_Site__c
      LIMIT 2
    ];

    //check account site
    System.assert(
      accountSiteD[0].Turnover_Amount__c > 0,
      'Turnover amount should be positive.'
    );
    System.assert(
      accountSiteD[1].Turnover_Amount__c > 0,
      'Turnover amount should be positive.'
    );

    System.assert(siteD[0].Active__c == true, 'Site must be active.');

    System.assert(
      accountD[0].Total_Account_Turnover__c == 150,
      'Invalid update.'
    );
    System.assert(
      accountD[1].Total_Account_Turnover__c == 50,
      'Invalid update.'
    );

    System.assert(
      accountD[0].Total_Account_Turnover__c != null,
      'Can not be null.'
    );
  }

  @istest
  public static void bulkTest() {
    Account account = new Account(Name = 'Test Account');
    insert account;

    List<Site__c> siteList = new List<Site__c>();
    for (Integer i = 0; i < 300; i++) {
      siteList.add(new Site__c(Name = 'Test Site', Active__c = true));
    }
    insert siteList;

    List<Account_Site__c> accountSiteList = new List<Account_Site__c>();
    for (Integer i = 0; i < 300; i++) {
      accountSiteList.add(
        new Account_Site__c(
          Name = 'Account Site Test',
          Account_name__c = account.id,
          Site_name__c = siteList[i].id,
          Turnover_Amount__c = 5
        )
      );
    }
    insert accountSiteList;

    // trigger event
    for (Account_Site__c temporary : accountSiteList) {
      temporary.Turnover_Amount__c = 100;
    }

    Test.startTest();
    update accountSiteList;
    Test.stopTest();

    List<Site__c> siteD = [SELECT Name, Active__c FROM Site__c];
    List<Account_Site__c> accountSiteD = [
      SELECT Name, Account_name__c, Site_name__c, Turnover_Amount__c
      FROM Account_Site__c
    ];

    System.assertEquals(300, accountSiteD.size(), '');
    System.assertEquals(
      30000,
      [SELECT Total_Account_Turnover__c FROM Account LIMIT 1]
      .Total_Account_Turnover__c
    );
  }
}
