import {Component, OnInit} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  activeClass: string = '';

  constructor(private router: Router,
              private route: ActivatedRoute) { }

  ngOnInit() {
    this.activeClass = 'active';
  }
  toggleActive() {
    location.reload();
  }




}
