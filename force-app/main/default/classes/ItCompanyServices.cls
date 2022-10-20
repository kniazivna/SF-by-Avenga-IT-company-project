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
	    Project_Assignment__c projectAssignment = new Project_Assignment__c(Name = 'PA-Test3', Developer__c = developerId, Project__c = projectId);
    	insert projectAssignment;
        System.debug(projectAssignment.Name + ' inserted Successfully');
    	} catch (DmlException e) {
    	System.debug('A DML exception has occurred: ' +e.getMessage());
    	}

    }

    public static void makeProjectBillable(Id projectId, Decimal projectBudget){
    //update project with IsBillable__c = true
    Project__c projectToUpdate = [SELECT Is_Billable__c/*, Project_Budge__c*/ FROM Project__c WHERE id = :projectId]; 
    projectToUpdate.Is_Billable__c = true;
    //projectToUpdate.Project_Budge__c = 11111;//на цьому полі є валідейшн рул, як що Project_Budge__c незаповнений, то проект не може бути оплачуваний
        try {
        update projectToUpdate;
        System.debug(projectToUpdate.id + ' updated successfully to status TRUE');
    	} catch (DmlException e) {
    	System.debug('A DML exception has occurred: ' +e.getMessage());
    	}
    }

  public static void deactivateProjects(Set<Id> projectIds){
    //update project with Active__c = false, delete all project assignments
    List<Project__c> prs = [SELECT Active__c  FROM Project__c WHERE id IN :projectIds];    
        for(Project__c p:prs){
            p.Active__c = false;}
    List<Project_Assignment__c> pas = [SELECT Project__r.id  FROM Project_Assignment__c WHERE Project__r.id IN :projectIds];
        try {
        update prs;
        delete pas;
        System.debug('Projects updated Active__c = FALSE');
    	} catch (DmlException e) {
    	System.debug('A DML exception has occurred: ' +e.getMessage());
    	}
    }

     public static List<Database.SaveResult> createDeveloperAndAssign(String devName, Set<Id> projectIds){
    //create Developer record and assign projects to it
        Developer__c dev = new Developer__c(Name = devName);

        List <Database.SaveResult> rsList= new List <Database.SaveResult>();  
         
        Database.SaveResult srDev = Database.insert(dev);
        rsList.add(srDev);
        
        	if (srDev.isSuccess()){
        	System.debug('Successfully inserted Developer. Developer ID: ' + srDev.getId());
        	List <Project_Assignment__c> prAssgns = new List <Project_Assignment__c>();
                
                for(id prId:projectIds){
                Project_Assignment__c prAssgn = new Project_Assignment__c(Name = 'PA-'+ devName + '-' + prId, Project__c = prId, Developer__c = dev.id);
                prAssgns.add(prAssgn);}
                
        	    List <Database.SaveResult> srPrAssgns = Database.insert(prAssgns);
                for(Database.SaveResult srPrAssgn:srPrAssgns){
                    if (srPrAssgn.isSuccess()){
        		System.debug('Successfully inserted ProjectAssignment. Project Assignment ID: ' + srPrAssgn.getId());
                    }else{
                    for(Database.Error err : srPrAssgn.getErrors()) {
             		System.debug('The following error has occurred.');
             		System.debug(err.getStatusCode() + ': ' + err.getMessage());
             		System.debug('Project fields that affected this error: ' + err.getFields());
	        			}
                    }
                }
            } else {
                for(Database.Error err : srDev.getErrors()) {
                System.debug('The following error has occurred.');
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Project fields that affected this error: ' + err.getFields());
	            }
            }
    return rsList;
    }


}