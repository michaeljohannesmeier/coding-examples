import { Component, OnInit } from '@angular/core';
import {Fahrrad} from '../fahrrad.model';
import {FahrradService} from '../fahrrad-service';
import {Subscription} from 'rxjs/Subscription';

@Component({
  selector: 'app-fahrrad-list',
  templateUrl: './fahrrad-list.component.html',
  styleUrls: ['./fahrrad-list.component.css']
})
export class FahrradListComponent implements OnInit {
  subscription: Subscription;
  fahrrads: Fahrrad[];

  constructor(private fahrradService: FahrradService) { }

  ngOnInit() {
    this.subscription = this.fahrradService.fahrradsChanged.subscribe(
      (fahrrads: Fahrrad[]) => {
        this.fahrrads = fahrrads;
      }
    );
    this.fahrradService.getAllFahrrads();
  }

}
