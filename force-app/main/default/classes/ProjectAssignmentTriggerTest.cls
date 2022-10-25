@isTest
public class ProjectAssignmentTriggerTest {
    
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
    static void onBeforeInsertTest(){
        
    Developer__c dev2 = [SELECT Name FROM Developer__c WHERE Name = 'Test Dev-2'];
    Project__c pr1 = [SELECT Name FROM Project__c WHERE Name = 'Test Pr-1'];
    Project__c pr2 = [SELECT Name FROM Project__c WHERE Name = 'Test Pr-2'];
        
    List<Project_Assignment__c> newPas = new List<Project_Assignment__c>();
    Project_Assignment__c test1 = new Project_Assignment__c(Name = 'Test Pa-4', Developer__c = dev2.id, Project__c = pr1.id);
    newPas.add(test1);
    Project_Assignment__c test2 = new Project_Assignment__c(Name = 'Test Pa-5', Developer__c = dev2.id, Project__c = pr2.id);
    newPas.add(test2);
        
    Test.startTest();
        
   	Database.insert(newPas, false);
        
    Test.stopTest();
        
    List<Project_Assignment__c> test = ([SELECT Name FROM Project_Assignment__c]);
    //тест падає, бо отримуємо 4(було 3, додавали 2, один з яких з однаковими іменами, він не додався)
    //System.assertEquals(5, test.size(), 'ProjectAssignmentTriggerHandler.onBeforeInsert Project Assignment with same name of developer and project created.');
    System.assertEquals(4, test.size(), 'ProjectAssignmentTriggerHandler.onBeforeInsert Project Assignment with same name of developer and project weren\'t created.');
        
    }
    
    @isTest
    static void onAfterInsertTest(){
        
    List<Developer__c> developers = [SELECT Id FROM Developer__c]; 
    Project__c pr = [SELECT Id FROM Project__c WHERE Name = 'Test Pr-2'];
        
    Project_Assignment__c pa1 = new Project_Assignment__c(Name = 'Test Pa', Developer__c = developers[0].id, Project__c = pr.id);
    Project_Assignment__c pa2 = new Project_Assignment__c(Name = 'Test Pa', Developer__c = developers[2].id, Project__c = pr.id);
        
    Test.startTest();
        
    insert pa1;
    insert pa2;
        
    Test.stopTest();
         
    List<Project_Assignment__c> tests = ([SELECT Developer__c, Project__r.Is_Billable__c FROM Project_Assignment__c]);
    System.assertEquals(5, tests.size(), 'ProjectAssignmentTriggerHandler.onAfterInsert  new Project Assignments weren\'t created.');
        
    Developer__c dev = [SELECT Total_Billable_Projects__c FROM Developer__c WHERE Name = 'Test Dev-1'];
    System.assertEquals(true, dev.Total_Billable_Projects__c == 2);
        
    Developer__c devTest2 = [SELECT Total_Billable_Projects__c FROM Developer__c WHERE Name = 'Test Dev-3'];
    System.assertEquals(true, devTest2.Total_Billable_Projects__c == 1);
    }
  
}