import {Component, Inject, OnInit, ViewEncapsulation} from '@angular/core';
import {ScrollToService} from '../scrollTo.service';
/*import * as $ from 'jquery';*/
import { AosToken } from '../aos';


import * as AOS from 'aos';

@Component({
  selector: 'app-bananas',
  templateUrl: './bananas.component.html',
  styleUrls: ['./bananas.component.css'],
  encapsulation: ViewEncapsulation.None
})
export class BananasComponent implements OnInit {

  constructor(private scrollService: ScrollToService
              ) {

  }

  ngOnInit() {
    this.scrollService.setScroll(0, 0);
    AOS.init({
      duration: 3000
    });
  }
}



