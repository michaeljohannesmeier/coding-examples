import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import { AccountComponent } from './account/account.component';
import { NewAccountComponent } from './new-account/new-account.component';
import { TableComponent } from './table/table.component';
import { SubscriberComponent } from './subscriber/subscriber.component';


@NgModule({
  declarations: [
    AppComponent,
    AccountComponent,
    NewAccountComponent,
    TableComponent,
    SubscriberComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
