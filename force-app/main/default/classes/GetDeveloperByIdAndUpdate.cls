public class GetDeveloperByIdAndUpdate {
    
    public class Developer{
       @AuraEnabled public String name;
       @AuraEnabled public Integer totalBillableProjects;
       @AuraEnabled public Id recordId;
      /* @AuraEnabled public Datetime lastSynsDate;*/
        
        public Developer(String name, Integer totalBillableProjects, String recordId, Datetime lastSynsDate){
           this.name = name;
           this.totalBillableProjects = totalBillableProjects;
           this.recordId = recordId;
          /* this.lastSynsDate = lastSynsDate;*/
            
        }
    }

    @AuraEnabled
    public static /*String*/ Developer getDeveloperByIdAndUpdate(Id currentDeveloperId) {
          /*Developer__c developer = [
                     SELECT Id, Name, Total_Billable_Projects__c, Last_Sync_Date__c 
                     FROM Developer__c 
                     WHERE Id = :currentDeveloperId];*/
        try{  
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://avenga-school.herokuapp.com/retrieve-record');
            request.setMethod('GET');
            request.setHeader('objectName', 'Developer');
		    request.setHeader('recordId',currentDeveloperId);

            HttpResponse response = http.send(request);
    
                if(response.getStatusCode() != 200) {
                    System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                    return null;
                } else {
                    System.debug(response.getBody());
                   // return response.getBody();
                    Developer devToUpdate = (Developer)JSON.deserialize(response.getBody(), Developer.class);
                    /*developer.Name = devToUpdate.name;
                    developer.Total_Billable_Projects__c = devToUpdate.totalBillableProjects;
                    developer.Last_Sync_Date__c = Datetime.now();
                    system.debug(developer);
                    
                    update developer;
                    system.debug(developer);*/
                    return devToUpdate;
                }
        }catch(System.CalloutException e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}