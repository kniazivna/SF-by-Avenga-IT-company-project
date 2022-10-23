trigger ProjectAssignmentTrigger on Project_Assignment__c (before insert, before update, after insert){

     if (Trigger.isBefore){
        if (Trigger.isInsert){
            ProjectAssignmentTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }

     else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ProjectAssignmentTriggerHandler.onAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {                       //була помилкаб я брала newMap перевірити
            ProjectAssignmentTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.new);
        }
    }
    }

