import { LightningElement, track } from 'lwc';
import images from '@salesforce/resourceUrl/Products_imgs';

export default class ProductsComp extends LightningElement {
    @track kwikImg = images + '/Products_imgs/kwik.jpg';
}