trigger TimeLogTrigger on Time_Log__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        TimeLogTriggerHandler.beforeInsert(Trigger.new);
    }
}