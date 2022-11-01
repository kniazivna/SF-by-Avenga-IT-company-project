public class GetDeveloperByIdAndUpdate {
    
    public class Developer{
        private String name;
        private Integer totalBillableProjects;
        private Id recordId;
        
        public Developer(String name, Integer totalBillableProjects, String recordId){
            this.name = name;
            this.totalBillableProjects = totalBillableProjects;
            this.recordId = recordId;
            
        }
    }

    @AuraEnabled()
    public static Developer/*__c*/ getDeveloperByIdAndUpdate(Id currentDeveloperId) {
        //  Developer__c developer = [
        //             SELECT Id, Name, Total_Billable_Projects__c, Last_Sync_Date__c 
        //             FROM Developer__c 
        //             WHERE Id = :currentDeveloperId];
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
                    Developer devToUpdate = (Developer)JSON.deserialize(response.getBody(), Developer.class);
                    // developer.Name = devToUpdate.name;
                    // developer.Total_Billable_Projects__c = devToUpdate.totalBillableProjects;
                    // developer.Last_Sync_Date__c = Datetime.now();
                    // system.debug(developer);
                    
                    // update developer;
                    // system.debug(developer);
                    return devToUpdate;
                }
        }catch(System.CalloutException e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}