import Logo from '@salesforce/resourceUrl/Logo'
// import forgotPassword from'@salesforce/apex/ForgotPassController.customForgotPassword'
import { LightningElement, track } from 'lwc';

export default class Temp1ForgotPassComp extends LightningElement {
    @track company_logo = Logo + '/Logos/logoBig.png';
    @track username = '';
    errorMessage = ''; // I will show occure an error
    handleUsername(event){
        this.username = event.target.value;
    }

    
    handlesend(){
        // console.log(this.username);
        // forgotPassword({username:this.username})
        // .then(response => {
        //     this.errorMessage = response
        //     console.log('response', response)
        // })
        // .catch(error => {
        //     this.errorMessage = error.body
        //     console.log('error', error)
        // })
    }
}