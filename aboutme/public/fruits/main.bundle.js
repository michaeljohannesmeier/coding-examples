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

/***/ "./src/app/aos.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "b", function() { return aos; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AosToken; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_aos__ = __webpack_require__("./node_modules/aos/dist/aos.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_aos___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_aos__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");


var aos = __WEBPACK_IMPORTED_MODULE_0_aos__;
var AosToken = new __WEBPACK_IMPORTED_MODULE_1__angular_core__["B" /* InjectionToken */]('AOS');


/***/ }),

/***/ "./src/app/app-routing.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppRoutingModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__home_home_component__ = __webpack_require__("./src/app/home/home.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__blueberries_blueberries_component__ = __webpack_require__("./src/app/blueberries/blueberries.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__bananas_bananas_component__ = __webpack_require__("./src/app/bananas/bananas.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__grapes_grapes_component__ = __webpack_require__("./src/app/grapes/grapes.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__strawberries_strawberries_component__ = __webpack_require__("./src/app/strawberries/strawberries.component.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};







var appRoutes = [
    { path: '', redirectTo: '/home', pathMatch: 'full' },
    { path: 'home', component: __WEBPACK_IMPORTED_MODULE_2__home_home_component__["a" /* HomeComponent */] },
    { path: 'blueberries', component: __WEBPACK_IMPORTED_MODULE_3__blueberries_blueberries_component__["a" /* BlueberriesComponent */] },
    { path: 'grapes', component: __WEBPACK_IMPORTED_MODULE_5__grapes_grapes_component__["a" /* GrapesComponent */] },
    { path: 'bananas', component: __WEBPACK_IMPORTED_MODULE_4__bananas_bananas_component__["a" /* BananasComponent */] },
    { path: 'strawberries', component: __WEBPACK_IMPORTED_MODULE_6__strawberries_strawberries_component__["a" /* StrawberriesComponent */] }
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

module.exports = ".mainContent {\r\n  min-width: 100%;\r\n  max-width: 100%;\r\n}\r\n"

/***/ }),

