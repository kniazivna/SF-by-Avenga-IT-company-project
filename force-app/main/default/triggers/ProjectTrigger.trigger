trigger ProjectTrigger on Project__c (after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){                                          
        ProjectTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.new);
        }
    }

}