import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {AddfahrradComponent} from './addfahrrad/addfahrrad.component';
import {FahrradListComponent} from './fahrrad-list/fahrrad-list.component';
import {FahrradDetailComponent} from './fahrrad-detail/fahrrad-detail.component';



const appRoutes: Routes = [
  {path: '', component: FahrradListComponent},
  {path: 'edit/:id', component: FahrradDetailComponent},
  {path: 'addfahrrad', component: AddfahrradComponent}

];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes)],
  exports: [RouterModule]
})
export class AppRoutingModule {

}