/***/ "./src/app/app.component.html":
/***/ (function(module, exports) {

module.exports = "<app-header></app-header>\n\n\n<div class=\"row\">\n\n    <router-outlet></router-outlet>\n\n</div>\n\n\n\n\n"

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
/* unused harmony export getWindow */
/* unused harmony export providers */
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__ = __webpack_require__("./node_modules/@angular/platform-browser/esm5/platform-browser.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__app_component__ = __webpack_require__("./src/app/app.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__home_home_component__ = __webpack_require__("./src/app/home/home.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__header_header_component__ = __webpack_require__("./src/app/header/header.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__app_routing_module__ = __webpack_require__("./src/app/app-routing.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__blueberries_blueberries_component__ = __webpack_require__("./src/app/blueberries/blueberries.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__bananas_bananas_component__ = __webpack_require__("./src/app/bananas/bananas.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__grapes_grapes_component__ = __webpack_require__("./src/app/grapes/grapes.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__strawberries_strawberries_component__ = __webpack_require__("./src/app/strawberries/strawberries.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__aos__ = __webpack_require__("./src/app/aos.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__thisissoon_angular_inviewport__ = __webpack_require__("./node_modules/@thisissoon/angular-inviewport/esm5/thisissoon-angular-inviewport.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_13__thisissoon_angular_scrollspy__ = __webpack_require__("./node_modules/@thisissoon/angular-scrollspy/esm5/thisissoon-angular-scrollspy.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};














var getWindow = function () { return window; };
var providers = [
    { provide: __WEBPACK_IMPORTED_MODULE_12__thisissoon_angular_inviewport__["b" /* WindowRef */], useFactory: (getWindow) },
];
var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_1__angular_core__["I" /* NgModule */])({
            declarations: [
                __WEBPACK_IMPORTED_MODULE_2__app_component__["a" /* AppComponent */],
                __WEBPACK_IMPORTED_MODULE_3__home_home_component__["a" /* HomeComponent */],
                __WEBPACK_IMPORTED_MODULE_4__header_header_component__["a" /* HeaderComponent */],
                __WEBPACK_IMPORTED_MODULE_6__blueberries_blueberries_component__["a" /* BlueberriesComponent */],
                __WEBPACK_IMPORTED_MODULE_7__bananas_bananas_component__["a" /* BananasComponent */],
                __WEBPACK_IMPORTED_MODULE_8__grapes_grapes_component__["a" /* GrapesComponent */],
                __WEBPACK_IMPORTED_MODULE_9__strawberries_strawberries_component__["a" /* StrawberriesComponent */]
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__["a" /* BrowserModule */],
                __WEBPACK_IMPORTED_MODULE_12__thisissoon_angular_inviewport__["a" /* InViewportModule */].forRoot(providers),
                __WEBPACK_IMPORTED_MODULE_13__thisissoon_angular_scrollspy__["a" /* ScrollSpyModule */].forRoot(),
                __WEBPACK_IMPORTED_MODULE_5__app_routing_module__["a" /* AppRoutingModule */]
            ],
            providers: [
                __WEBPACK_IMPORTED_MODULE_10__scrollTo_service__["a" /* ScrollToService */],
                { provide: __WEBPACK_IMPORTED_MODULE_11__aos__["a" /* AosToken */], useValue: __WEBPACK_IMPORTED_MODULE_11__aos__["b" /* aos */] }
            ],
            bootstrap: [__WEBPACK_IMPORTED_MODULE_2__app_component__["a" /* AppComponent */]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/bananas/bananas.component.css":
/***/ (function(module, exports) {

module.exports = "\r\n.bananaImages {\r\n  width: 100%;\r\n  height: 30vw;\r\n}\r\n.carousel-caption h3 {\r\n  color: #ffc50e !important;\r\n  font-size: 1.2em;\r\n}\r\n.carousel-caption {\r\n  color: white !important;\r\n  bottom:-120px;\r\n\r\n}\r\n.carousel-inner {\r\n  padding-bottom:120px;\r\n}\r\n.carousel-indicators li {\r\n  background-color: white;\r\n}\r\n.carousel-indicators li:hover{\r\n  cursor: pointer;\r\n}\r\n.carousel-indicators .active {\r\n  background-color: #ffc50e;\r\n}\r\n.carousel-control-prev-icon {\r\n  background-image: url(\"data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23000000' viewBox='0 0 8 8'%3E%3Cpath d='M5.25 0l-4 4 4 4 1.5-1.5-2.5-2.5 2.5-2.5-1.5-1.5z'/%3E%3C/svg%3E\");\r\n}\r\n.carousel-control-next-icon {\r\n  background-image: url(\"data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23000000' viewBox='0 0 8 8'%3E%3Cpath d='M2.75 0l-1.5 1.5 2.5 2.5-2.5 2.5 1.5 1.5 4-4-4-4z'/%3E%3C/svg%3E\");\r\n}\r\nhr {\r\n  background-color: #ffc50e;\r\n  height: 1px;\r\n  width: 30%;\r\n\r\n}\r\n.item {\r\n  color: white;\r\n  margin: auto;\r\n  width: 80%;\r\n  padding: 50px;\r\n  border: 1px solid #ffc50e;\r\n  display: inline-block;\r\n}\r\n.jumbotron {\r\n  background-color: #ffc50e;\r\n  padding: 0 30px 30px 30px;\r\n}\r\n@media only screen and (min-width: 1140px) {\r\n  .item {\r\n    width: 50%;\r\n  }\r\n}\r\n\r\n\r\n\r\n"

/***/ }),

/***/ "./src/app/bananas/bananas.component.html":
/***/ (function(module, exports) {

module.exports = "\n\n<div id=\"demo\" class=\"carousel slide\" data-ride=\"carousel\">\n  <ul class=\"carousel-indicators\">\n    <li data-target=\"#demo\" data-slide-to=\"0\" class=\"active\"></li>\n    <li data-target=\"#demo\" data-slide-to=\"1\"></li>\n    <li data-target=\"#demo\" data-slide-to=\"2\"></li>\n  </ul>\n  <div class=\"carousel-inner\">\n    <div class=\"carousel-item active\">\n      <img class=\"bananaImages\" src=\"assets/bananas2.jpg\" alt=\"Bananas\">\n      <div class=\"carousel-caption\">\n        <h3>Make bananas great again</h3>\n        <p>Great times with bananas!</p>\n      </div>\n    </div>\n    <div class=\"carousel-item\">\n      <img class=\"bananaImages\" src=\"assets/bananas3.jpg\" alt=\"Bananas\">\n      <div class=\"carousel-caption\">\n        <h3>Awesome Bananas</h3>\n        <p>Thank you, Banana!</p>\n      </div>\n    </div>\n    <div class=\"carousel-item\">\n      <img class=\"bananaImages\" src=\"assets/bananas4.jpg\" alt=\"Bananas\">\n      <div class=\"carousel-caption\">\n        <h3>Just yellow</h3>\n        <p>We love Bananas!</p>\n      </div>\n    </div>\n  </div>\n  <a class=\"carousel-control-prev\" href=\"#demo\" data-slide=\"prev\">\n    <span class=\"carousel-control-prev-icon carousel-arrows\"></span>\n  </a>\n  <a class=\"carousel-control-next\" href=\"#demo\" data-slide=\"next\">\n    <span class=\"carousel-control-next-icon carousel-arrows\"></span>\n  </a>\n</div>\n\n\n\n<hr>\n\n\n<br>\n<br>\n<br>\n<br>\n<div class=\"row\">\n  <div class=\"item\" data-aos=\"zoom-in\">\n    A banana is an edible fruit – botanically a berry[1][2] – produced by several kinds of large herbaceous flowering plants in the genus Musa.[3]\n    In some countries, bananas used for cooking may be called plantains, in contrast to dessert bananas.\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n<div class=\"row\">\n  <div class=\"item\" data-aos=\"flip-up\">\n    The fruit is variable in size, color, and firmness, but is usually elongated and curved, with soft flesh rich in starch covered with a rind,\n    which may be green, yellow, red, purple, or brown when ripe. The fruits grow in clusters hanging from the top of the plant.\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n<div class=\"row\">\n  <div class=\"item\" data-aos=\"flip-down\">\n    Almost all modern edible parthenocarpic (seedless) bananas come from two wild species – Musa acuminata and Musa balbisiana. The scientific names of most cultivated bananas\n    are Musa acuminata, Musa balbisiana, and Musa × paradisiaca for the hybrid Musa acuminata × M. balbisiana, depending on their genomic constitution. The old scientific name Musa sapientum is no longer used.\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n<div class=\"row\">\n  <div class=\"item\" data-aos=\"flip-right\">\n    Musa species are native to tropical Indomalaya and Australia, and are likely to have been first domesticated in Papua New Guinea.[4][5] They are grown in 135 countries,[6] primarily for their fruit,\n    and to a lesser extent to make fiber, banana wine, and banana beer and as ornamental plants.\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n<br>\n\n\n<div class=\"jumbotron\" data-aos=\"fade-up\" data-aos-duration=\"100\">\n  <h1>History</h1>\n  <p>Farmers in Southeast Asia and Papua New Guinea first domesticated bananas. Recent archaeological and palaeoenvironmental evidence at Kuk Swamp in the Western Highlands Province of\n    Papua New Guinea suggests that banana cultivation there goes back to at least 5000 BCE, and possibly to 8000 BCE.[4][43] It is likely that other species were later and independently domesticated\n    elsewhere in Southeast Asia. Southeast Asia is the region of primary diversity of the banana. Areas of secondary diversity are found in Africa, indicating a long history of banana cultivation in the region.[44]</p>\n</div>\n\n\n"

/***/ }),

/***/ "./src/app/bananas/bananas.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return BananasComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_aos__ = __webpack_require__("./node_modules/aos/dist/aos.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_aos___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_aos__);
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var BananasComponent = /** @class */ (function () {
    function BananasComponent(scrollService) {
        this.scrollService = scrollService;
    }
    BananasComponent.prototype.ngOnInit = function () {
        this.scrollService.setScroll(0, 0);
        __WEBPACK_IMPORTED_MODULE_2_aos__["init"]({
            duration: 3000
        });
    };
    BananasComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-bananas',
            template: __webpack_require__("./src/app/bananas/bananas.component.html"),
            styles: [__webpack_require__("./src/app/bananas/bananas.component.css")],
            encapsulation: __WEBPACK_IMPORTED_MODULE_0__angular_core__["_9" /* ViewEncapsulation */].None
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__scrollTo_service__["a" /* ScrollToService */]])
    ], BananasComponent);
    return BananasComponent;
}());



/***/ }),

/***/ "./src/app/blueberries/blueberries.component.css":
/***/ (function(module, exports) {

module.exports = "p {\r\n  color: white;\r\n}\r\n\r\n.headingBlueberries h1 {\r\n  text-align: center;\r\n  color: white;\r\n  margin: 60px 0 60px 0;\r\n  font-size: 10vw;\r\n}\r\n\r\n.fruitstext {\r\n  margin: 60px 0 60px 0;\r\n}\r\n\r\n.fruitstext h3 {\r\n  margin: auto;\r\n  width: 70%;\r\n  color: #7337b4;\r\n  text-align: center;\r\n}\r\n\r\n.fruitstext p {\r\n  margin: auto;\r\n  width: 70%;\r\n  font-size: 1em;\r\n  text-align: center;\r\n}\r\n\r\n.fruitstext p:first-letter {\r\n  font-size: 1.3em;\r\n  color: #7337b4;\r\n}\r\n\r\n@media only screen and (min-width: 768px) {\r\n  .myBackground {\r\n    background-image: url('blueberries3.ecc012776196a81af644.jpg');\r\n    background-repeat: no-repeat;\r\n    background-attachment: fixed;\r\n    background-size: 50vw 100vh;\r\n    background-position: 0px 0px;\r\n  }\r\n\r\n  .myBackground2 {\r\n    background-image: url('blueberries4.cc059f53eb49850fd123.jpg');\r\n    background-repeat: no-repeat;\r\n    background-attachment: fixed;\r\n    background-size: 50vw 100vh;\r\n    background-position: 48vw 0vh;\r\n  }\r\n  .myBackground3 {\r\n    background-image: url('blueberries5.b665ab965f600954c190.jpg');\r\n    background-repeat: no-repeat;\r\n    background-attachment: fixed;\r\n    background-size: 50vw 100vh;\r\n    background-position: 0px 0px;\r\n  }\r\n  .headingBlueberries h1 {\r\n    font-size: 3em;\r\n  }\r\n  .fruitstext p {\r\n    margin: auto;\r\n    width: 70%;\r\n    font-size: 1.2em;\r\n    text-align: center;\r\n  }\r\n\r\n  .fruitstext p:first-letter {\r\n    font-size: 1.6em;\r\n    color: #7337b4;\r\n  }\r\n}\r\n\r\n@media only screen and (min-width: 1140px) {\r\n  .fruitstext h3 {\r\n    width: 50%;\r\n  }\r\n  .fruitstext p {\r\n    width: 50%;\r\n  }\r\n}\r\n\r\n.myRow {\r\n  position: relative;\r\n  text-align: center;\r\n}\r\n\r\n.myLeft {\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 20%;\r\n  -webkit-transform: translate(-50%, -50%);\r\n          transform: translate(-50%, -50%);\r\n  color: #7337b4;\r\n  font-size: 5vw;\r\n  font-weight: bold;\r\n  opacity: 0;\r\n  -webkit-animation-name: colorTrans;\r\n          animation-name: colorTrans;\r\n  -webkit-animation-duration: 2s;\r\n          animation-duration: 2s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n.myCenter {\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 50%;\r\n  -webkit-transform: translate(-50%, -50%);\r\n          transform: translate(-50%, -50%);\r\n  color: #7337b4;\r\n  font-size: 5vw;\r\n  font-weight: bold;\r\n  opacity: 0;\r\n  -webkit-animation-name: colorTrans;\r\n          animation-name: colorTrans;\r\n  -webkit-animation-duration: 2s;\r\n          animation-duration: 2s;\r\n  -webkit-animation-delay: 1s;\r\n          animation-delay: 1s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n.myRight {\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 80%;\r\n  -webkit-transform: translate(-50%, -50%);\r\n          transform: translate(-50%, -50%);\r\n  color: #7337b4;\r\n  font-size: 5vw;\r\n  font-weight: bold;\r\n  opacity: 0;\r\n  -webkit-animation-name: colorTrans;\r\n          animation-name: colorTrans;\r\n  -webkit-animation-duration: 2s;\r\n          animation-duration: 2s;\r\n  -webkit-animation-delay: 2s;\r\n          animation-delay: 2s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n.myBackgroundPicOverly {\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 0%;\r\n  -webkit-transform: translate(0%, -50%);\r\n          transform: translate(0%, -50%);\r\n  background-color:rgba(0,0,0,.8);\r\n  width: 100%;\r\n  height: 200px;\r\n}\r\n\r\n@-webkit-keyframes colorTrans {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n\r\n@keyframes colorTrans {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n"

/***/ }),

/***/ "./src/app/blueberries/blueberries.component.html":
/***/ (function(module, exports) {

module.exports = "\n<div class=\"row myRow\">\n  <img src=\"assets/blueberries2.jpg\" alt=\"Berries\" style=\"width: 100%; height: 700px\">\n  <div class=\"myBackgroundPicOverly\">\n    <div class=\"myLeft\">Sooo</div>\n    <div class=\"myCenter\">sooo</div>\n    <div class=\"myRight\">blueee</div>\n  </div>\n\n</div>\n\n<div class=\"row\">\n  <div class=\"col-lg-12 headingBlueberries\">\n    <h1 >BLUEBERRIES</h1>\n  </div>\n</div>\n\n\n<div class=\"row\">\n  <div class=\"myBackground col-md-6\">\n  </div>\n  <div class=\"fruitstext col-md-6\">\n    <h3>About Blueberries in General</h3>\n    <br>\n    <br>\n    <p>\n      Blueberries are perennial flowering plants with indigo-colored berries. They are classified in the section Cyanococcus within the genus Vaccinium. Vaccinium also includes cranberries,\n      bilberries and grouseberries.[1] Commercial \"blueberries\" are native to North America, and the \"highbush\" varieties were not introduced into Europe until the 1930s.\n    </p>\n    <br>\n    <br>\n    <p>\n      Blueberries are usually prostrate shrubs that can vary in size from 10 centimeters (3.9 in) to 4 meters (13 ft) in height. In the commercial production of blueberries,\n      the smaller species are known as \"lowbush blueberries\" (synonymous with \"wild\"), while the larger species are known as \"highbush blueberries\".\n    </p>\n    <br>\n    <br>\n  </div>\n</div>\n\n\n<div class=\"row\">\n  <div class=\"fruitstext col-md-6\">\n    <h3>Blueberry Leafs</h3>\n    <br>\n    <br>\n    <p>\n      The leaves can be either deciduous or evergreen, ovate to lanceolate, and 1–8 cm (0.39–3.15 in) long and 0.5–3.5 cm (0.20–1.38 in) broad. The flowers are bell-shaped, white, pale pink or red, sometimes tinged greenish.\n      The fruit is a berry 5–16 millimeters (0.20–0.63 in) in diameter with a flared crown at the end; they are pale greenish at first, then reddish-purple, and finally dark purple when ripe.\n    </p>\n    <br>\n    <br>\n    <p>\n      They are covered in a protective coating of powdery epicuticular wax, colloquially known as the \"bloom\".[3] They have a sweet taste when mature, with variable acidity.\n      Blueberry bushes typically bear fruit in the middle of the growing season: fruiting times are affected by local conditions such as altitude and latitude, so the peak of the crop, in the northern hemisphere,\n      can vary from May to August.\n    </p>\n  </div>\n  <div class=\"myBackground2 col-md-6\">\n</div>\n\n  <div class=\"row\">\n    <div class=\"myBackground3 col-md-6\">\n    </div>\n    <div class=\"fruitstext col-md-6\">\n      <h3>Uses</h3>\n      <br>\n      <br>\n      <p>\n        Blueberries consist of 14% carbohydrates, 0.7% protein, 0.3% fat and 84% water (table). They contain only negligible amounts of micronutrients, with moderate levels\n        (relative to respective Daily Values) (DV) of the essential dietary mineral manganese, vitamin C, vitamin K and dietary fiber (table).Generally, nutrient contents\n        of blueberries are a low percentage of the DV (table). One serving provides a relatively low caloric value of 57 kcal per 100 g serving and glycemic load score of 6 out of 100 per day.\n      </p>\n      <br>\n      <br>\n      <p>\n        Blueberries contain anthocyanins, other polyphenols and various phytochemicals under preliminary research for their potential role in the human body. Most polyphenol studies have been conducted using\n        the highbush cultivar of blueberries (V. corymbosum), while content of polyphenols and anthocyanins in lowbush (wild) blueberries (V. angustifolium) exceeds values found in highbush cultivars.[\n      </p>\n      <br>\n      <br>\n    </div>\n  </div>\n\n"

/***/ }),

/***/ "./src/app/blueberries/blueberries.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return BlueberriesComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var BlueberriesComponent = /** @class */ (function () {
    function BlueberriesComponent(scrollService) {
        this.scrollService = scrollService;
    }
    BlueberriesComponent.prototype.ngOnInit = function () {
        this.scrollService.setScroll(0, 0);
    };
    BlueberriesComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-blueberries',
            template: __webpack_require__("./src/app/blueberries/blueberries.component.html"),
            styles: [__webpack_require__("./src/app/blueberries/blueberries.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__scrollTo_service__["a" /* ScrollToService */]])
    ], BlueberriesComponent);
    return BlueberriesComponent;
}());



