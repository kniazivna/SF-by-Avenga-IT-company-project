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

    public static void onAfterInsert(List<Project_Assignment__c> newPas) {

        Set<id> ProjectAssignment2Developer = new Set<id>();
   
        for (Project_Assignment__c newPa : newPas) {
           ProjectAssignment2Developer.add(newPa.Developer__c);
        }
         system.debug(ProjectAssignment2Developer);
        
        List<Developer__c> developers = [
                SELECT Id, Total_Billable_Projects__c
                FROM Developer__c
                WHERE Id IN :ProjectAssignment2Developer
        ];
         system.debug(developers);
        for (Developer__c developer : developers) {
            for (id devId : ProjectAssignment2Developer){
                //if(ProjectAssignment2Developer.contains(developer.Id)){
                if(devId == developer.Id){
                system.debug(developer.Total_Billable_Projects__c);
                developer.Total_Billable_Projects__c += 1;
                system.debug(developer.Total_Billable_Projects__c);
                }  
            }
                       
        }
        update developers;
    }
}
