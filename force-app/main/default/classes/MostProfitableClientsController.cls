public with sharing class MostProfitableClientsController {
    @AuraEnabled
    public static Client__c[] getMostProfitableClients(Integer limitNumber){
        
        return [SELECT id, Name, Total_Active_Projects__c, Budget__c
                FROM Client__c
                WHERE OwnerId=: UserInfo.getUserId() 
                AND Budget__c != null 
                ORDER BY Budget__c desc LIMIT :limitNumber];
    }

}