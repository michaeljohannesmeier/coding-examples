webpackJsonp(["main"],{

/***/ "./src/$$_lazy_route_resource lazy recursive":
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncatched exception popping up in devtools
	return Promise.resolve().then(function() {
		throw new Error("Cannot find module '" + req + "'.");
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "./src/$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "./src/app/addfahrrad/addfahrrad.component.css":
/***/ (function(module, exports) {

module.exports = "input.ng-invalid.ng-touched,\r\ntextarea.ng-invalid.ng-touched{\r\n  border: 1px solid red;\r\n}\r\n"

/***/ }),

/***/ "./src/app/addfahrrad/addfahrrad.component.html":
/***/ (function(module, exports) {

module.exports = "\n<form [formGroup]=\"form\" (ngSubmit)=\"onSubmit()\">\n\n  <div class=\"row\">\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"name\">Name</label>\n        <input\n          type=\"text\"\n          id=\"name\"\n          formControlName=\"name\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n\n\n\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"price\">Price</label>\n        <input\n          type=\"text\"\n          id=\"price\"\n          formControlName=\"price\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"col-md-4 col-sm-6 col-xs-122\">\n      <div class=\"form-group\">\n        <label for=\"descriptionShort\">Description (short)</label>\n        <input\n          type=\"text\"\n          id=\"descriptionShort\"\n          formControlName=\"descriptionShort\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"descriptionLong\">Description (long)</label>\n        <input\n          type=\"text\"\n          id=\"descriptionLong\"\n          formControlName=\"descriptionLong\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"col-lg-12\">\n      <div class=\"form-group\">\n\n        <button class=\"btn btn-success\" type=\"button\" onclick=\"document.getElementById('image').click()\">\n          <input\n            type=\"file\"\n            id=\"image\"\n            formControlName=\"image\"\n            style=\"display:none\"\n            (change)=\"onFileChange($event)\"\n          >\n          Choose picture</button>\n      </div>\n      <img class=\"card-img-top\" *ngIf=\"!checkInputFile\" [src]=\"'data:jpg;base64,' +  myImage | unsafe \" alt=\"Fahrrad\" style=\"width:50px; height: 50px;\">\n      <br *ngIf=\"!checkInputFile\">\n      <br *ngIf=\"!checkInputFile\">\n    </div>\n  </div>\n  <div class=\"row\">\n    <div class=\"col-lg-12\">\n      <button type=\"submit\" [disabled]=\"form.invalid || checkInputFile\" class=\"btn btn-success\">Upload</button>\n    </div>\n  </div>\n  <br>\n  <br>\n  <br>\n</form>\n\n\n<!--\n\n<form method=\"post\" enctype=\"multipart/form-data\" action=\"/upload\">\n  <input type=\"hidden\" name=\"msgtype\" value=\"2\"/>\n  <input type=\"file\" name=\"avatar\" />\n  <input type=\"submit\" value=\"Upload\" />\n</form>\n-->\n\n"

/***/ }),

/***/ "./src/app/addfahrrad/addfahrrad.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AddfahrradComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__fahrrad_service__ = __webpack_require__("./src/app/fahrrad-service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};





var AddfahrradComponent = /** @class */ (function () {
    function AddfahrradComponent(http, router, route, fahrradService) {
        this.http = http;
        this.router = router;
        this.route = route;
        this.fahrradService = fahrradService;
        this.checkInputFile = true;
    }
    AddfahrradComponent.prototype.ngOnInit = function () {
        this.initForm();
    };
    AddfahrradComponent.prototype.onSubmit = function () {
        var _this = this;
        console.log(this.form.value);
        this.form.value.image = this.myImage;
        this.http.post('http://localhost:8081/postnewfahrrad', this.form.value).subscribe(function (response) {
            console.log('fahrrad posted');
            _this.fahrradService.getAllFahrrads();
            _this.router.navigate(['../'], { relativeTo: _this.route });
        });
    };
    AddfahrradComponent.prototype.onFileChange = function (event) {
        var _this = this;
        var reader = new FileReader();
        if (event.target.files && event.target.files.length > 0) {
            var file = event.target.files[0];
            reader.readAsDataURL(file);
            reader.onload = function () {
                console.log(reader.result.split(',')[1]);
                _this.checkInputFile = false;
                _this.myImage = reader.result.split(',')[1];
            };
        }
    };
    AddfahrradComponent.prototype.initForm = function () {
        var name = '';
        var price = '';
        var descriptionShort = '';
        var descriptionLong = '';
        this.form = new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["b" /* FormGroup */]({
            'name': new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormControl */](name, __WEBPACK_IMPORTED_MODULE_1__angular_forms__["e" /* Validators */].required),
            'price': new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormControl */](price, [__WEBPACK_IMPORTED_MODULE_1__angular_forms__["e" /* Validators */].required, __WEBPACK_IMPORTED_MODULE_1__angular_forms__["e" /* Validators */].pattern(/^[1-9]+[0-9]*$/)]),
            'descriptionShort': new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormControl */](descriptionShort, __WEBPACK_IMPORTED_MODULE_1__angular_forms__["e" /* Validators */].required),
            'descriptionLong': new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormControl */](descriptionLong, __WEBPACK_IMPORTED_MODULE_1__angular_forms__["e" /* Validators */].required),
            'image': new __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormControl */]('')
        });
    };
    AddfahrradComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-addfahrrad',
            template: __webpack_require__("./src/app/addfahrrad/addfahrrad.component.html"),
            styles: [__webpack_require__("./src/app/addfahrrad/addfahrrad.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_2__angular_http__["a" /* Http */],
            __WEBPACK_IMPORTED_MODULE_3__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_3__angular_router__["a" /* ActivatedRoute */],
            __WEBPACK_IMPORTED_MODULE_4__fahrrad_service__["a" /* FahrradService */]])
    ], AddfahrradComponent);
    return AddfahrradComponent;
}());