/***/ }),

/***/ "./src/app/grapes/grapes.component.css":
/***/ (function(module, exports) {

module.exports = "p {\r\n  color: white;\r\n}\r\n\r\n\r\n.jumbotron {\r\n  background-color: #1f6f09;\r\n  color: #ffc50e;\r\n}\r\n\r\n\r\n.jumbotron p {\r\n  color: #ffc50e;\r\n}\r\n\r\n\r\n.btn-orangeBlack {\r\n  background-color: #ffc50e;\r\n  color: black;\r\n}\r\n\r\n\r\n.becomeOpacCont {\r\n  -webkit-animation-name: becomeOpac;\r\n          animation-name: becomeOpac;\r\n  -webkit-animation-duration: 2s;\r\n          animation-duration: 2s;\r\n  opacity: 0;\r\n  -webkit-animation-delay: 2s;\r\n          animation-delay: 2s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.btn-orangeBlack:hover{\r\n  background-color: #333333;\r\n  color: #ffc50e;\r\n}\r\n\r\n\r\n.nav-link {\r\n  color: #ffc50e;\r\n}\r\n\r\n\r\n.nav-link.active {\r\n  background-color: white;\r\n  color: black;\r\n}\r\n\r\n\r\n.tab-pane p {\r\n  text-indent: 50px;\r\n\r\n}\r\n\r\n\r\n.nav-tabs {\r\n  font-size: 0.8em;\r\n  padding-left: 10px;\r\n}\r\n\r\n\r\n.my-first-letter {\r\n  font-size: 1.6em;\r\n  text-decoration:none;\r\n  color: white;\r\n  position: relative;\r\n  -webkit-animation-name: letterJump;\r\n          animation-name: letterJump;\r\n  -webkit-animation-duration: 1.5s;\r\n          animation-duration: 1.5s;\r\n  -webkit-animation-delay: 0s;\r\n          animation-delay: 0s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.myContainer {\r\n  position:absolute;\r\n  border:solid red;\r\n}\r\n\r\n\r\n.maxWidth {\r\n  margin-right: 100px;\r\n\r\n}\r\n\r\n\r\n.myBadge {\r\n  position:absolute;\r\n  font-size:.7em;\r\n  background:#ffc50e;\r\n  color:black;\r\n  border-radius:10px;\r\n  -webkit-box-shadow:0 0 1px #333;\r\n          box-shadow:0 0 1px #333;\r\n  padding: 0 10px 0 10px;\r\n  font-weight: bold;\r\n}\r\n\r\n\r\n.textHeading  {\r\n  position: relative;\r\n  background-color: #ffc50e;\r\n  -webkit-animation-name: textHeading;\r\n          animation-name: textHeading;\r\n  -webkit-animation-duration: 4s;\r\n          animation-duration: 4s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.text1  {\r\n  position: relative;\r\n  background-color: #ffc50e;\r\n  -webkit-animation-name: text1;\r\n          animation-name: text1;\r\n  -webkit-animation-duration: 5s;\r\n          animation-duration: 5s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.text1 p {\r\n  color: black;\r\n}\r\n\r\n\r\n.text2  {\r\n  position: relative;\r\n  background-color: #ffc50e;\r\n  -webkit-animation-name: text1;\r\n          animation-name: text1;\r\n  -webkit-animation-duration: 6s;\r\n          animation-duration: 6s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.text3  {\r\n  position: relative;\r\n  background-color: #ffc50e;\r\n  -webkit-animation-name: text1;\r\n          animation-name: text1;\r\n  -webkit-animation-duration: 7s;\r\n          animation-duration: 7s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n}\r\n\r\n\r\n.mt-3 {\r\n  position: relative;\r\n  opacity: 0;\r\n  -webkit-animation-name: mt-3;\r\n          animation-name: mt-3;\r\n  -webkit-animation-duration: 7s;\r\n          animation-duration: 7s;\r\n  -webkit-animation-fill-mode: forwards;\r\n          animation-fill-mode: forwards;\r\n  -webkit-animation-delay: 1s;\r\n          animation-delay: 1s;\r\n}\r\n\r\n\r\n@-webkit-keyframes textHeading {\r\n  0% {background-color: #ffc50e;left: 1000px;top: 0%;}\r\n  100% {background-color: black;left: 50px;top: 0%;color: #ffc50e;}\r\n}\r\n\r\n\r\n@keyframes textHeading {\r\n  0% {background-color: #ffc50e;left: 1000px;top: 0%;}\r\n  100% {background-color: black;left: 50px;top: 0%;color: #ffc50e;}\r\n}\r\n\r\n\r\n@-webkit-keyframes text1 {\r\n  0%   {left:1000%; top:0%;}\r\n  100%  {left:60px; top:0%;}\r\n}\r\n\r\n\r\n@keyframes text1 {\r\n  0%   {left:1000%; top:0%;}\r\n  100%  {left:60px; top:0%;}\r\n}\r\n\r\n\r\n@-webkit-keyframes mt-3 {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n\r\n\r\n@keyframes mt-3 {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n\r\n\r\n@-webkit-keyframes letterJump {\r\n  0%    {left: 0px; top:0%; color: white}\r\n  10%    {left: 0px; top:-2px; color: white}\r\n  20%    {left: 0px; top:-4px; color: white}\r\n  30%    {left: 0px; top:-6px; color: white}\r\n  40%    {left: 0px; top:-8px; color: white}\r\n  50%    {left: 0px; top:-10px; color: #ffc50e}\r\n  60%    {left: 0px; top:-8px; color: #ffc50e}\r\n  70%    {left: 0px; top:-6px; color: #ffc50e}\r\n  80%    {left: 0px; top:-4px; color: #ffc50e}\r\n  90%    {left: 0px; top:-2px; color: #ffc50e}\r\n  100%  {left: 0px; top:0px; color: #ffc50e}\r\n}\r\n\r\n\r\n@keyframes letterJump {\r\n  0%    {left: 0px; top:0%; color: white}\r\n  10%    {left: 0px; top:-2px; color: white}\r\n  20%    {left: 0px; top:-4px; color: white}\r\n  30%    {left: 0px; top:-6px; color: white}\r\n  40%    {left: 0px; top:-8px; color: white}\r\n  50%    {left: 0px; top:-10px; color: #ffc50e}\r\n  60%    {left: 0px; top:-8px; color: #ffc50e}\r\n  70%    {left: 0px; top:-6px; color: #ffc50e}\r\n  80%    {left: 0px; top:-4px; color: #ffc50e}\r\n  90%    {left: 0px; top:-2px; color: #ffc50e}\r\n  100%  {left: 0px; top:0px; color: #ffc50e}\r\n}\r\n\r\n\r\n.myJumboBlack {\r\n  background-color: black;\r\n  color: white;\r\n  diplay: none;\r\n  padding-left: 10vw;\r\n}\r\n\r\n\r\n.myJumboBlack p {\r\n  color: white;\r\n}\r\n\r\n\r\ndiv.gallery {\r\n  position: relative;\r\n  float: left;\r\n  width: 50vw;\r\n  padding-left: 5px;\r\n}\r\n\r\n\r\ndiv.gallery:hover .overlayImgGallery {\r\n  -webkit-transform: scale(1);\r\n          transform: scale(1);\r\n  cursor: pointer;\r\n}\r\n\r\n\r\n.overlayImgGallery {\r\n  position: absolute;\r\n  bottom: 0;\r\n  left: 0;\r\n  right: 0;\r\n  background-color: #000000;\r\n  opacity: 0.7;\r\n  overflow: hidden;\r\n  width: 100%;\r\n  height: 100%;\r\n  -webkit-transform: scale(0);\r\n  -webkit-transition: .3s ease;\r\n  transition: .3s ease;\r\n}\r\n\r\n\r\ndiv.gallery img {\r\n  width: 50vw;\r\n  height: auto;\r\n  height: 40vw;\r\n}\r\n\r\n\r\ndiv.desc {\r\n  background-color: white;\r\n  padding: 15px;\r\n  text-align: center;\r\n}\r\n\r\n\r\n.imgText {\r\n  color: white;\r\n  font-size: 20px;\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 50%;\r\n  -webkit-transform: translate(-50%, -50%);\r\n          transform: translate(-50%, -50%);\r\n  -ms-transform: translate(-50%, -50%);\r\n  text-align: center;\r\n  font-size: 0.8em;\r\n}\r\n\r\n\r\n@-webkit-keyframes becomeOpac {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n\r\n\r\n@keyframes becomeOpac {\r\n  0%   {opacity: 0}\r\n  100%   {opacity: 1}\r\n}\r\n\r\n\r\n/*----------------MODAL--------------*/\r\n\r\n\r\n/* The Modal (background) */\r\n\r\n\r\n.modal {\r\n  display: none; /* Hidden by default */\r\n  position: fixed; /* Stay in place */\r\n  z-index: 1; /* Sit on top */\r\n  padding-top: 100px; /* Location of the box */\r\n  left: 0;\r\n  top: 0;\r\n  width: 100%; /* Full width */\r\n  height: 100%; /* Full height */\r\n  overflow: auto; /* Enable scroll if needed */\r\n  background-color: rgb(0,0,0); /* Fallback color */\r\n  background-color: rgba(0,0,0,0.9); /* Black w/ opacity */\r\n}\r\n\r\n\r\n/* Modal Content (image) */\r\n\r\n\r\n.modal-content {\r\n  margin: auto;\r\n  display: block;\r\n  width: 70%;\r\n  max-width: 100%;\r\n}\r\n\r\n\r\n/* Caption of Modal Image */\r\n\r\n\r\n#caption {\r\n  margin: auto;\r\n  display: block;\r\n  width: 80%;\r\n  max-width: 700px;\r\n  text-align: center;\r\n  color: #ccc;\r\n  padding: 10px 0;\r\n  height: 150px;\r\n}\r\n\r\n\r\n/* Add Animation */\r\n\r\n\r\n.modal-content, #caption {\r\n  -webkit-animation-name: zoom;\r\n  -webkit-animation-duration: 0.6s;\r\n  animation-name: zoom;\r\n  animation-duration: 0.6s;\r\n}\r\n\r\n\r\n@-webkit-keyframes zoom {\r\n  from {-webkit-transform:scale(0)}\r\n  to {-webkit-transform:scale(1)}\r\n}\r\n\r\n\r\n@keyframes zoom {\r\n  from {-webkit-transform:scale(0);transform:scale(0)}\r\n  to {-webkit-transform:scale(1);transform:scale(1)}\r\n}\r\n\r\n\r\n/* The Close Button */\r\n\r\n\r\n.closeModal {\r\n  position: absolute;\r\n  top: 15px;\r\n  right: 35px;\r\n  color: #ffffff;\r\n  font-size: 40px;\r\n  font-weight: bold;\r\n  -webkit-transition: 0.3s;\r\n  transition: 0.3s;\r\n}\r\n\r\n\r\n.closeModal:hover,\r\n.closeModal:focus {\r\n  color: #ffc50e;\r\n  text-decoration: none;\r\n  cursor: pointer;\r\n}\r\n\r\n\r\n@media only screen and (min-width: 576px) {\r\n  .text1, .text2, .text3 {\r\n    font-size: 1.2em;\r\n  }\r\n\r\n  .nav-tabs {\r\n    font-size: 1.0em;\r\n    padding-left: 0px;\r\n  }\r\n\r\n  div.gallery {\r\n    width: 19vw;\r\n  }\r\n\r\n  div.gallery img {\r\n    width: 19vw;\r\n    height: 20vw;\r\n  }\r\n  .imgText {\r\n    font-size: 1em;\r\n  }\r\n}\r\n\r\n\r\n@media only screen and (min-width: 1140px) {\r\n\r\n  @-webkit-keyframes textHeading {\r\n    0% {background-color: #ffc50e;left: 1000px;top: 0%;}\r\n    100% {background-color: black;left: 120px;top: 0%;color: #ffc50e;}\r\n  }\r\n  @keyframes textHeading {\r\n    0% {background-color: #ffc50e;left: 1000px;top: 0%;}\r\n    100% {background-color: black;left: 120px;top: 0%;color: #ffc50e;}\r\n  }\r\n\r\n\r\n  @-webkit-keyframes text1 {\r\n    0%   {left:1000%; top:0%;}\r\n    100%  {left:130px; top:0%;}\r\n  }\r\n  @keyframes text1 {\r\n    0%   {left:1000%; top:0%;}\r\n    100%  {left:130px; top:0%;}\r\n  }\r\n\r\n\r\n}\r\n"

/***/ }),

