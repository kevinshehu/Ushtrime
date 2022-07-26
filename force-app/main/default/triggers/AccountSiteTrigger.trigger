trigger AccountSiteTrigger on Account_Site__c(after insert, after update) {
  List<Account_Site__c> accountSiteList = Trigger.new;

  Set<Id> accountIds = new Set<Id>();
  Set<Id> siteIds = new Set<Id>();

  for (Account_Site__c temporary : accountSiteList) {
    accountIds.add(temporary.Account_name__c);
    siteIds.add(temporary.Site_Name__c);
  }

  Map<Id, Site__c> sites = new Map<Id, Site__c>(
    [SELECT Id, Active__c FROM Site__c WHERE Id IN :siteIds]
  );

  Map<Id, Account> accountMap = new Map<Id, Account>(
    [SELECT Id, Total_Account_Turnover__c FROM Account WHERE Id IN :accountIds]
  );

  List<User> userList = [SELECT Id, Email FROM User];

  if (Trigger.isAfter && Trigger.isUpdate) {
    Map<Id, Account_site__c> oldAccSites = Trigger.oldMap;

    for (Account_site__c accS : accountSiteList) {
      System.debug('on iteration with account ' + accS);
      if (
        accS.Turnover_Amount__c != oldAccSites.get(accS.Id).Turnover_Amount__c
      ) {
        if (sites.get(accS.Site_Name__c).Active__c) {
          if (
            accountMap.get(accS.Account_name__c).Total_Account_Turnover__c ==
            null
          ) {
            accountMap.get(accS.Account_name__c)
              .Total_Account_Turnover__c = accS.Turnover_Amount__c;
          } else {
            accountMap.get(accS.Account_name__c).Total_Account_Turnover__c +=
              accS.Turnover_Amount__c -
              oldAccSites.get(accS.Id).Turnover_Amount__c;
          }
        }
      }
    }
    System.debug('after for');
    update accountMap.values();
  } else if (Trigger.isAfter && Trigger.isInsert) {
    for (Account_site__c accS : accountSiteList) {
      if (sites.get(accS.Site_Name__c).Active__c) {
        if (
          accountMap.get(accS.Account_name__c).Total_Account_Turnover__c == null
        ) {
          accountMap.get(accS.Account_name__c)
            .Total_Account_Turnover__c = accS.Turnover_Amount__c;
        } else {
          accountMap.get(accS.Account_name__c)
            .Total_Account_Turnover__c += accS.Turnover_Amount__c;
        }
      }
    }

    update accountMap.values();
  }
}
