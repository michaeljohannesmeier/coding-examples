import {Directive, ElementRef, HostBinding, HostListener, Input, OnInit, Renderer2} from '@angular/core';

@Directive({
  selector: '[appBetterHighlight]'
})
export class BetterHighlightDirective implements OnInit{
  @Input() defaultColor: string= 'yellow';
  @Input() highlightColor: string= 'red';
  @HostBinding('style.backgroundColor') backgroundColor: string;


  constructor(private myEl: ElementRef,  private renderer: Renderer2) { }

  ngOnInit() {
    //this.renderer.setStyle(this.myEl.nativeElement, 'background-color', 'blue');
    this.backgroundColor = this.defaultColor;
  }

  @HostListener('mouseenter') myMouseover(eventData: Event) {
    //this.renderer.setStyle(this.myEl.nativeElement, 'background-color', 'blue');
    this.backgroundColor = this.highlightColor;
  }
  @HostListener('mouseleave') myMouseleave(eventData: Event) {
    //this.renderer.setStyle(this.myEl.nativeElement, 'background-color', 'transparent');
    this.backgroundColor = this.defaultColor;
  }

}
