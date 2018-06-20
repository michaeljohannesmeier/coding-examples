import { Component, OnInit } from '@angular/core';
import {Fahrrad} from '../fahrrad.model';
import {FahrradService} from '../fahrrad-service';
import {ActivatedRoute, Params, Router} from '@angular/router';
import {Http} from '@angular/http';

@Component({
  selector: 'app-fahrrad-detail-component',
  templateUrl: './fahrrad-detail.component.html',
  styleUrls: ['./fahrrad-detail.component.css']
})
export class FahrradDetailComponent implements OnInit {
  fahrrad: Fahrrad;
  id: string;
  myImage: string;

  constructor(private fahrradService: FahrradService,
              private router: Router,
              private route: ActivatedRoute,
              private http: Http) { }

  ngOnInit() {
    this.route.params.subscribe(
      (params: Params) => {
        this.id = params['id'];
        this.fahrrad = this.fahrradService.getFahrrad(this.id);
        this.myImage = this.fahrradService.getFahrrad(this.id).image.data;
      }
    );
  }

}
