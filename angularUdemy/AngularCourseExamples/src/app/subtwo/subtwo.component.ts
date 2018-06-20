import {Component, ContentChild, ElementRef, OnInit, ViewChild} from '@angular/core';

@Component({
  selector: 'app-subtwo',
  templateUrl: './subtwo.component.html',
  styleUrls: ['./subtwo.component.css']
})
export class SubtwoComponent implements OnInit {
  @ContentChild('tagInParentNgContent') varHoldingContentChild: ElementRef;

  constructor() { }

  functionViewChildNgContent() {
    console.log("var holding content child");
    console.log(this.varHoldingContentChild);
  }

  ngOnInit() {

  }

}
