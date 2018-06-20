import {Component, Input} from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  propertyOfAppComponentButFromChild: string;
  propertyToPassToChildWithNgContent: string = "text set in parent";

  valueForSwith: number = 5;


  catchEvent(eventString: string) {
    this.propertyOfAppComponentButFromChild = eventString;
  }
}