/***/ "./src/app/grapes/grapes.component.html":
/***/ (function(module, exports) {

module.exports = "<br>\n<br>\n<br>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <h3><span class=\"badge badge-warning textHeading\">Grapes</span></h3>\n    </div>\n  </div>\n\n  <div class=\"row maxWidth\">\n    <div class=\"col-xs-12\">\n      <p class=\"myBadge text1\">A grape is a fruit, botanically a berry, of the deciduous woody vines of the flowering plant genus Vitis.</p>\n    </div>\n  </div>\n  <div class=\"row maxWidth\">\n    <div class=\"col-xs-12\">\n      <p class=\"myBadge text2\">Grapes can be eaten fresh as table grapes or they can be used for making wine, jam, juice, jelly, grape seed extract, raisins, vinegar,\n        and grape seed oil.</p>\n    </div>\n  </div>\n  <div class=\"row maxWidth\">\n    <div class=\"col-xs-12\">\n      <p class=\"myBadge text3\">Grapes are a non-climacteric type of fruit, generally occurring in clusters.</p>\n    </div>\n</div>\n\n\n\n\n\n<div class=\"container mt-3\">\n  <br>\n  <br>\n  <br>\n  <ul class=\"nav nav-tabs\">\n    <li class=\"nav-item\">\n      <a class=\"nav-link active\" data-toggle=\"tab\" href=\"#home\">Description</a>\n    </li>\n    <li class=\"nav-item\">\n      <a class=\"nav-link\" data-toggle=\"tab\" href=\"#menu1\">History</a>\n    </li>\n    <li class=\"nav-item\">\n      <a class=\"nav-link\" data-toggle=\"tab\" href=\"#menu2\">Religios Significance</a>\n    </li>\n  </ul>\n\n  <div class=\"tab-content\">\n    <div id=\"home\" class=\"container tab-pane active\"><br>\n      <br>\n      <p><a class=\"my-first-letter\">G</a>rapes are a type of fruit that grow in clusters of 15 to 300, and can be crimson, black, dark blue, yellow, green, orange, and pink. \"White\" grapes are actually green in color,\n        and are evolutionarily derived from the purple grape. Mutations in two regulatory genes of white grapes turn off production of anthocyanins, which are responsible for the color of purple grapes.[8]\n        Anthocyanins and other pigment chemicals of the larger family of polyphenols in purple grapes are responsible for the varying shades of purple in red wines.[9][10] Grapes are typically an ellipsoid shape\n        resembling a prolate spheroid.</p>\n    </div>\n\n    <div id=\"menu1\" class=\"container tab-pane fade\"><br>\n      <br>\n      <p><a class=\"my-first-letter\">T</a>he cultivation of the domesticated grape began 6,000–8,000 years ago in the Near East.[1] Yeast, one of the earliest domesticated microorganisms, occurs naturally on the skins of grapes,\n        leading to the discovery of alcoholic drinks such as wine. The earliest archeological evidence for a dominant position of wine-making in human culture dates from 8,000 years ago in Georgia.[2][3][4]\n        The oldest known winery was found in Armenia, dating to around 4000 BC.[5] </p>\n      <p><a class=\"my-first-letter\">B</a>y the 9th century AD the city of Shiraz was known to produce some of the finest wines in the Middle East. Thus it has been proposed\n        that Syrah red wine is named after Shiraz, a city in Persia where the grape was used to make Shirazi wine.[6] Ancient Egyptian hieroglyphics record the cultivation of purple grapes, and history attests to the\n        ancient Greeks, Phoenicians, and Romans growing purple grapes for both eating and wine production.[7] The growing of grapes would later spread to other regions in Europe, as well as North Africa, and eventually\n        in North America.</p>\n    </div>\n\n    <div id=\"menu2\" class=\"container tab-pane fade\"><br>\n      <br>\n      <p><a class=\"my-first-letter\">I</a>n the Bible, grapes are first mentioned when Noah grows them on his farm.[43] Instructions concerning wine are given in the book of Proverbs and in the book of Isaiah.[44][45] Deuteronomy tells of the use of wine\n        during Jewish feasts. Grapes were also significant to both the Greeks and Romans, and their god of agriculture, Dionysus, was linked to grapes and wine, being frequently portrayed with grape leaves on his head.[46]\n        Grapes are especially significant for Christians, who since the Early Church have used wine in their celebration of the Eucharist.[47] Views on the significance of the wine vary between denominations. In Christian art,\n        grapes often represent the blood of Christ, such as the grape leaves in Caravaggio’s John the Baptist.</p>\n      </div>\n  </div>\n</div>\n\n\n\n<br>\n<br>\n<br>\n<br>\n<div class=\"container becomeOpacCont text-center\">\n  <button type=\"button\" class=\"btn btn-orangeBlack\" (click)=\"openCloseGallery()\" *ngIf=\"!galleryOpen\">View Picture Gallery</button>\n  <button type=\"button\" class=\"btn btn-orangeBlack\" (click)=\"openCloseGallery()\" *ngIf=\"galleryOpen\">Close Picture Gallery</button>\n</div>\n<br>\n<br>\n\n\n<div [style.display]=\"myDisplay\" class=\"jumbotron myJumboBlack\">\n  <h1>Grapes Agriculture</h1>\n  <p>According to the Food and Agriculture Organization (FAO), 75,866 square kilometers of the world are dedicated to grapes.\n    Approximately 71% of world grape production is used for wine, 27% as fresh fruit, and 2% as dried fruit.</p>\n\n  <div id=\"myModal\" class=\"modal\">\n    <span id=\"close\" class=\"closeModal\" (click)=\"onClose()\">&times;</span>\n    <img class=\"modal-content\" id=\"imgModal\">\n    <div id=\"caption\"></div>\n  </div>\n\n  <div class=\"row\">\n    <div *ngFor=\"let image of images\" class=\"gallery\">\n      <img src=\"{{image.src}}\" alt=\"{{image.alt}}\" >\n      <div class=\"overlayImgGallery\" (click)=\"openModal(image)\">\n        <div class=\"imgText\">{{image.desc}}</div>\n      </div>\n    </div>\n\n\n\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n\n\n\n\n\n"

/***/ }),

