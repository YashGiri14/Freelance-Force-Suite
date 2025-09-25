public with sharing class TimeLogController {

    // This method is exposed to Lightning Web Components (AuraEnabled)
    // and can be called from the front-end (cacheable=false means it can perform DML)
    @AuraEnabled
    public static Time_Log__c createTimeLog(Decimal hours, String description, Id projectId) {
        if (hours == null || projectId == null) {
            throw new AuraHandledException('Hours and Project ID are required.');
        }

        Time_Log__c newLog = new Time_Log__c();
        newLog.Hours__c = hours;
        newLog.Description__c = description;
        newLog.Project__c = projectId;
        newLog.Date__c = Date.today(); // Default to today's date
        newLog.Status__c = 'Unbilled'; // Default status

        try {
            insert newLog;
            return newLog;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}