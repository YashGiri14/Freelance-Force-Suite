public class CurrencyConverterService {
    // Using @future(callout=true) allows this method to make web service calls
    // It runs asynchronously in the background.
    @future(callout=true)
    public static void getUSDtoINRRate(Id projectId) {
        // Prepare the HTTP request
        HttpRequest request = new HttpRequest();
        // This is the endpoint for the free currency API to get the latest USD rates
        request.setEndpoint('https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd.json');
        request.setMethod('GET');

        try {
            // Send the request
            Http http = new Http();
            HttpResponse response = http.send(request);

            // Check if the call was successful (status code 200)
            if (response.getStatusCode() == 200) {
                // Parse the JSON response to get the data
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> usdRates = (Map<String, Object>) results.get('usd');
                Decimal inrRate = (Decimal) usdRates.get('inr');

                // Find the project record and update it with the exchange rate
                Project__c projectToUpdate = [SELECT Id FROM Project__c WHERE Id = :projectId];
                projectToUpdate.USD_to_INR_Exchange_Rate__c = inrRate;
                update projectToUpdate;
            }
        } catch (Exception e) {
            // In a real project, you would log this error more formally
            System.debug('Callout failed: ' + e.getMessage());
        }
    }
}