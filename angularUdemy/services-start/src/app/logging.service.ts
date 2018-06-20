import {EventEmitter} from '@angular/core';

export class LoggingService {

  eventPressButton = new EventEmitter();

  logStatusChange(status: string){
    console.log('A server status changed, new status ' + status);
  }
}
