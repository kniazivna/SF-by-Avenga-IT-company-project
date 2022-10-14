public with sharing class ItCompanyDAO {

  public static Set<Id> getAvailableDeveloperIds() {

        List<Project_Assignment__c> availableDeveloperIds = new List<Project_Assignment__c>([
            SELECT Developer__c 
            FROM Project_Assignment__c 
            WHERE Developer__r.Total_Billable_Projects__c < 5 
            OR Developer__r.Total_Billable_Projects__c = NULL 
            ]);
      
            Set<Id> setId = new Set<Id>();
      
            for( Project_Assignment__c availableDeveloperId : availableDeveloperIds){
            setId.add(availableDeveloperId.Developer__c);
            }

    System.debug('getAvailableDeveloperIds-------------->' + setId);
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

        System.debug('getUnassignedDeveloperIds---------->' + setId);
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

        system.debug('getClients------------>' + getClients);
        return getClients;

    }

  public static List<Developer__c> getDevelopers(Set<Id> developerId,Integer limitNumber, Integer offsetNumber){
       
        String sqlString = 'SELECT Name, Total_Billable_Projects__c FROM Developer__c ';
       
        if(developerId != NULL){
			sqlString += 'WHERE Id IN :developerId ';
        }
		    if(limitNumber != NULL){
			  sqlString += 'LIMIT :limitNumber ';
		    }
        if(offsetNumber != NULL){
			  sqlString += 'OFFSET :offsetNumber';
		    }
       
        List<Developer__c> getDevelopers = Database.query(sqlString);
      
        system.debug('getDevelopers---------->' + getDevelopers);
        return getDevelopers;
    }

}

