import { Component } from '@angular/core';

@Component({
  selector: 'app-server',
  templateUrl: './server.component.html',
  styles: [`
    .online {
      color: white;
    }
  `]
})
export class ServerComponent {
  serverId: number = 10;
  serverStatus: string = "offline";
  secretPassowrt : string = "Secret passwort equals tuna";
  secretPasswortCount: number = 0;
  clickArray = [];

  constructor () {
    this.serverStatus = Math.random() > 0.5 ? 'online' : 'offline';
  }

  getDisplay() {
    return this.secretPasswortCount % 2 === 0 ? 'none' : 'inline';
  }
  getColorDisplay() {
    return this.secretPasswortCount > 5 ? 'white' : 'black';
  }
  changeDetailBool() {
    this.clickArray.push(this.secretPasswortCount);
    this.secretPasswortCount += 1;
  }

  getServerStatus() {
    return this.serverStatus;
  }
  getColor() {
    return this.serverStatus === 'online' ? 'green' : 'red';
  }

}
