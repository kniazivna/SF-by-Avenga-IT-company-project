public class ItCompanyServices{
    
   public static Database.SaveResult createProject(Id clientId){
     //create project
     Project__c project = new Project__c(Client__c = clientId, Name = 'New project from Database.SaveResult for client with ID: ' + clientId);
     Database.SaveResult srProject = Database.insert(project);
        
        if (srProject.isSuccess()){
        
        System.debug('Successfully inserted project. Project ID: ' + srProject.getId());
            
        } else {
             for(Database.Error err : srProject.getErrors()) {
            System.debug('The following error has occurred.');
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Project fields that affected this error: ' + err.getFields());
	        }
        }
        
        return srProject;
    
    }

    public static void createProjectAssignment(Id projectId, Id developerId){
    //create project assignment
      try {
	    Project_Assignment__c projectAssignment = new Project_Assignment__c(Name = 'PA-Test2', Developer__c = developerId, Project__c = projectId);
    	insert projectAssignment;
        System.debug(projectAssignment.Name + ' inserted Successfully');
    	} catch (DmlException e) {
    	System.debug('A DML exception has occurred: ' +e.getMessage());
    	}
    }

    


}