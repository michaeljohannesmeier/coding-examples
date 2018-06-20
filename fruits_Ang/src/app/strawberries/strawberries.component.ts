import { Component, OnInit } from '@angular/core';
import {ScrollToService} from '../scrollTo.service';
import * as $ from 'jquery';
import * as AOS from 'aos';

@Component({
  selector: 'app-strawberries',
  templateUrl: './strawberries.component.html',
  styleUrls: ['./strawberries.component.css']
})
export class StrawberriesComponent implements OnInit {

  constructor(private scrollService: ScrollToService) { }

  ngOnInit() {
    this.scrollService.setScroll(0, 0);
    AOS.init({
      duration: 3000
    });

  }

  onNavigate(section: string) {
    const x = document.querySelector('#' + section);
    console.log(x);
    if (x) {
      x.scrollIntoView();
    }
  }



}
