import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRelatedProjectAssignments from '@salesforce/apex/GetRelatedProjectAssignmentsController.getRelatedProjectAssignments';


const columns = [
    { label: 'Project Assignment Number', fieldName: 'Project_Assignment_Number__c', type: 'text', cellAttributes: { alignment: 'center' } },
    { label: 'Name', fieldName: 'Name', type: 'text', cellAttributes: { alignment: 'center'}},
];


export default class DeveloperProjectAssignments extends LightningElement {

    @api recordId
    columns = columns
    @wire(getRelatedProjectAssignments, {currentDeveloperId: '$recordId'}) projectassignments;
    
    


    connectedCallback() {
        getRelatedProjectAssignments(this.recordId);
    }


    showInfoToast() {
    const evt = new ShowToastEvent({
        title: 'Info',
        message: 'Refresh is not yet configured',
        variant: 'info',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
}
   
}