public class TimeLogTriggerHandler {
    public static void beforeInsert(List<Time_Log__c> newTimeLogs) {
        // Create a set to hold unique identifiers for existing time logs
        Set<String> existingLogKeys = new Set<String>();

        // Create a Set of Project Ids from the new Time Logs to make the query efficient
        Set<Id> projectIds = new Set<Id>();
        for(Time_Log__c newLog : newTimeLogs) {
            projectIds.add(newLog.Project__c);
        }

        // Query existing time logs only for the relevant projects
        for (Time_Log__c existingLog : [SELECT Id, Project__c, Date__c, Hours__c FROM Time_Log__c WHERE Project__c IN :projectIds]) {
            String key = existingLog.Project__c + '-' + existingLog.Date__c + '-' + existingLog.Hours__c;
            existingLogKeys.add(key);
        }

        // Loop through the new time logs being inserted
        for (Time_Log__c newLog : newTimeLogs) {
            String newKey = newLog.Project__c + '-' + newLog.Date__c + '-' + newLog.Hours__c;
            // If a log with the same project, date, and hours already exists, add an error
            if (existingLogKeys.contains(newKey)) {
                newLog.addError('A time log with the same project, date, and hours already exists.');
            }
        }
    }
}