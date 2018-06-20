import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { AppBarChartComponent } from './app-bar-chart/app-bar-chart.component';


@NgModule({
  declarations: [
    AppComponent,
    AppBarChartComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
