//Web Service should return 5 projects with the highest budget.
@RestResource(urlMapping='/Projects/*')
global with sharing class ProjectControllerREST {
    @HttpGet
    global static List<Project__c> getProjects() {
        return [SELECT Id, Name, Active__c, Is_Billable__c, Project_Budge__c FROM Project__c ORDER BY Project_Budge__c DESC LIMIT 5];
    }
}