/***/ }),

/***/ "./src/app/app-routing.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppRoutingModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__addfahrrad_addfahrrad_component__ = __webpack_require__("./src/app/addfahrrad/addfahrrad.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__fahrrad_list_fahrrad_list_component__ = __webpack_require__("./src/app/fahrrad-list/fahrrad-list.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__fahrrad_detail_fahrrad_detail_component__ = __webpack_require__("./src/app/fahrrad-detail/fahrrad-detail.component.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};





var appRoutes = [
    { path: '', component: __WEBPACK_IMPORTED_MODULE_3__fahrrad_list_fahrrad_list_component__["a" /* FahrradListComponent */] },
    { path: 'edit/:id', component: __WEBPACK_IMPORTED_MODULE_4__fahrrad_detail_fahrrad_detail_component__["a" /* FahrradDetailComponent */] },
    { path: 'addfahrrad', component: __WEBPACK_IMPORTED_MODULE_2__addfahrrad_addfahrrad_component__["a" /* AddfahrradComponent */] }
];
var AppRoutingModule = /** @class */ (function () {
    function AppRoutingModule() {
    }
    AppRoutingModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["I" /* NgModule */])({
            imports: [__WEBPACK_IMPORTED_MODULE_1__angular_router__["c" /* RouterModule */].forRoot(appRoutes)],
            exports: [__WEBPACK_IMPORTED_MODULE_1__angular_router__["c" /* RouterModule */]]
        })
    ], AppRoutingModule);
    return AppRoutingModule;
}());



/***/ }),

/***/ "./src/app/app.component.css":
/***/ (function(module, exports) {

module.exports = ".center {\r\n  margin: auto;\r\n  width: 80%;\r\n}\r\n"

/***/ }),

/***/ "./src/app/app.component.html":
/***/ (function(module, exports) {

module.exports = "<app-header></app-header>\n\n\n<div class=\"center\">\n    <router-outlet></router-outlet>\n</div>\n\n"

/***/ }),

/***/ "./src/app/app.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};

