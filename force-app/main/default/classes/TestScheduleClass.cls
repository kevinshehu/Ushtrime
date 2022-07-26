@isTest
public class TestScheduleClass implements Schedulable {
  public void execute(SchedulableContext sc) {
    new ScheduleCases();
  }
}