/***/ "./src/app/grapes/grapes.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return GrapesComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__image_model__ = __webpack_require__("./src/app/image.model.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [0, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};



var GrapesComponent = /** @class */ (function () {
    function GrapesComponent(scrollService) {
        this.scrollService = scrollService;
        this.galleryOpen = false;
        this.myDisplay = 'none';
    }
    GrapesComponent.prototype.ngOnInit = function () {
        this.scrollService.setScroll(0, 0);
        this.images = [
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes2.jpg', 'Graaapes', 'Grapes in green and red in a bowl'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes3.jpg', 'Graaapes', 'Grapes in red, green and black'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes4.jpg', 'Graaapes', 'Two purple grapes bunches on a tree'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes5.jpg', 'Graaapes', 'A lot of grapes bunches on a tree'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes6.jpg', 'Graaapes', 'Grapes in red'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes7.jpg', 'Graaapes', 'Grapes in red on a tree'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes8.jpg', 'Graaapes', 'Grapes in green'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes9.jpg', 'Graaapes', 'Grapes in purple'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes10.jpg', 'Graaapes', 'Grapes in red on a tree'),
            new __WEBPACK_IMPORTED_MODULE_2__image_model__["a" /* Image */]('assets/grapes11.jpg', 'Graaapes', 'Grapes in purple and green')
        ];
    };
    GrapesComponent.prototype.openCloseGallery = function () {
        if (this.galleryOpen) {
            this.galleryOpen = false;
            this.myDisplay = 'none';
            window.scroll(0, 100);
        }
        else {
            this.galleryOpen = true;
            this.myDisplay = 'block';
            var resolveAfter1Seconds = function () {
                return new Promise(function (resolve) {
                    setTimeout(function () {
                        resolve('resolved');
                    }, 10);
                });
            };
            var asyncCall = function () {
                return __awaiter(this, void 0, void 0, function () {
                    return __generator(this, function (_a) {
                        switch (_a.label) {
                            case 0: return [4 /*yield*/, resolveAfter1Seconds()];
                            case 1:
                                _a.sent();
                                window.scroll(0, 700);
                                return [2 /*return*/];
                        }
                    });
                });
            };
            asyncCall();
        }
    };
    GrapesComponent.prototype.openModal = function (image) {
        var modalImg = document.getElementById('myModal');
        var imgModal = document.getElementById('imgModal');
        var captionText = document.getElementById('caption');
        console.log(modalImg.style.display);
        modalImg.style.display = 'block';
        imgModal.setAttribute('src', image.src);
        captionText.innerHTML = image.desc;
    };
    GrapesComponent.prototype.onClose = function () {
        var modalImg = document.getElementById('myModal');
        modalImg.style.display = 'none';
    };
    GrapesComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-grapes',
            template: __webpack_require__("./src/app/grapes/grapes.component.html"),
            styles: [__webpack_require__("./src/app/grapes/grapes.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__scrollTo_service__["a" /* ScrollToService */]])
    ], GrapesComponent);
    return GrapesComponent;
}());



/***/ }),

/***/ "./src/app/header/header.component.css":
/***/ (function(module, exports) {

module.exports = ".navbaritems a {\r\n  color: white;\r\n  padding: 0 40px 20px 0;\r\n  font-size: 1.3em;\r\n\r\n}\r\n\r\n.navbarwidth {\r\n  width: 90%;\r\n  margin: auto;\r\n}\r\n\r\n.navbar-custom {\r\n  background-color: black;\r\n}\r\n\r\n.navbar-nav a {\r\n   color: white;\r\n}\r\n\r\n.navbar-nav a:hover {\r\n  color: #ffc50e;\r\n  text-decoration: none;\r\n}\r\n\r\n.navbar-nav .active {\r\n  border-bottom: 3px solid #ffc50e;\r\n}\r\n\r\n.myToggler:focus {\r\n  border: solid #ffc50e;\r\n}\r\n\r\n.myToggler {\r\n  border: solid rgba(255,197,14, 0.5);\r\n}\r\n\r\n.navbar-toggler-icon {\r\n  background-image: url(\"data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 32 32' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='rgba(255,197,14, 0.5)' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 8h24M4 16h24M4 24h24'/%3E%3C/svg%3E\");\r\n}\r\n\r\n"

/***/ }),

/***/ "./src/app/header/header.component.html":
/***/ (function(module, exports) {

module.exports = "\r\n\r\n<nav class=\"navbar navbar-expand-md navbar-dark\">\r\n\r\n  <button class=\"navbar-toggler myToggler\" type=\"button\" data-toggle=\"collapse\" data-target=\"#collapsibleNavbar\">\r\n    <span class=\"navbar-toggler-icon\"></span>\r\n  </button>\r\n  <div class=\"collapse navbar-collapse\" id=\"collapsibleNavbar\">\r\n    <ul class=\"navbar-nav justify-content-end navbaritems navbarwidth\">\r\n      <li class=\"nav-item\"><a class=\"nav-link\" routerLinkActive=\"active\" routerLink=\"/home\">Home</a></li>\r\n      <li class=\"nav-item\"><a class=\"nav-link\" routerLinkActive=\"active\" routerLink=\"/blueberries\">Blueberries</a></li>\r\n      <li class=\"nav-item\"><a class=\"nav-link\" routerLinkActive=\"active\" routerLink=\"/grapes\">Grapes</a></li>\r\n      <li class=\"nav-item\"><a class=\"nav-link\" routerLinkActive=\"active\" routerLink=\"/bananas\" (click)=\"toggleActive()\" >Bananas</a></li>\r\n      <li class=\"nav-item\"><a class=\"nav-link\" routerLinkActive=\"active\" routerLink=\"/strawberries\" (click)=\"toggleActive()\">Strawberries</a></li>\r\n    </ul>\r\n  </div>\r\n</nav>\r\n<br>\r\n"

/***/ }),

/***/ "./src/app/header/header.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return HeaderComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
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
    function HeaderComponent(router, route) {
        this.router = router;
        this.route = route;
        this.activeClass = '';
    }
    HeaderComponent.prototype.ngOnInit = function () {
        this.activeClass = 'active';
    };
    HeaderComponent.prototype.toggleActive = function () {
        location.reload();
    };
    HeaderComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-header',
            template: __webpack_require__("./src/app/header/header.component.html"),
            styles: [__webpack_require__("./src/app/header/header.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_1__angular_router__["a" /* ActivatedRoute */]])
    ], HeaderComponent);
    return HeaderComponent;
}());



/***/ }),

