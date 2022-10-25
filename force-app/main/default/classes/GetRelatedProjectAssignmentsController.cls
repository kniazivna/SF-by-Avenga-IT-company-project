public with sharing class GetRelatedProjectAssignmentsController {

    @AuraEnabled(cacheable=true)
    public static List <Project_Assignment__c> getRelatedProjectAssignments(Id currentDeveloperId) {

        return [SELECT Project_Assignment_Number__c, Name FROM Project_Assignment__c WHERE Developer__c = :currentDeveloperId];

    }
}

