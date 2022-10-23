public with sharing class ProjectAssignmentTriggerHandler {

   public static void onBeforeInsert(List<Project_Assignment__c> newPas) {
        List<Project_Assignment__c> oldPas = new List<Project_Assignment__c>([SELECT Developer__c, Project__c FROM Project_Assignment__c]);
            for(Project_Assignment__c oldPa : oldPas){
                for (Project_Assignment__c newPa : newPas){
                    if(newPa.Developer__c == oldPa.Developer__c && newPa.Project__c == oldPa.Project__c){
                    newPa.addError('A Project Assignmen with the same developer and project already exists');
                    }
                }
            }
    }

     //Total Billable Projects of the Developer should be recalculated each time a new Project Assignment is created
                                      //попробувати з нью мап
    public static void onAfterInsert(List<Project_Assignment__c> newPas) {

        Set<id> ProjectAssignment2Developer = new Set<id>();
   
        for (Project_Assignment__c newPa : newPas) {
            //тут вирішила перевірити чи проект Billable, бо якщо ні, то нам в сеті цей Id не потрібний
            if(newPa.Project__r.Is_Billable__c){
           ProjectAssignment2Developer.add(newPa.Developer__c);
            }
        }
        
        List<Developer__c> developers = [
                SELECT Id, Total_Billable_Projects__c
                FROM Developer__c
                WHERE Id IN :ProjectAssignment2Developer
        ];
        system.debug(developers);
        
        AggregateResult [] devs = [
            SELECT Developer__r.Id,
            COUNT(Developer__r.Total_Billable_Projects__c)
            FROM Project_Assignment__c
            WHERE Developer__r.Id IN :ProjectAssignment2Developer
            GROUP BY Developer__r.Id];
         system.debug(devs);
        
        for (Developer__c developer : developers) {
        for (AggregateResult dev : devs) {
            for (id devId : ProjectAssignment2Developer){
                if(ProjectAssignment2Developer.contains(dev.Id)){
                	if(devId == dev.Id){
                integer totalBillableProjects = integer.valueof(dev.get('expr0'));
                developer.Total_Billable_Projects__c = totalBillableProjects += 1;  
                	}  
            	}         
            }
        }
     }
                update developers;
        system.debug(developers);
        }

        public static void onAfterUpdate(Map<Id, Project_Assignment__c> oldAssignmentsMap, List<Project_Assignment__c> newAssignments) {
         //Total Billable Projects of the Developer should be recalculated each time Is Billable field is changed on the Project
         Set<id> devIds = new Set<id>();
         
          for (Project_Assignment__c newAssignment : newAssignments) {
           devIds.add(newAssignment.Developer__c);
            
        }
         
          List<Developer__c> developers = [
                SELECT Id, Total_Billable_Projects__c
                FROM Developer__c
                WHERE Id IN :devIds
        ];
            
             AggregateResult [] devs = [
            SELECT Developer__r.Id,
            COUNT(Developer__r.Total_Billable_Projects__c)
            FROM Project_Assignment__c
            WHERE Developer__r.Id IN :devIds
            GROUP BY Developer__r.Id];
         system.debug(devs);
         
        for (Project_Assignment__c newAssignment : newAssignments) {
            Project_Assignment__c oldAssignment = oldAssignmentsMap.get(newAssignment.Id);
        
            if (oldAssignment.Project__r.Is_Billable__c != newAssignment.Project__r.Is_Billable__c) {
                for(Developer__c developer:developers ){
                    for(AggregateResult dev:devs){
                    integer totalBillableProjects = integer.valueof(dev.get('expr0'));
                if(newAssignment.Project__r.Is_Billable__c){
                    developer.Total_Billable_Projects__c = totalBillableProjects += 1;
                } else  developer.Total_Billable_Projects__c = totalBillableProjects -= 1;
                }
            }
                
            }
        }
        
         update developers;
    }
    }