var AppComponent = /** @class */ (function () {
    function AppComponent() {
        this.title = 'app';
    }
    AppComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-root',
            template: __webpack_require__("./src/app/app.component.html"),
            styles: [__webpack_require__("./src/app/app.component.css")]
        })
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "./src/app/app.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__ = __webpack_require__("./node_modules/@angular/platform-browser/esm5/platform-browser.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__app_component__ = __webpack_require__("./src/app/app.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__header_header_component__ = __webpack_require__("./src/app/header/header.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__addfahrrad_addfahrrad_component__ = __webpack_require__("./src/app/addfahrrad/addfahrrad.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__fahrrad_list_editfahrrad_editfahrrad_component__ = __webpack_require__("./src/app/fahrrad-list/editfahrrad/editfahrrad.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__app_routing_module__ = __webpack_require__("./src/app/app-routing.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__unsafe_pipe__ = __webpack_require__("./src/app/unsafe.pipe.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__fahrrad_list_fahrrad_list_component__ = __webpack_require__("./src/app/fahrrad-list/fahrrad-list.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__fahrrad_service__ = __webpack_require__("./src/app/fahrrad-service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__fahrrad_detail_fahrrad_detail_component__ = __webpack_require__("./src/app/fahrrad-detail/fahrrad-detail.component.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};













var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_1__angular_core__["I" /* NgModule */])({
            declarations: [
                __WEBPACK_IMPORTED_MODULE_2__app_component__["a" /* AppComponent */],
                __WEBPACK_IMPORTED_MODULE_3__header_header_component__["a" /* HeaderComponent */],
                __WEBPACK_IMPORTED_MODULE_4__addfahrrad_addfahrrad_component__["a" /* AddfahrradComponent */],
                __WEBPACK_IMPORTED_MODULE_5__fahrrad_list_editfahrrad_editfahrrad_component__["a" /* EditfahrradComponent */],
                __WEBPACK_IMPORTED_MODULE_9__unsafe_pipe__["a" /* UnsafePipe */],
                __WEBPACK_IMPORTED_MODULE_10__fahrrad_list_fahrrad_list_component__["a" /* FahrradListComponent */],
                __WEBPACK_IMPORTED_MODULE_12__fahrrad_detail_fahrrad_detail_component__["a" /* FahrradDetailComponent */]
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__["a" /* BrowserModule */],
                __WEBPACK_IMPORTED_MODULE_6__app_routing_module__["a" /* AppRoutingModule */],
                __WEBPACK_IMPORTED_MODULE_7__angular_forms__["c" /* FormsModule */],
                __WEBPACK_IMPORTED_MODULE_8__angular_http__["b" /* HttpModule */],
                __WEBPACK_IMPORTED_MODULE_7__angular_forms__["d" /* ReactiveFormsModule */]
            ],
            providers: [__WEBPACK_IMPORTED_MODULE_11__fahrrad_service__["a" /* FahrradService */]],
            bootstrap: [__WEBPACK_IMPORTED_MODULE_2__app_component__["a" /* AppComponent */]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/fahrrad-detail/fahrrad-detail.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/fahrrad-detail/fahrrad-detail.component.html":
/***/ (function(module, exports) {

module.exports = "\n\n\n<form [formGroup]=\"form\" (ngSubmit)=\"onSubmit()\">\n\n  <div class=\"row\">\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"name\">Name</label>\n        <input\n          type=\"text\"\n          id=\"name\"\n          formControlName=\"name\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n\n\n\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"price\">Price</label>\n        <input\n          type=\"text\"\n          id=\"price\"\n          formControlName=\"price\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"col-md-4 col-sm-6 col-xs-122\">\n      <div class=\"form-group\">\n        <label for=\"descriptionShort\">Description (short)</label>\n        <input\n          type=\"text\"\n          id=\"descriptionShort\"\n          formControlName=\"descriptionShort\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n\n    <div class=\"col-md-4 col-sm-6 col-xs-12\">\n      <div class=\"form-group\">\n        <label for=\"descriptionLong\">Description (long)</label>\n        <input\n          type=\"text\"\n          id=\"descriptionLong\"\n          formControlName=\"descriptionLong\"\n          class=\"form-control\"\n        >\n      </div>\n    </div>\n  </div>\n\n  <div class=\"row\">\n    <div class=\"col-lg-12\">\n      <div class=\"form-group\">\n\n        <button class=\"btn btn-success\" type=\"button\" onclick=\"document.getElementById('image').click()\">\n          <input\n            type=\"file\"\n            id=\"image\"\n            formControlName=\"image\"\n            style=\"display:none\"\n            (change)=\"onFileChange($event)\"\n          >\n          Choose picture</button>\n      </div>\n      <img class=\"card-img-top\" *ngIf=\"!checkInputFile\" [src]=\"'data:jpg;base64,' +  myImage | unsafe \" alt=\"Fahrrad\" style=\"width:50px; height: 50px;\">\n      <br *ngIf=\"!checkInputFile\">\n      <br *ngIf=\"!checkInputFile\">\n    </div>\n  </div>\n  <div class=\"row\">\n    <div class=\"col-lg-12\">\n      <button type=\"submit\" [disabled]=\"form.invalid || checkInputFile\" class=\"btn btn-success\">Update</button>\n    </div>\n  </div>\n  <br>\n  <br>\n  <br>\n</form>\n\n\n"

/***/ }),

/***/ "./src/app/fahrrad-detail/fahrrad-detail.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return FahrradDetailComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__fahrrad_service__ = __webpack_require__("./src/app/fahrrad-service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};





var FahrradDetailComponent = /** @class */ (function () {
    function FahrradDetailComponent(fahrradService, router, route, http) {
        this.fahrradService = fahrradService;
        this.router = router;
        this.route = route;
        this.http = http;
    }
    FahrradDetailComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.route.params.subscribe(function (params) {
            _this.id = params['id'];
            _this.fahrrad = _this.fahrradService.getFahrrad(_this.id);
            _this.myImage = _this.fahrradService.getFahrrad(_this.id).image.data;
        });
        this.initForm();
    };
    FahrradDetailComponent.prototype.onSubmit = function () {
        var _this = this;
        console.log(this.form.value);
        this.form.value.image = this.myImage;
        this.form.value._id = this.id;
        this.http.post('http://localhost:8081/editfahrrad', this.form.value).subscribe(function (response) {
            console.log('fahrrad updated');
            _this.fahrradService.getAllFahrrads();
            _this.router.navigate(['../../'], { relativeTo: _this.route });
        });
    };
    FahrradDetailComponent.prototype.onFileChange = function (event) {
        var _this = this;
        var reader = new FileReader();
        if (event.target.files && event.target.files.length > 0) {
            var file = event.target.files[0];
            reader.readAsDataURL(file);
            reader.onload = function () {
                console.log(reader.result.split(',')[1]);
                _this.myImage = reader.result.split(',')[1];
            };
        }
    };
    FahrradDetailComponent.prototype.initForm = function () {
        var name = this.fahrrad.name;
        var price = this.fahrrad.price;
        var descriptionShort = this.fahrrad.descriptionShort;
        var descriptionLong = this.fahrrad.descriptionLong;
        this.form = new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["b" /* FormGroup */]({
            'name': new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["a" /* FormControl */](name, __WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* Validators */].required),
            'price': new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["a" /* FormControl */](price, [__WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* Validators */].required, __WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* Validators */].pattern(/^[1-9]+[0-9]*$/)]),
            'descriptionShort': new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["a" /* FormControl */](descriptionShort, __WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* Validators */].required),
            'descriptionLong': new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["a" /* FormControl */](descriptionLong, __WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* Validators */].required),
            'image': new __WEBPACK_IMPORTED_MODULE_3__angular_forms__["a" /* FormControl */]('')
        });
    };
    FahrradDetailComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-fahrrad-detail',
            template: __webpack_require__("./src/app/fahrrad-detail/fahrrad-detail.component.html"),
            styles: [__webpack_require__("./src/app/fahrrad-detail/fahrrad-detail.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__fahrrad_service__["a" /* FahrradService */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["a" /* ActivatedRoute */],
            __WEBPACK_IMPORTED_MODULE_4__angular_http__["a" /* Http */]])
    ], FahrradDetailComponent);
    return FahrradDetailComponent;
}());



