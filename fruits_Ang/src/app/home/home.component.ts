import { Component, OnInit } from '@angular/core';
import {ScrollToService} from '../scrollTo.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(private scrollService: ScrollToService) { }

  ngOnInit() {
    this.scrollService.setScroll(0,0);
  }
  toggleActive() {
    location.reload();
  }

}
