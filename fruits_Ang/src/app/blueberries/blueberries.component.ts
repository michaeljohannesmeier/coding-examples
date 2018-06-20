import { Component, OnInit } from '@angular/core';
import {ScrollToService} from '../scrollTo.service';

@Component({
  selector: 'app-blueberries',
  templateUrl: './blueberries.component.html',
  styleUrls: ['./blueberries.component.css']
})
export class BlueberriesComponent implements OnInit {

  constructor(private scrollService: ScrollToService) { }

  ngOnInit() {
    this.scrollService.setScroll(0, 0);
  }

}