/***/ }),

/***/ "./src/app/fahrrad-list/editfahrrad/editfahrrad.component.css":
/***/ (function(module, exports) {

module.exports = "\r\n.floater {\r\n  float: left;\r\n  margin: 1%;\r\n}\r\n.card {\r\n  width: 300px;\r\n}\r\n.card-img-top {\r\n  height: 300px;\r\n}\r\n"

/***/ }),

/***/ "./src/app/fahrrad-list/editfahrrad/editfahrrad.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"card floater\">\n  <img class=\"card-img-top\" [src]=\"'data:jpg;base64,' +  fahrrad.image.data | unsafe \" alt=\"Fahrrad\" style=\"width:100%\">\n  <div class=\"card-body\">\n    <h5 style=\"float: left\">{{ fahrrad.name }}</h5>\n    <h5 style=\"float: right\">{{ fahrrad.price }}€ </h5>\n    <p style=\"clear: left\" class=\"card-text\">{{ fahrrad.descriptionShort }}</p>\n    <a [routerLink]=\"'edit/' + [id]\" class=\"btn btn-primary\">Edit</a>\n    <a (click)=\"onDelete()\" class=\"btn btn-danger\">Delete</a>\n    <!--<a [href]=\"'/fahrraddelete/' + [id]\" class=\"btn btn-danger\">Löschen</a>-->\n  </div>\n</div>\n\n\n\n"