/***/ "./src/app/home/home.component.css":
/***/ (function(module, exports) {

module.exports = ".videoBox {\r\n  position: relative;\r\n  overflow: hidden;\r\n  height: 80vh;\r\n}\r\n\r\n.video {\r\n  position: absolute;\r\n  width: auto;\r\n  height: 100%;\r\n  top: 0;\r\n  left: 0;\r\n}\r\n\r\n.content {\r\n  margin: auto;\r\n  width: 90%;\r\n  bottom: 30%;\r\n  right: 0;\r\n  color: #ffc50e;\r\n  font-size: 2.5vw;\r\n  text-align: right;\r\n  position: absolute;\r\n  padding: 0 15vw 0 0;\r\n}\r\n\r\n.content h1{\r\n  color: #ffc50e;\r\n  font-size: 3.5vw;\r\n}\r\n\r\n@media only screen and (min-width: 576px) {\r\n  .content {\r\n    font-size: 2.0vw;\r\n    padding: 0 10vw 0 0;\r\n    width: 80%;\r\n  }\r\n  .content h1{\r\n    font-size: 3.0vw;\r\n  }\r\n\r\n}\r\n\r\n@media only screen and (min-width: 1140px) {\r\n  .content {\r\n    font-size: 1.5vw;\r\n    padding: 0 10vw 0 0;\r\n    width: 80%;\r\n  }\r\n  .content h1{\r\n    font-size: 2.5vw;\r\n  }\r\n}\r\n\r\n.blackwhite {\r\n  text-align: center;\r\n\r\n}\r\n\r\n.blackwhite p {\r\n  margin: auto;\r\n  width: 80%;\r\n  top: 50%;\r\n  color: white;\r\n  font-size: 1.3em;\r\n}\r\n\r\n.blackwhite p:first-letter {\r\n  font-size: 200%;\r\n  color: #ffc50e;\r\n}\r\n\r\n.nopadding {\r\n  padding: 0 !important;\r\n  margin: 0 !important;\r\n}\r\n\r\n/* entire container, keeps perspective */\r\n\r\n.flip-container {\r\n  background-color: white;\r\n  float: left;\r\n  -webkit-perspective: 1000px;\r\n          perspective: 1000px;\r\n}\r\n\r\n/* flip the pane when hovered */\r\n\r\n.flip-container:hover .flipper, .flip-container.hover .flipper {\r\n  -webkit-transform: rotateY(180deg);\r\n          transform: rotateY(180deg);\r\n}\r\n\r\n/* flip speed goes here */\r\n\r\n.flipper {\r\n  -webkit-transition: 0.6s;\r\n  transition: 0.6s;\r\n  -webkit-transform-style: preserve-3d;\r\n          transform-style: preserve-3d;\r\n  position: relative;\r\n}\r\n\r\n/* hide back of pane during swap */\r\n\r\n.front, .back{\r\n  -webkit-backface-visibility: hidden;\r\n          backface-visibility: hidden;\r\n  position: absolute;\r\n  top: 0;\r\n  left: 0;\r\n}\r\n\r\n/* front pane, placed above back */\r\n\r\n.front {\r\n  z-index: 2;\r\n  /* for firefox 31 */\r\n  -webkit-transform: rotateY(0deg);\r\n          transform: rotateY(0deg);\r\n  position: relative;\r\n}\r\n\r\n/* back, initially hidden pane */\r\n\r\n.back {\r\n  -webkit-transform: rotateY(180deg);\r\n          transform: rotateY(180deg);\r\n\r\n}\r\n\r\n.backdiv {\r\n  background-color: black;\r\n  color: white;\r\n  display: block;\r\n  height: 400px;\r\n  text-align: center;\r\n  vertical-align: middle;\r\n}\r\n\r\n.backdiv p {\r\n  position: relative;\r\n  top: 50%;\r\n  -webkit-transform: translateY(-50%);\r\n          transform: translateY(-50%);\r\n}\r\n\r\n.container {\r\n  padding:0;\r\n  margin:0;\r\n}\r\n\r\n.text {\r\n  color: white;\r\n  font-size: 40px;\r\n  position: absolute;\r\n  top: 50%;\r\n  left: 50%;\r\n  -webkit-transform: translate(-50%, -50%);\r\n          transform: translate(-50%, -50%);\r\n  -ms-transform: translate(-50%, -50%);\r\n  text-align: center;\r\n}\r\n\r\n.overlay {\r\n  position: absolute;\r\n  top: 0;\r\n  bottom: 0;\r\n  left: 0;\r\n  right: 0;\r\n  height: 100%;\r\n  width: 100%;\r\n}\r\n\r\n.backgroundWhite {\r\n  background-color: white;\r\n}\r\n\r\n.whiteblack {\r\n  text-align: center;\r\n  color: black;\r\n  background-color: white;\r\n  font-size: 0.8em;\r\n  padding: 0 10vw 0 10vw;\r\n}\r\n\r\n.whiteblack h1 {\r\n  margin: 70px;\r\n}\r\n\r\n@media only screen and (min-width: 576px) {\r\n  .whiteblack {\r\n    padding: 0 8vw 0 8vw;\r\n  }\r\n}\r\n\r\n@media only screen and (min-width: 960px) {\r\n  .whiteblack {\r\n    padding: 0 5vw 0 5vw;\r\n  }\r\n}\r\n\r\n@media only screen and (min-width: 1140px) {\r\n  .whiteblack {\r\n    padding: 0 4vw 0 4vw;\r\n  }\r\n}\r\n"

/***/ }),

/***/ "./src/app/home/home.component.html":
/***/ (function(module, exports) {

module.exports = "\n<div class=\"row videoBox\">\n  <div class=\"col-sm-12\">\n    <video class=\"video\" autoplay=\"\" muted=\"\" loop=\"\" poster=\"assets/video/thumb.jpg\">\n      <source src=\"assets/fruits.mp4\" type=\"video/mp4\">\n    </video>\n    <div class=\"content\">\n      <h1>Fruits</h1>\n      In botany, a fruit is the seed-bearing structure in flowering plants\n      <br>\n      (also known as angiosperms) formed from the ovary after flowering.\n    </div>\n  </div>\n\n</div>\n\n<br>\n\n<div class=\"row\">\n\n  <div class=\"col-lg-6 blackwhite\">\n    <p>Fruits are the means by which angiosperms disseminate seeds. Edible fruits, in particular, have propagated with the movements of\n      humans and animals in a symbiotic relationship as a means for seed dispersal and nutrition; in fact, humans and many animals have\n      become dependent on fruits as a source of food.[1] Accordingly, fruits account for a substantial fraction of the world's agricultural output,\n      and some (such as the apple and the pomegranate) have acquired extensive cultural and symbolic meanings.</p>\n  </div>\n  <br>\n  <div class=\"col-lg-6 blackwhite\">\n    <p>In common language usage, \"fruit\" normally means the fleshy seed-associated structures of a plant that are sweet or sour, and edible in the raw state,\n      such as apples, bananas, grapes, lemons, oranges, and strawberries. On the other hand, in botanical usage, \"fruit\" includes many structures that are not commonly called\n      \"fruits\", such as bean pods, corn kernels, tomatoes, and wheat grains.[2][3] The section of a fungus that produces spores is also called a fruiting body.</p>\n  </div>\n</div>\n\n\n<br>\n<br>\n<div class=\"row\">\n\n  <div class=\"col-lg-3 col-sm-6 nopadding\">\n    <div class=\"flip-container\" ontouchstart=\"this.classList.toggle('hover');\" style=\"width: 100%\">\n      <a routerLink=\"../blueberries\" >\n        <div class=\"flipper\">\n          <div class=\"front\">\n            <img src=\"assets/blueberries1.jpg\" alt=\"Berries\" style=\"width: 100%; height: 400px\">\n              <div class=\"overlay\">\n                <div class=\"text\">Blueberries</div>\n              </div>\n          </div>\n          <div class=\"back container\">\n              <div class=\"backdiv\">\n                  <p>Blueberries are very delicious<br>Helthy and blueeee<br>Try them out!</p>\n              </div>\n          </div>\n        </div>\n      </a>\n    </div>\n  </div>\n\n  <div class=\"col-lg-3 col-sm-6 nopadding\">\n    <div class=\"flip-container\" ontouchstart=\"this.classList.toggle('hover');\" style=\"width: 100%\">\n      <a routerLink=\"../grapes\" >\n        <div class=\"flipper\">\n          <div class=\"front\">\n            <img src=\"assets/grapes.jpg\" alt=\"Grapes\" style=\"width: 100%; height: 400px\">\n            <div class=\"overlay\">\n              <div class=\"text\">Grapes</div>\n            </div>\n          </div>\n          <div class=\"back container\">\n            <div class=\"backdiv\">\n              <p>Grapes Grapes Grapes<br>Just soooooo gooood<br>Try them out!</p>\n            </div>\n          </div>\n        </div>\n      </a>\n    </div>\n  </div>\n\n  <div class=\"col-lg-3 col-sm-6 nopadding\">\n    <div class=\"flip-container\" ontouchstart=\"this.classList.toggle('hover');\" style=\"width: 100%\">\n      <a routerLink=\"../bananas\" (click)=\"toggleActive()\" >\n        <div class=\"flipper\">\n          <div class=\"front\">\n            <img src=\"assets/bananas.jpg\" alt=\"Bananas\" style=\"width: 100%; height: 400px\">\n            <div class=\"overlay\">\n              <div class=\"text\">Bananas</div>\n            </div>\n          </div>\n          <div class=\"back container\">\n            <div class=\"backdiv\">\n              <p>Bananas are very yellow<br>They are bowed to fit into the skin<br>Try them out!</p>\n            </div>\n          </div>\n        </div>\n      </a>\n    </div>\n  </div>\n\n  <div class=\"col-lg-3 col-sm-6 nopadding\">\n    <div class=\"flip-container\" ontouchstart=\"this.classList.toggle('hover');\" style=\"width: 100%\">\n      <a routerLink=\"../strawberries\" (click)=\"toggleActive()\">\n        <div class=\"flipper\">\n          <div class=\"front\">\n            <img src=\"assets/strawberries.jpg\" alt=\"Strawberries\" style=\"width: 100%; height: 400px\">\n            <div class=\"overlay\">\n              <div class=\"text\">Strawberries</div>\n            </div>\n          </div>\n          <div class=\"back container\">\n            <div class=\"backdiv\">\n              <p>Strawberries are very healthy<br>Delicous and reeeed<br>Try them out!</p>\n            </div>\n          </div>\n        </div>\n      </a>\n    </div>\n  </div>\n</div>\n\n<div class=\"backgroundWhite\">\n  <div class=\"row whiteblack\">\n    <div class=\"col-lg-12\">\n      <h1 align=\"center\">All kind of fruits</h1>\n    </div>\n  </div>\n  <div class=\"row\">\n      <div class=\"col-lg-4 col-md-6 whiteblack\">\n        <h6>The Means</h6>\n        <p>Fruits are the means by which angiosperms disseminate seeds. Edible fruits, in particular, have propagated with the movements of\n          humans and animals in a symbiotic relationship as a means for seed dispersal and nutrition; in fact, humans and many animals have\n          become dependent on fruits as a source of food.[1] Accordingly, fruits account for a substantial fraction of the world's agricultural output,\n          and some (such as the apple and the pomegranate) have acquired extensive cultural and symbolic meanings.</p>\n      </div>\n      <div class=\"col-lg-4 col-md-6 whiteblack\">\n        <h6>Normally</h6>\n        <p>In common language usage, \"fruit\" normally means the fleshy seed-associated structures of a plant that are sweet or sour, and edible in the raw state,\n          such as apples, bananas, grapes, lemons, oranges, and strawberries. On the other hand, in botanical usage, \"fruit\" includes many structures that are not commonly called\n          \"fruits\", such as bean pods, corn kernels, tomatoes, and wheat grains.[2][3] The section of a fungus that produces spores is also called a fruiting body.</p>\n      </div>\n      <div class=\"col-lg-4 whiteblack\">\n        <img src=\"assets/fruits.jpg\" alt=\"fruits\" style=\"height:30%;\">\n      </div>\n  </div>\n</div>\n\n"

/***/ }),

