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

     //Total Billable Projects of the Developer should be recalculated each time a new Project Assignment is created                                 
    public static void onAfterInsert(List<Project_Assignment__c> newPas) {
    List<Developer__c> developers = [
        SELECT Id, Total_Billable_Projects__c,(
        SELECT Id FROM Project_Assignments__r WHERE Project__r.Is_Billable__c = true
        ) 
        FROM Developer__c
        ];
     
        for (Developer__c developer : developers) {
        developer.Total_Billable_Projects__c = developer.Project_Assignments__r.size();
        }
        
        update developers;
        
    }
  
    }