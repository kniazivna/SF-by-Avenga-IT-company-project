public class SalaryRaiseBatch implements Database.Batchable <sObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(
        'SELECT Id, Salary__c, LastRaiseDate__c, (SELECT Id FROM Project_Assignments__r WHERE Project__r.Is_Billable__c = true) FROM Developer__c'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Developer__c> devs){
        
        for (Developer__c dev : devs) {
               if(dev.LastRaiseDate__c.monthsBetween(Date.today()) == 6){
               dev.Salary__c += (dev.Project_Assignments__r.size() * 100);
               }
        }
        update devs;
    }
    
    public void finish(Database.BatchableContext bc){
     
        system.debug('Done.');
    }

    public void execute(SchedulableContext ctx) {

        SalaryRaiseBatch salaryRaiseBatch = new SalaryRaiseBatch();
        Id batchId = Database.executeBatch(salaryRaiseBatch);
    }
}