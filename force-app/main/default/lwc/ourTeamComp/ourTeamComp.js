import 	OurTeam_imgs from '@salesforce/resourceUrl/OurTeam_imgs';
import { LightningElement, track } from 'lwc';

export default class OurTeamComp extends LightningElement {
    @track bannerImg = OurTeam_imgs + '/OurTeam_imgs/banner.jpg'
    @track ManagingDirImag = OurTeam_imgs + '/OurTeam_imgs/managing_director.jpg'
    @track directorImg = OurTeam_imgs + '/OurTeam_imgs/director.jpg'
}