/***/ }),

/***/ "./src/app/fahrrad-list/editfahrrad/editfahrrad.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return EditfahrradComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__fahrrad_model__ = __webpack_require__("./src/app/fahrrad.model.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__fahrrad_service__ = __webpack_require__("./src/app/fahrrad-service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};





var EditfahrradComponent = /** @class */ (function () {
    function EditfahrradComponent(http, router, route, fahrradService) {
        this.http = http;
        this.router = router;
        this.route = route;
        this.fahrradService = fahrradService;
    }
    EditfahrradComponent.prototype.onDelete = function () {
        var _this = this;
        var myBody = {
            id: this.id
        };
        this.http.post('http://localhost:8081/fahrraddelete', myBody).subscribe(function (response) {
            console.log('fahrrad deleted');
            _this.fahrradService.getAllFahrrads();
        });
    };
    EditfahrradComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["D" /* Input */])(),
        __metadata("design:type", __WEBPACK_IMPORTED_MODULE_1__fahrrad_model__["a" /* Fahrrad */])
    ], EditfahrradComponent.prototype, "fahrrad", void 0);
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["D" /* Input */])(),
        __metadata("design:type", String)
    ], EditfahrradComponent.prototype, "id", void 0);
    EditfahrradComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-editfahrrad',
            template: __webpack_require__("./src/app/fahrrad-list/editfahrrad/editfahrrad.component.html"),
            styles: [__webpack_require__("./src/app/fahrrad-list/editfahrrad/editfahrrad.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_2__angular_http__["a" /* Http */],
            __WEBPACK_IMPORTED_MODULE_3__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_3__angular_router__["a" /* ActivatedRoute */],
            __WEBPACK_IMPORTED_MODULE_4__fahrrad_service__["a" /* FahrradService */]])
    ], EditfahrradComponent);
    return EditfahrradComponent;
}());



/***/ }),

/***/ "./src/app/fahrrad-list/fahrrad-list.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/fahrrad-list/fahrrad-list.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"fahrrad-container\">\n  <app-editfahrrad\n    *ngFor=\"let fahrrad of fahrrads\"\n    [fahrrad]=\"fahrrad\"\n    [id]=\"fahrrad._id\"\n  ></app-editfahrrad>\n</div>\n\n\n\n"

/***/ }),

/***/ "./src/app/fahrrad-list/fahrrad-list.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return FahrradListComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__fahrrad_service__ = __webpack_require__("./src/app/fahrrad-service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var FahrradListComponent = /** @class */ (function () {
    function FahrradListComponent(fahrradService) {
        this.fahrradService = fahrradService;
    }
    FahrradListComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.fahrradService.fahrradsChanged.subscribe(function (fahrrads) {
            _this.fahrrads = fahrrads;
        });
        this.fahrradService.getAllFahrrads();
    };
    FahrradListComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-fahrrad-list',
            template: __webpack_require__("./src/app/fahrrad-list/fahrrad-list.component.html"),
            styles: [__webpack_require__("./src/app/fahrrad-list/fahrrad-list.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__fahrrad_service__["a" /* FahrradService */]])
    ], FahrradListComponent);
    return FahrradListComponent;
}());



/***/ }),

