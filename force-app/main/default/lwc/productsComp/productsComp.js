import { LightningElement, track } from 'lwc';
import images from '@salesforce/resourceUrl/Products_imgs';

export default class ProductsComp extends LightningElement {
    @track bannarImg = images + '/Products_imgs/banner.jpg';
    @track kwikImg = images + '/Products_imgs/kwik.jpg';
    @track gainImg = images + '/Products_imgs/gain.jpg';
}