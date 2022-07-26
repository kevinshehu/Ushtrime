public with sharing class TestFactory {
  public static final String PROFILE_STANDARD_USER = 'Standard User';

  public static final String TESTUSER_FIRSTNAME = 'Testfirstname';

  public static final String TESTUSER_LASTNAME = 'Testlastname';

  public static final String TESTUSER_NAME = 'testuser@testorg.tst';

  public static User createUser(
    String userProfile,
    String userRole,
    Boolean withPersist
  ) {
    list<aggregateResult> aggResults = [SELECT Count(Id) CNT FROM User];
    Integer userCounter = Integer.valueOf(aggResults[0].get('CNT'));
    Profile profile = null;
    UserRole role = null;
    try {
      profile = [SELECT Id FROM profile WHERE name = :userProfile LIMIT 1];
    } catch (Exception e) {
      profile = [
        SELECT Id
        FROM profile
        WHERE name LIKE 'System%Administrator%'
        LIMIT 1
      ];
    }
    User user = new User(
      alias = String.valueOf(userCounter) + 'a!1',
      username = String.valueOf(userCounter) + TESTUSER_NAME,
      email = 'newSfTestUser@test.org.com',
      emailencodingkey = 'UTF-8',
      FirstName = String.valueOf(userCounter) + TESTUSER_FIRSTNAME,
      lastname = String.valueOf(userCounter) + TESTUSER_LASTNAME,
      languagelocalekey = 'en_US',
      localesidkey = 'en_US',
      profileid = profile.Id,
      timezonesidkey = 'Europe/Berlin'
    );
    if (userRole != null) {
      try {
        role = [SELECT Id FROM UserRole WHERE name = :userRole LIMIT 1];
      } catch (Exception e) {
        role = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
      }
      user.UserRoleId = role.Id;
    }
    if (withPersist) {
      insert user;
    }
    return user;
  }
}
