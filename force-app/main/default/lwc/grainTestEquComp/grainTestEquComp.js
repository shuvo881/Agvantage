import { LightningElement, track } from 'lwc';
import grainTestEquImg from '@salesforce/resourceUrl/GrainTestEquImg';
import images from '@salesforce/resourceUrl/Products_imgs';

export default class ProductsComp extends LightningElement {

    @track grainImg = images + '/Products_imgs/gain.jpg';
    @track grainTestImg = grainTestEquImg + '/GrainTestEquImg/cropScan.jpg';
}