/***/ "./src/app/home/home.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return HomeComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var HomeComponent = /** @class */ (function () {
    function HomeComponent(scrollService) {
        this.scrollService = scrollService;
    }
    HomeComponent.prototype.ngOnInit = function () {
        this.scrollService.setScroll(0, 0);
    };
    HomeComponent.prototype.toggleActive = function () {
        location.reload();
    };
    HomeComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-home',
            template: __webpack_require__("./src/app/home/home.component.html"),
            styles: [__webpack_require__("./src/app/home/home.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__scrollTo_service__["a" /* ScrollToService */]])
    ], HomeComponent);
    return HomeComponent;
}());



/***/ }),

/***/ "./src/app/image.model.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return Image; });
var Image = /** @class */ (function () {
    function Image(src, alt, desc) {
        this.src = src;
        this.alt = alt;
        this.desc = desc;
    }
    return Image;
}());



/***/ }),

/***/ "./src/app/scrollTo.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ScrollToService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_common__ = __webpack_require__("./node_modules/@angular/common/esm5/common.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};



var ScrollToService = /** @class */ (function () {
    function ScrollToService(platformId, router) {
        this.platformId = platformId;
        this.router = router;
    }
    ScrollToService.prototype.setScroll = function (x, y) {
        if (Object(__WEBPACK_IMPORTED_MODULE_2__angular_common__["j" /* isPlatformBrowser */])(this.platformId)) {
            this.router.events.subscribe(function (event) {
                window.scroll(x, y);
            });
        }
    };
    ScrollToService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["A" /* Injectable */])(),
        __param(0, Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["z" /* Inject */])(__WEBPACK_IMPORTED_MODULE_0__angular_core__["R" /* PLATFORM_ID */])),
        __metadata("design:paramtypes", [Object,
            __WEBPACK_IMPORTED_MODULE_1__angular_router__["b" /* Router */]])
    ], ScrollToService);
    return ScrollToService;
}());



/***/ }),

/***/ "./src/app/strawberries/strawberries.component.css":
/***/ (function(module, exports) {

module.exports = "\r\n.scrollbody {\r\n  position: relative;\r\n}\r\n\r\n.blackBackground {\r\n  display: inline-block;\r\n  background-color: black;\r\n  z-index: 10;\r\n  bottom:0px;\r\n  position: fixed;\r\n\r\n}\r\n\r\n.disabled {\r\n  pointer-events: none;\r\n  cursor: default;\r\n  background-color: black;\r\n  color: #ffc50e;\r\n}\r\n\r\n.nav-item .active {\r\n  background-color: darkred;\r\n  color: black;\r\n}\r\n\r\n.enabled {\r\n  cursor:pointer;\r\n}\r\n\r\n.containerContent {\r\n  margin-rigth: 20%;\r\n}\r\n\r\n.myBackground {\r\n  max-width: 100%;\r\n  border-radius: 200px;\r\n  width: 80vw;\r\n}\r\n\r\n.myBackground2 {\r\n  max-width: 80%;\r\n  border-radius: 200px;\r\n  width: 80vw;\r\n}\r\n\r\n.myBackground4 {\r\n  max-width: 80%;\r\n  border-radius: 200px;\r\n  width: 40vw;\r\n}\r\n\r\n.myBackground, .myBackground2, .myBackground3, .myBackground4 {\r\n  margin-left: 50px;\r\n}\r\n\r\n.headlineStory {\r\n  color: white;\r\n  padding-left: 50px;\r\n}\r\n\r\n.section1, .section2, .section3, .section4, .section5 {\r\n  color: #ffc50e;\r\n  margin-left: 50px;\r\n  max-width: 100%;\r\n}\r\n\r\n.section1 h3, .section2 h3, .section3 h3, .section4 h3, .section5 h3 {\r\n  color: darkred;\r\n}\r\n\r\n.jumbotron {\r\n  background-color: darkred;\r\n}\r\n\r\n.inMobileImg{\r\n  display: inline-block;\r\n}\r\n\r\n.outMobileImg {\r\n  display: none\r\n}\r\n\r\n.brWrapper  {\r\n  display: none;\r\n}\r\n\r\n.brWrapperNegative  {\r\n  display: inline-block;\r\n}\r\n\r\n@media only screen and (min-width: 1200px) {\r\n  ul.nav-pills {\r\n    top: 20px;\r\n    position: fixed;\r\n    display: inline-block;\r\n  }\r\n  .blackBackground {\r\n    position: relative;\r\n  }\r\n  .section1 {\r\n    color: #ffc50e;\r\n    margin-right: 40%;\r\n    margin-left: 10%;\r\n  }\r\n  .section2 {\r\n    color: #ffc50e;\r\n    margin-left: 20%;\r\n  }\r\n  .section3 {\r\n    margin-right: 40%;\r\n    margin-left: 20%;\r\n    color: #ffc50e;\r\n  }\r\n  .section4 {\r\n    margin-left: 20%;\r\n    margin-right: 10%;\r\n    color: #ffc50e;\r\n  }\r\n  .section5 {\r\n    margin-right: 20%;\r\n    color: #ffc50e;\r\n  }\r\n\r\n  .outMobileImg{\r\n    display: inline-block;\r\n  }\r\n  .inMobileImg {\r\n    display: none\r\n  }\r\n  .brWrapper  {\r\n    display: inline-block;\r\n  }\r\n  .brWrapperNegative  {\r\n    display: none;\r\n  }\r\n}\r\n\r\n@media only screen and (min-width: 576px) {\r\n  .myBackground, .myBackground2, .myBackground3, .myBackground4 {\r\n  width: 40vw;\r\n  }\r\n  .blackBackground {\r\n    width: 100vw;\r\n  }\r\n}\r\n\r\n\r\n"

/***/ }),

