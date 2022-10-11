public class ProjectAcssignmentServices {
    
    public static Map<String, List <Project_Assignment__c>> groupUniqueProjectAssigments(List<Project_Assignment__c> projects){
        
        //цей запит використовувала для тесту
        //projects = new List<Project_Assignment__c>([SELECT Name, Developer__c, Project__c, Project_Assignment_Number__c FROM Project_Assignment__c]);
        
        Map<String, List <Project_Assignment__c>> records = new Map<String, List <Project_Assignment__c>>();
        
        for(Project_Assignment__c project : projects){
            
            List <Project_Assignment__c> groupedProjectAssignmentList = new List <Project_Assignment__c>();
            
           if(records.containsKey(project.Project__c + '-' + project.Developer__c)){

                List <Project_Assignment__c> sameKeyProjects = new List <Project_Assignment__c>(records.get(project.Project__c + '-' + project.Developer__c));
                groupedProjectAssignmentList.add(sameKeyProjects[0]);
            }

            groupedProjectAssignmentList.add(project);
            
            records.put(project.Project__c + '-' + project.Developer__c, groupedProjectAssignmentList);
        }

        system.debug(records);
        return records;
    }

}