({
	setColumns : function(component) {
        
        component.set('v.columns', [
            {label: 'Client', fieldName: 'Name', type: 'text'},
            {label: 'Total Active Projects', fieldName: 'Total_Active_Projects__c', type: 'Integer'},
            {label: 'Budget', fieldName: 'Budget__c', type: 'currency'}
        ]);
		
	},
    
    getClients : function(component, event,helper) {
    
        var action = component.get("c.getMostProfitableClients");
    
    action.setParams({
    "limitNumber": component.get("v.limitNumber")
	});

	action.setCallback(this, function(response){
        component.set("v.clients", response.getReturnValue());
    });
       $A.enqueueAction(action); 
	}
})