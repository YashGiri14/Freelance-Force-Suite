public class MarkInvoicesOverdueSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        // Find all invoices that are not paid and have a due date in the past
        List<Invoice__c> overdueInvoices = [
            SELECT Id, Status__c
            FROM Invoice__c
            WHERE Status__c = 'Sent' AND Due_Date__c < TODAY
        ];

        // Loop through the overdue invoices and update their status
        for (Invoice__c inv : overdueInvoices) {
            inv.Status__c = 'Overdue';
        }

        // Perform the database update
        if (!overdueInvoices.isEmpty()) {
            update overdueInvoices;
        }
    }
}