/***/ "./src/app/fahrrad-service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return FahrradService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_rxjs_Subject__ = __webpack_require__("./node_modules/rxjs/_esm5/Subject.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var FahrradService = /** @class */ (function () {
    function FahrradService(http) {
        this.http = http;
        this.fahrradsChanged = new __WEBPACK_IMPORTED_MODULE_1_rxjs_Subject__["a" /* Subject */]();
    }
    FahrradService.prototype.getAllFahrrads = function () {
        var _this = this;
        this.http.get('http://localhost:8081/getallfahrrads').subscribe(function (response) {
            console.log(response);
            _this.fahrrads = response.json();
            console.log(_this.fahrrads);
            _this.fahrradsChanged.next(_this.fahrrads.slice());
        });
    };
    FahrradService.prototype.getFahrrad = function (id) {
        for (var i = 0; i < this.fahrrads.length; i++) {
            if (this.fahrrads[i]._id === id) {
                return this.fahrrads[i];
            }
        }
    };
    FahrradService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["A" /* Injectable */])(),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_2__angular_http__["a" /* Http */]])
    ], FahrradService);
    return FahrradService;
}());



/***/ }),

/***/ "./src/app/fahrrad.model.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return Fahrrad; });
var Fahrrad = /** @class */ (function () {
    function Fahrrad(_id, name, price, descriptionShort, descriptionLong, image) {
        this._id = _id;
        this.name = name;
        this.price = price;
        this.descriptionShort = descriptionShort;
        this.descriptionLong = descriptionLong;
        this.image = image;
    }
    return Fahrrad;
}());



/***/ }),

/***/ "./src/app/header/header.component.css":
/***/ (function(module, exports) {

module.exports = ".navbaritems a {\r\n  color: white;\r\n  padding: 0 20px 20px 0;\r\n  font-size: 1.3em;\r\n}\r\n.navbarwidth {\r\n  width: 90%;\r\n  margin: auto;\r\n}\r\n"

/***/ }),

/***/ "./src/app/header/header.component.html":
/***/ (function(module, exports) {

module.exports = "<nav class=\"navbar navbar-expand-sm bg-dark navbar-dark\">\n  <ul class=\"navbar-nav navbaritems navbarwidth\">\n    <li routerLinkActive=\"active\"><a routerLink=\"/\">Edit bikes</a></li>\n    <li routerLinkActive=\"active\"><a routerLink=\"/addfahrrad\">Add bike</a></li>\n  </ul>\n</nav>\n<br>\n"

/***/ }),

/***/ "./src/app/header/header.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return HeaderComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var HeaderComponent = /** @class */ (function () {
    function HeaderComponent() {
    }
    HeaderComponent.prototype.ngOnInit = function () {
    };
    HeaderComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-header',
            template: __webpack_require__("./src/app/header/header.component.html"),
            styles: [__webpack_require__("./src/app/header/header.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], HeaderComponent);
    return HeaderComponent;
}());



/***/ }),

/***/ "./src/app/unsafe.pipe.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return UnsafePipe; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_platform_browser__ = __webpack_require__("./node_modules/@angular/platform-browser/esm5/platform-browser.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var UnsafePipe = /** @class */ (function () {
    function UnsafePipe(sanitizer) {
        this.sanitizer = sanitizer;
    }
    UnsafePipe.prototype.transform = function (html) {
        return this.sanitizer.bypassSecurityTrustResourceUrl(html);
    };
    UnsafePipe = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["T" /* Pipe */])({ name: 'unsafe' }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__angular_platform_browser__["b" /* DomSanitizer */]])
    ], UnsafePipe);
    return UnsafePipe;
}());



/***/ }),

/***/ "./src/environments/environment.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return environment; });
// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.
var environment = {
    production: false
};


/***/ }),

/***/ "./src/main.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__ = __webpack_require__("./node_modules/@angular/platform-browser-dynamic/esm5/platform-browser-dynamic.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__app_app_module__ = __webpack_require__("./src/app/app.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__environments_environment__ = __webpack_require__("./src/environments/environment.ts");




if (__WEBPACK_IMPORTED_MODULE_3__environments_environment__["a" /* environment */].production) {
    Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_13" /* enableProdMode */])();
}
Object(__WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__["a" /* platformBrowserDynamic */])().bootstrapModule(__WEBPACK_IMPORTED_MODULE_2__app_app_module__["a" /* AppModule */])
    .catch(function (err) { return console.log(err); });


/***/ }),

/***/ 0:
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__("./src/main.ts");


/***/ })

},[0]);
//# sourceMappingURL=main.bundle.js.map