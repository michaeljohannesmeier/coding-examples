import {Component, OnInit, Input, Output, EventEmitter, ViewChild, ElementRef} from '@angular/core';

@Component({
  selector: 'app-subone',
  templateUrl: './subone.component.html',
  styleUrls: ['./subone.component.css']
})
export class SuboneComponent implements OnInit {
  property: string = "test";
  ngModelProperty: string;
  ngModelPTag: string = "ngModel in p tag";
  ngIfBool: boolean = false;
  nfIfArray: number[] = [1,43,32,3];
  myColorFromJSProp: string = 'green';

  disableButton: boolean = false;
  buttonAutoFocus: boolean = false;

  @Input() exposedProperty: string;
  @Output() emittedProperty = new EventEmitter<string>();
  @ViewChild('localRefOfP') viewPointContentFromP: ElementRef;

  viewPointMethod() {
    console.log(this.viewPointContentFromP);
  }

  constructor() { }

  ngOnInit() {
    this.emittedProperty.emit("string to pass to parent on init");
  }

  willTriggerToParent(){
    this.emittedProperty.emit("string to pass to parent after click");
  }

  myFunctionClick(eventDataClick) {
    console.log(eventDataClick);
    this.property = "changed by click event";
  }
  myFunctionMouseLeave(eventData: MouseEvent) {
    console.log("Event data mouse leave " + eventData.pageX);
    this.property = "changed by mouseleave";
  }

  mouseOverFunktion(element: HTMLParagraphElement) {
    console.log(element.innerText)
  }


}