/***/ "./src/app/strawberries/strawberries.component.html":
/***/ (function(module, exports) {

module.exports = "\n\n\n\n<body class=\"scrollbody\" data-spy=\"scroll\" data-target=\"#myScrollspy\" data-offset=\"1\">\n<div id=\"top\" class=\"container-fluid\">\n  <div class=\"row\">\n    <div class=\"blackBackground col-xl-2\">\n      <nav id=\"myScrollspy\">\n        <ul class=\"nav nav-pills \">\n          <div class=\"brWrapper\">\n            <br>\n            <br>\n            <br>\n            <br>\n            <br>\n          </div>\n          <li class=\"nav-item\">\n            <a class=\"enabled\" (click)=\"onNavigate('section1')\"><a class=\"nav-link active disabled\" href=\"#section1\">The argument</a></a>\n          </li>\n          <li class=\"nav-item\">\n            <a class=\"enabled\" (click)=\"onNavigate('section2')\"><a class=\"nav-link disabled\"  href=\"#section2\">Woman in the forrest</a></a>\n          </li>\n          <li class=\"nav-item\">\n            <a class=\"enabled\" (click)=\"onNavigate('section3')\"><a class=\"nav-link disabled\"  href=\"#section3\">First man prayed</a></a>\n          </li>\n          <li class=\"nav-item\">\n            <a class=\"enabled\" (click)=\"onNavigate('section4')\"><a class=\"nav-link disabled\"  href=\"#section4\">Berry gets Strawberry</a></a>\n          </li>\n          <li class=\"nav-item\">\n            <a class=\"enabled\" (click)=\"onNavigate('section5')\"><a class=\"nav-link disabled\"  href=\"#section5\">Final</a></a>\n          </li>\n        </ul>\n      </nav>\n    </div>\n\n    <div class=\"col-xl-10\">\n      <br>\n      <br>\n      <div data-aos=\"zoom-in\" class=\"headlineStory\"><h1>STRAWBERRY LOVE STORY</h1></div>\n      <div data-aos=\"zoom-in\" class=\"headlineStory\"><h6>As told by Meadowlark Sanders</h6></div>\n      <br id=\"section1\" >\n      <br>\n      <br>\n      <div class=\"row\">\n        <div class=\"col-lg-4\">\n          <img data-aos=\"zoom-in\" class=\"myBackground\" src=\"assets/strawberries5.jpg\" alt=\"strawberries\">\n        </div>\n        <div class=\"col-lg-8\">\n          <div class=\"section1\">\n            <div class=\"brWrapperNegative\">\n              <br>\n              <br>\n              <br>\n            </div>\n            <div data-aos=\"fade-left\"><h3>The argument</h3></div>\n            <br>\n            <br>\n\n            <div data-aos=\"zoom-in-down\"><p>First man and First Woman had an argument.</p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-in-down\"><p>First Man said to First Woman, \"Why are you so lazy? I told you to have my meal ready hours ago.\" First Woman said,\n              \"If you would have gathered fire wood, it would be ready.\" First Man yelled, \"That is women’s work!\"</p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-in-down\"><p>Then First Woman began to cry. This made First Man even more angry. \"Why don’t you just leave if all you can do is cry?\" he said. So she did.</p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-in-down\"><p>She ran out the door of their lodge and through the clearing to the path at the edge of the forest. First Man paced the floor. \"Good! He exclaimed,\n              \"I am glad she is gone.\" Then he looked out the door, thinking she was standing at the edge of the clearing. He stepped out of the door wagging his fist, he yelled, \"And don’t come back!\"</p></div>\n            <br>\n            <br>\n          </div>\n        </div>\n    </div>\n      <br>\n      <br>\n      <br>\n      <br id=\"section2\">\n    <div class=\"brWrapper\">\n      <br>\n      <br>\n      <br>\n      <br>\n      <br>\n      <br>\n      <br>\n      <br>\n    </div>\n\n      <div class=\"row\">\n        <div class=\"col-lg-4 inMobileImg\">\n          <img data-aos=\"zoom-in\" class=\"myBackground2\" src=\"assets/strawberries3.jpg\" alt=\"strawberries\">\n        </div>\n        <div class=\"col-lg-6\">\n          <div class=\"section2\">\n            <div class=\"brWrapperNegative\">\n              <br>\n              <br>\n              <br>\n            </div>\n            <div data-aos=\"fade-right\"><h3>Woman in the forrest</h3></div>\n\n            <br>\n            <br>\n\n            <div data-aos=\"zoom-out-down\"><p>\n              First Woman ran deep into the forest. The sun began to sink behind the mountain. First Man had calmed down by now. When she did not come back, he walked to the edge of the clearing.\n              Again he called her name.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-down\"><p>\n              Still she did not come. He began to call her name louder and louder. There was no response.\n              The sky grew dark and the forest was darker. First Man returned to the lodge, thinking maybe she had slipped in while he was away. First Woman was not to be found.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-down\"><p> \"I will go look for her at daybreak,\" he thought as he lay down to sleep. But sleep did not come. All night long he tossed and turned thinking about the danger\n              First Woman might encounter. He prayed for her safety.\n            </p></div>\n            <br>\n            <br>\n          </div>\n        </div>\n        <div class=\"col-lg-4 outMobileImg\">\n          <img data-aos=\"zoom-in\" class=\"myBackground2\" src=\"assets/strawberries3.jpg\" alt=\"strawberries\">\n        </div>\n      </div>\n      <br>\n      <br>\n      <br>\n      <br id=\"section3\">\n      <div class=\"brWrapper\">\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n      </div>\n      <div class=\"row\">\n        <div class=\"col-lg-4\">\n          <img data-aos=\"zoom-in\" class=\"myBackground\" src=\"assets/strawberries4.jpg\" alt=\"strawberries\">\n        </div>\n        <div class=\"col-lg-8\">\n          <div class=\"section3\">\n            <div class=\"brWrapperNegative\">\n              <br>\n              <br>\n              <br>\n            </div>\n            <div data-aos=\"fade-left\"><h3>First man prayed</h3></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-right\"><p>Early the next morning, before the sun rose over the trees, First Man prayed as he entered the forest. \"Creator,\" I am so sorry for the things I said to First Woman.\n              Please cause a patch of flowers to spring up in her path.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-right\"><p>\n              She will surely stop to smell them and I will be able to catch up to her and tell her how sorry I am.\" So the Creator placed a patch of\n              beautiful flowers in her path. But she did not stop to smell them. In her anger, she kept walking fast.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-right\"><p>First Man was fast on her tracks. He found the place where she had rested for the night. Shortly afterwards, he found the patch of beautiful flowers Creator had placed for her.\n              He looked all around, but she was not to be found.\n            </p></div>\n            <br>\n            <br>\n          </div>\n        </div>\n      </div>\n\n      <br>\n      <br>\n      <br>\n      <br id=\"section4\" >\n      <div class=\"brWrapper\">\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-lg-4 inMobileImg\">\n          <img data-aos=\"zoom-in\" class=\"myBackground2\" src=\"assets/strawberries6.jpg\" alt=\"strawberries\">\n        </div>\n        <div class=\"col-lg-8\">\n          <div class=\"section4\">\n            <div class=\"brWrapperNegative\">\n              <br>\n              <br>\n              <br>\n            </div>\n            <div data-aos=\"fade-right\"><h3>Berry gets Strawberry</h3></div>\n            <br>\n            <br>\n\n            <div data-aos=\"zoom-out-left\"><p> Again, he prayed, \"Creator, she must be hungry by now. Please cause a patch of berries to spring up in her path, so when she stops to eat, I can catch up to her.\"\n              Creator placed a patch of Blackberries in First Woman’s path. The berries were tempting, but the briars tore at her soft skin. She ran on.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-left\"><p>\n              Soon First Man came across the Blackberry Patch. Seeing she was not there, he prayed once more \"Creator, I am such a fool. You know far better than I what would please First Woman.\n              Would you choose something to put in her path to slow her down, so I can tell her how much I love her?\"\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-left\"><p>Creator reached down to the beautiful flower patch and picked the most delicate white flower. He then reached over and picked some berries and pricked his finger on the thorns.\n              Drops of blood turned the berries large, bright red and heart-shaped.\n            </p></div>\n            <br>\n            <br>\n            <div data-aos=\"zoom-out-left\"><p>\n              He placed the white flowers and the red berries in the path of First Woman.\n              When First Woman saw the bright red berries and the delicate flowers she stopped to drink in their beauty.\n            </p></div>\n          </div>\n            <br>\n            <br>\n        </div>\n        <div class=\"col-lg-4 outMobileImg\">\n          <img data-aos=\"zoom-in\" class=\"myBackground2\" src=\"assets/strawberries6.jpg\" alt=\"strawberries\">\n        </div>\n      </div>\n\n\n      <br>\n      <br>\n      <br>\n      <br id=\"section5\">\n      <div class=\"brWrapper\">\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n        <br>\n      </div>\n\n\n      <br>\n        <br>\n        <div class=\"row\">\n          <div class=\"col-lg-4\">\n            <img data-aos=\"zoom-in\" class=\"myBackground\" src=\"assets/strawberries2.jpg\" alt=\"strawberries\">\n          </div>\n          <div class=\"col-lg-8\">\n            <div class=\"section5\">\n              <div class=\"brWrapperNegative\">\n                <br>\n                <br>\n                <br>\n              </div>\n              <div data-aos=\"fade-left\"><h3>Final</h3></div>\n              <br>\n              <br>\n              <div data-aos=\"fade-down-left\"><p>\n                She saw no thorns so she tasted one of the berries. It was so sweet she sat down and began to eat her fill.\n                She saw the berry was heart-shaped, so as she ate the berries she began to think of the sweet things First Man had done for her in the past.\n              </p></div>\n              <br>\n              <br>\n              <div data-aos=\"fade-down-left\"><p>\n                The more she ate, the more sweet things she remembered. Looking at the pure white flowers she remembered how pure her love for him had been.\n                She began to sob. As she cried, she asked Creator to bring her husband to her, so she could tell him how sorry she was and how much she loved him.\n              </p></div>\n              <br>\n              <br>\n              <div data-aos=\"fade-down-left\"><p>\n              Just as she had finished praying, her husband appeared from behind a tree. They held each other, exchanged loving words and forgave each other.\n              </p></div>\n              <br>\n              <br>\n              <div data-aos=\"fade-down-left\"><p>This is why the Cherokee always have fresh whole strawberries, jam and pictures in their home.\n                It is a reminder not to argue with one another. Their heart-shape reminds us if we do slip and say something hurtful, to pray, ask for forgiveness and say loving words, just as First Man and First Woman did.\n              </p></div>\n              <br>\n              <br>\n            </div>\n          </div>\n        </div>\n    </div>\n  </div>\n</div>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n<br>\n</body>\n\n\n"

/***/ }),

/***/ "./src/app/strawberries/strawberries.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return StrawberriesComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__scrollTo_service__ = __webpack_require__("./src/app/scrollTo.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_aos__ = __webpack_require__("./node_modules/aos/dist/aos.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_aos___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_aos__);
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var StrawberriesComponent = /** @class */ (function () {
    function StrawberriesComponent(scrollService) {
        this.scrollService = scrollService;
    }
    StrawberriesComponent.prototype.ngOnInit = function () {
        this.scrollService.setScroll(0, 0);
        __WEBPACK_IMPORTED_MODULE_2_aos__["init"]({
            duration: 3000
        });
    };
    StrawberriesComponent.prototype.onNavigate = function (section) {
        var x = document.querySelector('#' + section);
        console.log(x);
        if (x) {
            x.scrollIntoView();
        }
    };
    StrawberriesComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-strawberries',
            template: __webpack_require__("./src/app/strawberries/strawberries.component.html"),
            styles: [__webpack_require__("./src/app/strawberries/strawberries.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__scrollTo_service__["a" /* ScrollToService */]])
    ], StrawberriesComponent);
    return StrawberriesComponent;
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
    Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_12" /* enableProdMode */])();
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