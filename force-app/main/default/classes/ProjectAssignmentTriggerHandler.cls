public with sharing class ProjectAssignmentTriggerHandler {

   public static void onBeforeInsert(List<Project_Assignment__c> newPas) {
        List<Project_Assignment__c> oldPas = new List<Project_Assignment__c>([SELECT Developer__c, Project__c FROM Project_Assignment__c]);
            for(Project_Assignment__c oldPa : oldPas){
                for (Project_Assignment__c newPa : newPas){
                    if(newPa.Developer__c == oldPa.Developer__c && newPa.Project__c == oldPa.Project__c){
                    newPa.addError('A Project Assignmen with the same developer and project already exists');
                    }
                }
            }
    }
}
