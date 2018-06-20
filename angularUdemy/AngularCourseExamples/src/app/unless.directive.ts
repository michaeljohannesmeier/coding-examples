import {Directive, Input, TemplateRef, ViewContainerRef} from '@angular/core';

@Directive({
  selector: '[appUnless]'
})
export class UnlessDirective {
  @Input() set appUnless(condition:boolean) {
    if (!condition) {
      this.myVcRef.createEmbeddedView(this.myTempRef);
    } else {
      this.myVcRef.clear();
    }

  }

  constructor(private myTempRef: TemplateRef<any>, private myVcRef: ViewContainerRef) { }

}
