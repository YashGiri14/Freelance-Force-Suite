// Nightly scheduled job to mark invoices as overdue
public class MarkInvoicesOverdueSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        // SOQL query to find and update overdue invoices would go here
        System.debug('Scheduled job is running.');
    }
}