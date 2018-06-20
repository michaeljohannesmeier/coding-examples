import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {FahrradListComponent} from './fahrrad-list/fahrrad-list.component';
import {ContactComponent} from './contact/contact.component';
import {FahrradDetailComponent} from './fahrrad-detail/fahrrad-detail.component';


const appRoutes: Routes = [
  {path: '', component: FahrradListComponent},
  {path: 'detail/:id', component: FahrradDetailComponent},
  {path: 'contact', component: ContactComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes)],
  exports: [RouterModule]
})
export class AppRoutingModule {

}
