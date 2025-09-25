import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTimeLog from '@salesforce/apex/TimeLogController.createTimeLog';

export default class TimeLogger extends LightningElement {
    // The @api decorator makes the recordId available from the project page
    @api recordId;

    // Properties to store the form input values
    hours;
    description;

    // Handles changes to the "Hours" input field
    handleHoursChange(event) {
        this.hours = event.target.value;
    }

    // Handles changes to the "Description" input field
    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    // This function is called when the "Log Time" button is clicked
    handleLogTime() {
        // Basic validation to ensure hours are entered
        if (!this.hours) {
            this.showToast('Error', 'Please enter the number of hours.', 'error');
            return;
        }

        // Imperative call to the Apex method to create the record
        createTimeLog({ hours: this.hours, description: this.description, projectId: this.recordId })
            .then(result => {
                // Show a success message
                this.showToast('Success', 'Time logged successfully!', 'success');
                // Reset the form fields
                this.template.querySelector('lightning-input').value = null;
                this.template.querySelector('lightning-textarea').value = null;
                this.hours = null;
                this.description = null;
            })
            .catch(error => {
                // Show an error message
                this.showToast('Error Logging Time', error.body.message, 'error');
            });
    }

    // Helper function to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}