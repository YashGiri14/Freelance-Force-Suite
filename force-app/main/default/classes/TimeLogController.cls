public with sharing class TimeLogController {
    @AuraEnabled
    public static Time_Log__c createTimeLog(Id projectId, Date logDate, Decimal hours, String description) {
        try {
            Time_Log__c newLog = new Time_Log__c(
                Project__c = projectId,
                Date__c = logDate,
                Hours__c = hours,
                Description__c = description,
                Status__c = 'Unbilled' // Default status
            );
            insert newLog;
            return newLog;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}