import { LightningElement, api, wire, track } from 'lwc';
import { getRecord ,getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
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
        console.log(this.record.data.fields.Total_Billable_Projects__c.value);
     console.log(this.record.data.fields.Name.value);
     console.log(this.record.data.fields.Last_Sync_Date__c.value);
    console.log(this.recordId);
    getDeveloperByIdAndUpdate (this.recordId)
        .then(devToUpdate =>{
            this.record = devToUpdate;;
            //тут вказуємо,що змінили рекорд
            //getRecordNotifyChange([{recordId: this.recordId}]);
            console.log('++++++');
             console.log(devToUpdate);
        })
        // .catch(error => {
        //     this.error = error;
        //        console.log(error); 
        // })
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