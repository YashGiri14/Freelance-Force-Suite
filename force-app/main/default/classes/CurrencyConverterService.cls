// Service class to perform HTTP callouts to an external currency API
public class CurrencyConverterService {

    // Method to get the latest currency exchange rates
    public static void getExchangeRates() {
        // 1. Prepare the HTTP Request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json');
        request.setMethod('GET');

        // 2. Send the Request and get the Response
        try {
            Http http = new Http();
            HttpResponse response = http.send(request);

            // 3. Process the Response
            if (response.getStatusCode() == 200) {
                System.debug('Response body: ' + response.getBody());
                // Logic to parse the JSON response would go here
            }
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e.getMessage());
        }
    }
}