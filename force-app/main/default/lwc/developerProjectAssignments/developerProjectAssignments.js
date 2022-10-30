import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRelatedProjectAssignments from '@salesforce/apex/GetRelatedProjectAssignmentsController.getRelatedProjectAssignments';
import getDeveloperByIdAndUpdate from '@salesforce/apex/GetDeveloperByIdAndUpdate.getDeveloperByIdAndUpdate';


const columns = [
    { label: 'Project Assignment Number', fieldName: 'Project_Assignment_Number__c', type: 'text', cellAttributes: { alignment: 'center' } },
    { label: 'Name', fieldName: 'Name', type: 'text', cellAttributes: { alignment: 'center'}},
];


export default class DeveloperProjectAssignments extends LightningElement {

    @api recordId;
    //@api objectName = 'Developer__c';
    @api sObjData;
    updatedsObjData;
    columns = columns;
    projectAssignments;
    
    error;
    
    @wire(getRelatedProjectAssignments, {currentDeveloperId: '$recordId'}) projectassignments;
    @wire(getDeveloperByIdAndUpdate, ({currentDeveloperId: '$recordId'})) sObjData;
    


    wiredRelatedProjectAssignments({error, data}){
        if(data){
            this.projectAssignments = data;
        } else if (error){
            this.error = error;
        }
    }


    wiredGetDeveloperByIdAndUpdate({error, data}){
        if(data){
            this.sObjData = data;
        } else if (error){
            this.error = error;
        }
    }

     handleClick(){
     this.sObjData = this.updatedsObjData;
     
    }
    
    
    
   /* showInfoToast() {
    const evt = new ShowToastEvent({
        title: 'Info',
        message: 'Refresh is not yet configured',
        variant: 'info',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
}*/
   
}