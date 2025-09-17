@isTest
private class TimeLogTriggerHandlerTest {
    @isTest
    static void testDuplicateTimeLogPrevention() {
        // Create test data
        Account client = new Account(Name = 'Test Client');
        insert client;

        // CORRECTED: Removed the "Name" field assignment.
        // Salesforce will generate the auto-number name automatically.
        Project__c project = new Project__c(Client__c = client.Id);
        insert project;

        Time_Log__c initialLog = new Time_Log__c(
            Project__c = project.Id,
            Date__c = Date.today(),
            Hours__c = 2.5
        );
        insert initialLog;

        // Start the test
        Test.startTest();

        // Attempt to insert a duplicate time log
        Time_Log__c duplicateLog = new Time_Log__c(
            Project__c = project.Id,
            Date__c = Date.today(),
            Hours__c = 2.5
        );

        // Use a try-catch block to verify that the trigger throws an error
        try {
            insert duplicateLog;
            // If the insert succeeds, the test should fail
            System.assert(false, 'The trigger should have prevented the duplicate insert.');
        } catch (DmlException e) {
            // Assert that the error message is the one we expect from our trigger
            System.assert(e.getMessage().contains('A time log with the same project, date, and hours already exists.'),
                'The error message from the trigger was not found.');
        }

        Test.stopTest();
    }
}