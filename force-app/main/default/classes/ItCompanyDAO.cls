public with sharing class ItCompanyDAO {

  public static Set<Id> getAvailableDeveloperIds() {

        List<Project_Assignment__c> availableDeveloperIds = new List<Project_Assignment__c>([
            SELECT Developer__c, Developer__r.Name 
            FROM Project_Assignment__c 
            WHERE Developer__r.Total_Billable_Projects__c < 5 
            OR Developer__r.Total_Billable_Projects__c = NULL //чи треба цю перевірку?
            ]);
      
      Set<Id> setId = new Set<Id>();
      
      for( Project_Assignment__c availableDeveloperId : availableDeveloperIds){
          setId.add(availableDeveloperId.Developer__c);
      }

        System.debug(setId);
        return setId;
    }

    public static Set<Id> getUnassignedDeveloperIds() {

       List<Developer__c> DevelopersIds = new List<Developer__c>([
            SELECT Id 
            FROM Developer__c 
            WHERE Total_Billable_Projects__c = 0  
            OR Total_Billable_Projects__c = NULL 
            ]);   
      
      Set<Id> setId = new Set<Id>();
      
      for( Developer__c DeveloperId : DevelopersIds){
          setId.add(DeveloperId.Id);
      }

        System.debug(setId);
        return setId;
}

public static List<Client__c> getClients(Integer limitNumber, Integer offsetNumber){

    List<Client__c> getClients = Database.query(
        'SELECT Name, Email__c, Total_Active_Projects__c, Budget__c '
        + 'FROM Client__c '
        + 'ORDER BY Name ASC '
        + 'LIMIT :limitNumber ' 
        + 'OFFSET :offsetNumber'
    );
    system.debug(getClients);
    return getClients;

}

}