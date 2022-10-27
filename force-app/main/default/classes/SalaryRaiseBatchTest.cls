@isTest
public class SalaryRaiseBatchTest {


      @testSetup 
    static void dataSetup(){
        
  	Developer__c dev1 = new Developer__c(Name = 'Test Dev-1', Total_Billable_Projects__c = 0, Salary__c = 22, LastRaiseDate__c = Date.newInstance(2022, 9, 1));
 	Developer__c dev2 = new Developer__c(Name = 'Test Dev-2', Total_Billable_Projects__c = 0, Salary__c = 33, LastRaiseDate__c = Date.newInstance(2022, 4, 1));
  	Developer__c dev3 = new Developer__c(Name = 'Test Dev-3', Total_Billable_Projects__c = 0, Salary__c = 44, LastRaiseDate__c = Date.newInstance(2022, 4, 1));
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
 @IsTest
 static void salaryRaiseBatchTest() {
 String cronString =  '0 0 12 1 * ? *';
 
 Test.startTest();
 String jobId = System.schedule(
 'Updating Salary__c On Developer__c',
 cronString,
 new SalaryRaiseBatch()
 );
 Test.stopTest();
     
Developer__c updatedDev1 = [SELECT Id, Salary__c FROM Developer__c WHERE Name = 'Test Dev-1'];
 System.assertEquals(22, updatedDev1.Salary__c);
     
     Developer__c updatedDev2 = [SELECT Id, Salary__c FROM Developer__c WHERE Name = 'Test Dev-2'];
 System.assertEquals(133, updatedDev2.Salary__c);
     
     Developer__c updatedDev3 = [SELECT Id, Salary__c FROM Developer__c WHERE Name = 'Test Dev-3'];
 System.assertEquals(44, updatedDev3.Salary__c);
  
 }
}

