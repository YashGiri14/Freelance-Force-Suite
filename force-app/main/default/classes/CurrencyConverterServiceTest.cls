@isTest
private class CurrencyConverterServiceTest {
    @isTest
    static void testGetUSDtoINRRate() {
        // Create test data
        Account client = new Account(Name = 'Test Client');
        insert client;
        Project__c project = new Project__c(Client__c = client.Id);
        insert project;

        // Set up the mock response that simulates the API call
        Test.setMock(HttpCalloutMock.class, new MockCurrencyCallout());

        // Start the test
        Test.startTest();
        CurrencyConverterService.getUSDtoINRRate(project.Id);
        Test.stopTest();

        // Verify that the project was updated with the mock rate
        Project__c updatedProject = [SELECT Id, USD_to_INR_Exchange_Rate__c FROM Project__c WHERE Id = :project.Id];
        // The mock response returns 83.5, so we check for that value
        System.assertEquals(83.5, updatedProject.USD_to_INR_Exchange_Rate__c, 'The exchange rate should be updated from the mock callout.');
    }

    // This is the mock class that generates a fake response for our test
    public class MockCurrencyCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // This is a sample JSON body that mimics the real API's structure
            res.setBody('{"date": "2025-09-18", "usd": {"inr": 83.50, "aed": 3.67}}');
            res.setStatusCode(200);
            return res;
        }
    }
}