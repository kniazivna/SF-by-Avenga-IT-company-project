@isTest
public class ProjectTriggerHandlerTest {
    
  @testSetup 
  static void dataSetup(){
        
  Developer__c dev1 = new Developer__c(Name = 'Test Dev-1', Total_Billable_Projects__c = 0);
 	Developer__c dev2 = new Developer__c(Name = 'Test Dev-2', Total_Billable_Projects__c = 0);
  Developer__c dev3 = new Developer__c(Name = 'Test Dev-3', Total_Billable_Projects__c = 0);
  insert new List<Developer__c>{dev1, dev2,dev3};
        
  Project__c pr1 = new Project__c(Name = 'Test Pr-1', Active__c = true, Is_Billable__c = true, Project_Budge__c = 111);
 	Project__c pr2 = new Project__c(Name = 'Test Pr-2', Active__c = true, Is_Billable__c = true, Project_Budge__c = 111);
  Project__c pr3 = new Project__c(Name = 'Test Pr-3', Active__c = true, Is_Billable__c = false, Project_Budge__c = 111);
  insert new List<Project__c>{pr1, pr2,pr3};
    
  Project_Assignment__c pa1 = new Project_Assignment__c(Name = 'Test Pa-1', Developer__c = dev1.id, Project__c = pr1.id);
 	Project_Assignment__c pa2 = new Project_Assignment__c(Name = 'Test Pa-2', Developer__c = dev2.id, Project__c = pr2.id);
  Project_Assignment__c pa3 = new Project_Assignment__c(Name = 'Test Pa-3', Developer__c = dev3.id, Project__c = pr3.id);
  insert new List<Project_Assignment__c>{pa1, pa2,pa3};
        
  }
    
    @isTest
    static void onAfterUpdate(){
        
    List<Project__c> projects = [SELECT Is_Billable__c FROM Project__c];
      for(Project__c project:projects){
      project.Is_Billable__c = !project.Is_Billable__c;            
      }
    
    Test.startTest();
    update projects; 
    Test.stopTest();
    
    Developer__c dev1 = [SELECT Total_Billable_Projects__c FROM Developer__c WHERE Name = 'Test Dev-1'];
    System.assertEquals(true, dev1.Total_Billable_Projects__c == 0);
        
    }
}