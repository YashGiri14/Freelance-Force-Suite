import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTimeLog from '@salesforce/apex/TimeLogController.createTimeLog';

export default class TimeLogger extends LightningElement {
    @api recordId; // Automatically gets the Project ID from the record page

    logDate = new Date().toISOString().slice(0, 10); // Default to today
    hours;
    description;

    handleDateChange(event) {
        this.logDate = event.target.value;
    }

    handleHoursChange(event) {
        this.hours = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleLogTime() {
        if (!this.logDate || !this.hours) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Date and Hours are required fields.',
                    variant: 'error'
                })
            );
            return;
        }

        createTimeLog({ projectId: this.recordId, logDate: this.logDate, hours: this.hours, description: this.description })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Time log created successfully!',
                        variant: 'success'
                    })
                );
                // Reset form
                this.hours = null;
                this.description = '';
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}