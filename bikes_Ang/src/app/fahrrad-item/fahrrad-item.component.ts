import {Component, Input, OnInit} from '@angular/core';
import {Fahrrad} from '../fahrrad.model';

@Component({
  selector: 'app-fahrrad-item',
  templateUrl: './fahrrad-item.component.html',
  styleUrls: ['./fahrrad-item.component.css']
})
export class FahrradItemComponent implements OnInit {
  @Input() fahrrad: Fahrrad;
  @Input() id: string;

  constructor() { }

  ngOnInit() {
  }

}
