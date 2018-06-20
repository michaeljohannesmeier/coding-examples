import { Component, OnInit } from '@angular/core';
import {TableData} from '../table-data.module';
import {DataService} from '../data.service';
import {LoggingService} from '../logging.service';

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css'],
  providers: [DataService]
})
export class TableComponent implements OnInit {


  myDataTable: TableData[] = [];
  boolButtonPressed: boolean = false;

  constructor(private myDataService: DataService,
              private myLogService: LoggingService) {
    this.myLogService.eventPressButton.subscribe(
      () => {
        this.boolButtonPressed = true;
        alert("test");
      }
    )
  }

  ngOnInit() {
    this.myDataTable = this.myDataService.getMyData();
    this.myLogService.logStatusChange('fresh so far');

  }

  showTableData() {

  }

}
