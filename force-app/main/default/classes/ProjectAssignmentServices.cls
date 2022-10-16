public class ProjectAcssignmentServices {
    
    public static Map<String, List <Project_Assignment__c>> groupUniqueProjectAssigments(List<Project_Assignment__c> projects){
        
        Map<String, List <Project_Assignment__c>> records = new Map<String, List <Project_Assignment__c>>();

        for(Project_Assignment__c project : projects){
     
         String key = project.Project__c + '-' + project.Developer__c;
     
         if(records.containsKey(key)){
         records.get(key).add(project);
         }else{
         records.put(key,new List<Project_Assignment__c> { project } );
         } 

        }      
         system.debug('records----------->' +  records);
         return records;
    }

}