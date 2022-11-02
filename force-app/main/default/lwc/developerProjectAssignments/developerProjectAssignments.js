import { LightningElement, api, wire, track } from 'lwc';
import { getRecord ,getRecordNotifyChange } from 'lightning/uiRecordApi';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRelatedProjectAssignments from '@salesforce/apex/GetRelatedProjectAssignmentsController.getRelatedProjectAssignments';
import getDeveloperByIdAndUpdate from '@salesforce/apex/GetDeveloperByIdAndUpdate.getDeveloperByIdAndUpdate';


const columns = [
    { label: 'Project Assignment Number', fieldName: 'Project_Assignment_Number__c', type: 'text', cellAttributes: { alignment: 'center' } },
    { label: 'Name', fieldName: 'Name', type: 'text', cellAttributes: { alignment: 'center'}},
];

const fields = [
    'Developer__c.Id',
    'Developer__c.Total_Billable_Projects__c',
    'Developer__c.Last_Sync_Date__c',
    'Developer__c.Name',
    ];


export default class DeveloperProjectAssignments extends LightningElement {

    @api recordId;
    columns = columns;
    projectAssignments;
    error;
    @wire(getRelatedProjectAssignments, {currentDeveloperId: '$recordId'}) projectassignments;
    //init рекорду
    @wire(getRecord, { recordId: '$recordId', fields: fields }) record;
    


    wiredRelatedProjectAssignments({error, data}){
        if(data){
            this.projectAssignments = data;
        } else if (error){
            this.error = error;
        }
    }

    handleClick(){
    
        getDeveloperByIdAndUpdate ({currentDeveloperId:this.recordId})
        
        .then(data =>{      //тут вказуємо,що змінили рекорд
            this.record = data})
            getRecordNotifyChange(this.recordId)
        }
    
        
    /*showInfoToast() {
    const evt = new ShowToastEvent({
        title: 'Info',
        message: 'Refresh is not yet configured',
        variant: 'info',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
    }*/
}   
