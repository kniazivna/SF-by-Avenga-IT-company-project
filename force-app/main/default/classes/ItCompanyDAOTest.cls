@isTest
public class ItCompanyDAOTest {
    
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
    static void getAvailableDeveloperIdsTest(){
              
              
    Test.startTest();
        
    Set<Id> resultSet = ItCompanyDAO.getAvailableDeveloperIds();
        
    Test.stopTest();
        
    System.assertEquals(3, resultSet.size(), 'ItCompanyDAO.getAvailableDeveloperIds return the wrong amount of ID Set');
    }
    
    @isTest
    static void getUnassignedDeveloperIdsTest(){
               
    Test.startTest();
        
    Set<Id> resultSet = ItCompanyDAO.getUnassignedDeveloperIds();
        
    Test.stopTest();
        
    System.assertEquals(1, resultSet.size(), 'ItCompanyDAO.getUnassignedDeveloperIds return the wrong amount of ID Set');
        
    }
    
    @isTest
    static void getClientsTest(){
        Integer limitNumber = 2;
        Integer offsetNumber = 2;
                
    Test.startTest();
        
    List<Client__c> resultList = ItCompanyDAO.getClients(limitNumber,offsetNumber);
        
    Test.stopTest();
        
    System.assertEquals(1, resultList.size(), 'ItCompanyDAO.getClients return the wrong amount of Client__c List');
    }
    
    @isTest
    static void getDevelopersTest(){
        Integer limitNumber = 2;
        Integer offsetNumber = 2;
        Set<Id> developerId = new Set<Id>();
         List<Developer__c> devs = [SELECT Id,Name FROM Developer__c];
         for(Developer__c dev: devs){
          developerId.add(dev.id);}
        
     Test.startTest();
        
    List<Developer__c> resultList = ItCompanyDAO.getDevelopers(developerId,limitNumber,offsetNumber);
        
    Test.stopTest();
        
    System.assertEquals(1, resultList.size(), 'ItCompanyDAO.getDevelopers return the wrong amount of Developer__c List');
    
    }
    
    @isTest
    static void getClientTotalActiveProjectsTest(){
        
    Set<Id> clientIds = new Set<Id>();
    List<Client__c> clnts = [SELECT Id FROM Client__c];
    for(Client__c clnt: clnts){
    clientIds.add(clnt.id);}
   
    Test.startTest();
        
    Map<Id, Integer> resultMap = ItCompanyDAO.getClientTotalActiveProjects(clientIds);
        
    Test.stopTest();
        
    System.assertEquals(3, resultMap.size(), 'ItCompanyDAO.getClientTotalActiveProjects return the wrong amount of Client__c Map');
    System.assertEquals(0, resultMap.get(clnts[0].id), 'ItCompanyDAO.getClientTotalActiveProjects return the wrong amount of Client ClientTotalActiveProjects');
    System.assertEquals(1, resultMap.get(clnts[2].id), 'ItCompanyDAO.getClientTotalActiveProjects return the wrong amount of Client ClientTotalActiveProjects');
    }
    
    @isTest
    static void getDeveloperTotalBillableProjectsTest(){
    
    Set<Id> developerIds = new Set<Id>();
    List<Developer__c> devs = [SELECT Id,Name FROM Developer__c];
    for(Developer__c dev: devs){
    developerIds.add(dev.id);}
        
        Test.startTest();
        
    Map<Id, Integer> resultMap = ItCompanyDAO.getDeveloperTotalBillableProjects(developerIds);
        
    Test.stopTest();
        
    System.assertEquals(2, resultMap.size(), 'ItCompanyDAO.getDeveloperTotalBillableProjects return the wrong amount of Client__c Map');
    System.assertEquals(1, resultMap.get(devs[0].id), 'ItCompanyDAO.getDeveloperTotalBillableProjects return the wrong amount of Developer Total Billable Projects');
    System.assertEquals(1, resultMap.get(devs[1].id), 'ItCompanyDAO.getDeveloperTotalBillableProjects return the wrong amount of Developer Total Billable Projects');

    }
    
}