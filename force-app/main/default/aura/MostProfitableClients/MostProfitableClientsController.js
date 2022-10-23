({
	doInit : function(component, event, helper) {
        
        helper.setColumns(component);
        helper.getClients(component, event, helper);
		
	},
    
    reLoadClients: function(component, event, helper) {
    
    	helper.getClients(component, event, helper);	
	
	}
})