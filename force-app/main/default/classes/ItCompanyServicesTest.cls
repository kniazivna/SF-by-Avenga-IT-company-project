@isTest
public class ItCompanyServicesTest {
    
      @testSetup 
    static void dataSetup(){
        
  	Developer__c dev1 = new Developer__c(Name = 'Test Dev-1', Total_Billable_Projects__c = 1);
 	Developer__c dev2 = new Developer__c(Name = 'Test Dev-2', Total_Billable_Projects__c = 1);
  	Developer__c dev3 = new Developer__c(Name = 'Test Dev-3', Total_Billable_Projects__c = 0);
    insert new List<Developer__c>{dev1, dev2,dev3};
        
    Project__c pr1 = new Project__c(Name = 'Test Pr-1', Active__c = true, Is_Billable__c = true, Project_Budge__c = 111);
 	Project__c pr2 = new Project__c(Name = 'Test Pr-2', Active__c = true, Is_Billable__c = true, Project_Budge__c = 111);
  	Project__c pr3 = new Project__c(Name = 'Test Pr-3', Active__c = true, Is_Billable__c = false);
    insert new List<Project__c>{pr1, pr2,pr3};
        
    Client__c cl1 = new Client__c(Name = 'Test Cl-1', Total_Active_Projects__c = 0);
    Client__c cl2 = new Client__c(Name = 'Test Cl-2', Total_Active_Projects__c = 2);
    Client__c cl3 = new Client__c(Name = 'Test Cl-3', Total_Active_Projects__c = 1);
    insert new List<Client__c>{cl1, cl2,cl3};
    
    Project_Assignment__c pa1 = new Project_Assignment__c(Name = 'Test Pa-1', Developer__c = dev1.id, Project__c = pr1.id);
 	Project_Assignment__c pa2 = new Project_Assignment__c(Name = 'Test Pa-2', Developer__c = dev2.id, Project__c = pr2.id);
  	Project_Assignment__c pa3 = new Project_Assignment__c(Name = 'Test Pa-3', Developer__c = dev3.id, Project__c = pr3.id);
    insert new List<Project_Assignment__c>{pa1, pa2,pa3};
        
    }
    
    @isTest
    static void createProjectTest(){
         Boolean expectstion = null;
         Id clientId;
         List<Client__c> clnts = [SELECT Id FROM Client__c LIMIT 1];
         for(Client__c c: clnts){
         clientId =  c.id;
        }
        
       
        Test.startTest();
        
   	    Database.SaveResult resulPr = ItCompanyServices.createProject(clientId);
        
        Test.stopTest();
        
        System.assertEquals(true, resulPr.isSuccess(), 'Project inserting failed. Project ID: ' + resulPr.getId());
        //System.assertEquals(true, !resulPr.isSuccess(), 'Successfully inserted project. Project ID: ' + resulPr.getId());
    }
    
    @isTest
    public static void createProjectAssignmentTest(){
    
    Developer__c dev = [SELECT Id FROM Developer__c WHERE Name = 'Test Dev-3'];
    Id developerId = dev.id;
    Project__c pr = [SELECT Id FROM Project__c WHERE Name = 'Test Pr-2'];
    Id projectId = pr.id;
        
    Test.startTest();
        
   	ItCompanyServices.createProjectAssignment(projectId, developerId);
        
  	Test.stopTest();
    //Previous size 3    
    List<Project_Assignment__c> prAsList = [SELECT id FROM Project_Assignment__c];
        
    System.assertEquals(4, prAsList.size(), 'Project Assignment inserting failed.');
   

    } 
    
    @isTest
    static void makeProjectBillableTest(){
        
   //додала цю змінну,бо по валідейшн рулу якщо проект Billable, то бюджет має бути заповнений
    Decimal projectBudget = 100;
     //вибираю проект з isBillable = false   
    Project__c pr = [SELECT Id FROM Project__c WHERE Is_Billable__c = false];
	Id projectId = pr.id;
	
    Test.startTest();
        
   	ItCompanyServices.makeProjectBillable(projectId, projectBudget);
        
  	Test.stopTest();
        
    //Previous count = 2
    Integer numOfBillablePr;   
    AggregateResult [] res = [SELECT Is_Billable__c, COUNT(id) FROM Project__c WHERE Is_Billable__c = true GROUP BY Is_Billable__c];
        for(AggregateResult r:res){
            numOfBillablePr = (Integer)r.get('expr0');
        } 
           
    System.assertEquals(3, numOfBillablePr, 'Project isn\'t billable.');

    }
    
    @isTest
    static void deactivateProjectsTest(){
    //update project with Active__c = false, delete all project assignments
     Set<Id> projectIds = new Set<Id>();
    List<Project__c> prs = [SELECT Id FROM Project__c WHERE Active__c = true];
       for(Project__c p: prs){
       projectIds.add(p.id);}
        
    Test.startTest();
        
   	ItCompanyServices.deactivateProjects(projectIds);
        
  	Test.stopTest();
        
    //Previous count = 0, all were true
    Integer numOfActivePr;   
    AggregateResult [] res = [SELECT Active__c, COUNT(id) FROM Project__c WHERE Active__c = false GROUP BY Active__c];
        for(AggregateResult r:res){
            numOfActivePr = (Integer)r.get('expr0');
        } 
     //Previous size = 3   
     List<Project_Assignment__c> pas = [SELECT id FROM Project_Assignment__c WHERE Project__r.Active__c = true];
    
           
    System.assertEquals(3, numOfActivePr, 'Project is active.');
    System.assertEquals(0, pas.size(), 'Project Assignment weren\'t deleted.');
    }
    
    @isTest
    static void createDeveloperAndAssignTest(){
    //create Developer record and assign projects to it
    String devName = 'TestDev';
    Set<Id> projectIds = new Set<Id>();
    List<Project__c> prs = [SELECT Id FROM Project__c WHERE Active__c = true];
    	for(Project__c p: prs){
        projectIds.add(p.id);}
        
    Test.startTest();
      
    List<Database.SaveResult> srList = ItCompanyServices.createDeveloperAndAssign(devName, projectIds);
        
    Test.stopTest();
        
    System.assertEquals(true, srList.size() > 0, 'ItCompanyServicesTest.createDeveloperAndAssign weren\'t created.');

        }
}