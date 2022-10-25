public class ProjectTriggerHandler {
    
    public static void onAfterUpdate(Map<Id, Project__c> oldProjectsMap, List<Project__c> updatedProjects) {
    //Total Billable Projects of the Developer should be recalculated each time Is Billable field is changed on the Project
    List<Developer__c> developers = [
        SELECT Id, Total_Billable_Projects__c, (
        SELECT Id FROM Project_Assignments__r 
        )
        FROM Developer__c
        ];
         
        for (Project__c updatedProject : updatedProjects) {
        Project__c oldProject = oldProjectsMap.get(updatedProject.Id);
            if (oldProject.Is_Billable__c != updatedProject.Is_Billable__c) {
                for (Developer__c developer : developers) {
                	if(updatedProject.Is_Billable__c){
                    developer.Total_Billable_Projects__c += 1;
                    } else developer.Total_Billable_Projects__c -= 1;
                }
            }
        }
        
        update developers;
    }

}