import {Component, OnInit} from '@angular/core';
import {LoggingService} from '../logging.service';

@Component({
  selector: 'app-subscriber',
  templateUrl: './subscriber.component.html',
  styleUrls: ['./subscriber.component.css']
})
export class SubscriberComponent implements OnInit {

  constructor(private myLogService: LoggingService) { }

  ngOnInit() {
  }

  showTableData() {
    this.myLogService.eventPressButton.emit();
    console.log("event emitted");

  }


}
