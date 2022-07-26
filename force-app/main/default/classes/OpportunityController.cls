public with sharing class OpportunityController extends Exception {
  public OpportunityController() {
  }

  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getOpportunitiesList() {
    try {
      return [
        SELECT AccountId, Name, ExpectedRevenue, DaysSinceCreated__c, StageName
        FROM Opportunity
        WHERE StageName = 'Value Proposition' AND DaysSinceCreated__c < 30
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static Id createNewTask(
    String subject,
    String status,
    String priority,
    String OwnerId,
    String RelatedTo
  ) {
    try {
      if (!(subject != null && status != null)) {
        // throw Exception('Error');
      }

      Task newTask = new Task();
      newTask.Subject = subject;
      newTask.Status = status;
      newTask.Priority = priority;
      newTask.OwnerId = OwnerId;
      newTask.WhatId = RelatedTo;
      insert newTask;
      return newTask.Id;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static Map<String, String> getStatusFieldValues() {
    try {
      Map<String, String> options = new Map<String, String>();
      Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
      List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
      for (Schema.PicklistEntry p : pValues) {
        options.put(p.getValue(), p.getLabel());
      }
      return options;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static Map<String, String> getPriorityFieldValues() {
    try {
      Map<String, String> options = new Map<String, String>();
      Schema.DescribeFieldResult fieldResult = Task.Priority.getDescribe();
      List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
      for (Schema.PicklistEntry p : pValues) {
        options.put(p.getValue(), p.getLabel());
      }
      return options;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
