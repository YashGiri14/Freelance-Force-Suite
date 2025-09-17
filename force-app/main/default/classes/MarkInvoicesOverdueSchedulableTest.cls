@isTest
private class MarkInvoicesOverdueSchedulableTest {
    @isTest
    static void testScheduledJob() {
        // Create test data
        Account client = new Account(Name = 'Test Client');
        insert client;

        // CORRECTED: Removed the "Name" field assignment.
        // Salesforce will generate the auto-number name automatically.
        Project__c project = new Project__c(Client__c = client.Id);
        insert project;

        Invoice__c overdueInvoice = new Invoice__c(
            Project__c = project.Id,
            Status__c = 'Sent',
            Due_Date__c = Date.today().addDays(-1) // Due yesterday
        );
        insert overdueInvoice;

        // Start the test
        Test.startTest();

        // Schedule the job to run now
        String cronExp = '0 0 0 ? * *'; // Runs at midnight
        String jobId = System.schedule('Test Overdue Job', cronExp, new MarkInvoicesOverdueSchedulable());

        Test.stopTest();

        // Verify the results by requerying the data
        Invoice__c updatedInvoice = [SELECT Id, Status__c FROM Invoice__c WHERE Id = :overdueInvoice.Id];
        System.assertEquals('Overdue', updatedInvoice.Status__c, 'The invoice status should have been updated to Overdue.');
    }
}