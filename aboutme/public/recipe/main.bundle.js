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

/***/ "./src/app/app-routing.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppRoutingModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__recipes_recipes_component__ = __webpack_require__("./src/app/recipes/recipes.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__shopping_list_shopping_list_component__ = __webpack_require__("./src/app/shopping-list/shopping-list.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__recipes_recipe_start_recipe_start_component__ = __webpack_require__("./src/app/recipes/recipe-start/recipe-start.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__recipes_recipe_detail_recipe_detail_component__ = __webpack_require__("./src/app/recipes/recipe-detail/recipe-detail.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__recipes_recipe_edit_recipe_edit_component__ = __webpack_require__("./src/app/recipes/recipe-edit/recipe-edit.component.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};







var appRoutes = [
    { path: '', redirectTo: '/recipes', pathMatch: 'full' },
    { path: 'recipes', component: __WEBPACK_IMPORTED_MODULE_2__recipes_recipes_component__["a" /* RecipesComponent */], children: [
            { path: '', component: __WEBPACK_IMPORTED_MODULE_4__recipes_recipe_start_recipe_start_component__["a" /* RecipeStartComponent */] },
            { path: 'new', component: __WEBPACK_IMPORTED_MODULE_6__recipes_recipe_edit_recipe_edit_component__["a" /* RecipeEditComponent */] },
            { path: ':id', component: __WEBPACK_IMPORTED_MODULE_5__recipes_recipe_detail_recipe_detail_component__["a" /* RecipeDetailComponent */] },
            { path: ':id/edit', component: __WEBPACK_IMPORTED_MODULE_6__recipes_recipe_edit_recipe_edit_component__["a" /* RecipeEditComponent */] }
        ] },
    { path: 'shopping-list', component: __WEBPACK_IMPORTED_MODULE_3__shopping_list_shopping_list_component__["a" /* ShoppingListComponent */] }
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

module.exports = ""

/***/ }),

/***/ "./src/app/app.component.html":
/***/ (function(module, exports) {

module.exports = "<app-header></app-header>\n\n<div class=\"container\">\n  <div class=\"row\">\n    <div class=\"col-md-12\">\n      <router-outlet></router-outlet>\n    </div>\n  </div>\n</div>\n"

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
        this.loadedFeature = 'recipe';
    }
    AppComponent.prototype.onNavigate = function (feature) {
        this.loadedFeature = feature;
    };
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
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__app_component__ = __webpack_require__("./src/app/app.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__header_header_component__ = __webpack_require__("./src/app/header/header.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__recipes_recipes_component__ = __webpack_require__("./src/app/recipes/recipes.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__recipes_recipe_list_recipe_list_component__ = __webpack_require__("./src/app/recipes/recipe-list/recipe-list.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__recipes_recipe_detail_recipe_detail_component__ = __webpack_require__("./src/app/recipes/recipe-detail/recipe-detail.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__recipes_recipe_list_recipe_item_recipe_item_component__ = __webpack_require__("./src/app/recipes/recipe-list/recipe-item/recipe-item.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__shopping_list_shopping_list_component__ = __webpack_require__("./src/app/shopping-list/shopping-list.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__shopping_list_shopping_edit_shopping_edit_component__ = __webpack_require__("./src/app/shopping-list/shopping-edit/shopping-edit.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__shared_dropdown_directive__ = __webpack_require__("./src/app/shared/dropdown.directive.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__shopping_list_shopping_list_service__ = __webpack_require__("./src/app/shopping-list/shopping-list.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_13__app_routing_module__ = __webpack_require__("./src/app/app-routing.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_14__recipes_recipe_start_recipe_start_component__ = __webpack_require__("./src/app/recipes/recipe-start/recipe-start.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_15__recipes_recipe_edit_recipe_edit_component__ = __webpack_require__("./src/app/recipes/recipe-edit/recipe-edit.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_16__recipes_recipe_service__ = __webpack_require__("./src/app/recipes/recipe.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_17__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
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
                __WEBPACK_IMPORTED_MODULE_3__app_component__["a" /* AppComponent */],
                __WEBPACK_IMPORTED_MODULE_4__header_header_component__["a" /* HeaderComponent */],
                __WEBPACK_IMPORTED_MODULE_5__recipes_recipes_component__["a" /* RecipesComponent */],
                __WEBPACK_IMPORTED_MODULE_6__recipes_recipe_list_recipe_list_component__["a" /* RecipeListComponent */],
                __WEBPACK_IMPORTED_MODULE_7__recipes_recipe_detail_recipe_detail_component__["a" /* RecipeDetailComponent */],
                __WEBPACK_IMPORTED_MODULE_8__recipes_recipe_list_recipe_item_recipe_item_component__["a" /* RecipeItemComponent */],
                __WEBPACK_IMPORTED_MODULE_9__shopping_list_shopping_list_component__["a" /* ShoppingListComponent */],
                __WEBPACK_IMPORTED_MODULE_10__shopping_list_shopping_edit_shopping_edit_component__["a" /* ShoppingEditComponent */],
                __WEBPACK_IMPORTED_MODULE_11__shared_dropdown_directive__["a" /* DropdownDirective */],
                __WEBPACK_IMPORTED_MODULE_14__recipes_recipe_start_recipe_start_component__["a" /* RecipeStartComponent */],
                __WEBPACK_IMPORTED_MODULE_15__recipes_recipe_edit_recipe_edit_component__["a" /* RecipeEditComponent */]
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__["a" /* BrowserModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["d" /* FormsModule */],
                __WEBPACK_IMPORTED_MODULE_13__app_routing_module__["a" /* AppRoutingModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["f" /* ReactiveFormsModule */],
                __WEBPACK_IMPORTED_MODULE_17__angular_http__["b" /* HttpModule */]
            ],
            providers: [__WEBPACK_IMPORTED_MODULE_12__shopping_list_shopping_list_service__["a" /* ShoppingListService */], __WEBPACK_IMPORTED_MODULE_16__recipes_recipe_service__["a" /* RecipeService */]],
            bootstrap: [__WEBPACK_IMPORTED_MODULE_3__app_component__["a" /* AppComponent */]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/header/header.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/header/header.component.html":
/***/ (function(module, exports) {

module.exports = "<nav class=\"navbar navbar-default\">\r\n  <div class=\"container-fluid\">\r\n    <div class=\"navbar-header\">\r\n      <a routerLink=\"recipes\" class=\"navbar-brand\">Recipe Book</a>\r\n    </div>\r\n\r\n    <div class=\"navbar-default\">\r\n      <ul class=\"nav navbar-nav\">\r\n        <li routerLinkActive=\"active\"><a routerLink=\"/recipes\">Recipes</a></li>\r\n        <li routerLinkActive=\"active\"><a routerLink=\"/shopping-list\">Shopping List</a></li>\r\n      </ul>\r\n    </div>\r\n  </div>\r\n</nav>\r\n"

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

var HeaderComponent = /** @class */ (function () {
    function HeaderComponent() {
    }
    HeaderComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-header',
            template: __webpack_require__("./src/app/header/header.component.html"),
            styles: [__webpack_require__("./src/app/header/header.component.css")]
        })
    ], HeaderComponent);
    return HeaderComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe-detail/recipe-detail.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/recipes/recipe-detail/recipe-detail.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <img\n      [src]=\"recipe.imagePath\"\n      alt=\"{{ recipe.name}}\"\n      class=\"img-responsive\"\n      style=\"max-height: 300px;\">\n  </div>\n</div>\n\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <h1>{{ recipe.name }}</h1>\n  </div>\n</div>\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <div class=\"btn-group\" appDropdown>\n      <button type=\"button\" class=\"btn btn-primary dropdown-toggle\">Manage Recipe\n      <span class=\"caret\"></span></button>\n      <ul class=\"dropdown-menu\">\n        <li><a (click)=\"onAddToShoppingList()\" style=\"cursor: pointer\">To Shopping List</a></li>\n        <li><a (click)=\"onEditRecipe()\" style=\"cursor: pointer\">Edit Recipe</a></li>\n        <li><a (click)=\"onDeleteRecipe()\" style=\"cursor: pointer\">Delete Recipe</a></li>\n      </ul>\n    </div>\n  </div>\n</div>\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n    {{ recipe.description }}\n  </div>\n</div>\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <ul class=\"list-group\">\n      <li\n        class=\"list-group-item\"\n        *ngFor=\"let ingredient of recipe.ingredients\"\n      >\n        {{ ingredient.name}} - {{ ingredient.amount }}\n      </li>\n    </ul>\n  </div>\n</div>\n\n"

/***/ }),

/***/ "./src/app/recipes/recipe-detail/recipe-detail.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeDetailComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__recipe_service__ = __webpack_require__("./src/app/recipes/recipe.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var RecipeDetailComponent = /** @class */ (function () {
    function RecipeDetailComponent(recipeService, router, route) {
        this.recipeService = recipeService;
        this.router = router;
        this.route = route;
    }
    RecipeDetailComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.route.params.subscribe(function (params) {
            _this.id = params['id'];
            _this.recipe = _this.recipeService.getRecipe(_this.id);
        });
    };
    RecipeDetailComponent.prototype.onAddToShoppingList = function () {
        this.recipeService.addIngredientsToShoppingList(this.recipe.ingredients);
    };
    RecipeDetailComponent.prototype.onEditRecipe = function () {
        this.router.navigate(['edit'], { relativeTo: this.route });
    };
    RecipeDetailComponent.prototype.onDeleteRecipe = function () {
        this.recipeService.deleteRecipe(this.id);
        this.router.navigate(['/recipes']);
    };
    RecipeDetailComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipe-detail',
            template: __webpack_require__("./src/app/recipes/recipe-detail/recipe-detail.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipe-detail/recipe-detail.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__recipe_service__["a" /* RecipeService */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["a" /* ActivatedRoute */]])
    ], RecipeDetailComponent);
    return RecipeDetailComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe-edit/recipe-edit.component.css":
/***/ (function(module, exports) {

module.exports = "input.ng-invalid.ng-touched,\r\ntextarea.ng-invalid.ng-touched{\r\n  border: 1px solid red;\r\n}\r\n"

/***/ }),

/***/ "./src/app/recipes/recipe-edit/recipe-edit.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <form [formGroup]=\"recipeForm\" (ngSubmit)=\"onSubmit()\">\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <button type=\"submit\" class=\"btn btn-success\" [disabled]=\"!recipeForm.valid\">Save</button>\n          <button type=\"button\" class=\"btn btn-danger\" (click)=\"onCancel()\">Cancel</button>\n        </div>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <div class=\"form-group\">\n            <label for=\"name\">Name</label>\n            <input\n              type=\"text\"\n              id=\"name\"\n              formControlName=\"name\"\n              class=\"form-control\"\n            >\n          </div>\n        </div>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <div class=\"form-group\">\n            <label for=\"imagePath\">Image URL</label>\n            <input\n              type=\"text\"\n              id=\"imagePath\"\n              formControlName=\"imagePath\"\n              class=\"form-control\"\n              #imagePath\n            >\n          </div>\n        </div>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <img [src]=\"imagePath.value\" class=\"img-responsive\">\n        </div>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <div class=\"form-group\">\n            <label for=\"description\">Description</label>\n            <textarea\n              type=\"text\"\n              id=\"description\"\n              formControlName=\"description\"\n              class=\"form-control\"\n              rows=\"6\"\n            ></textarea>\n          </div>\n        </div>\n      </div>\n\n      <div class=\"row\">\n        <div class=\"col-xs-12\" formArrayName=\"ingredients\">\n          <div\n            class=\"row\"\n            *ngFor=\"let ingredientCtrl of recipeForm.get('ingredients').controls; let i = index\"\n            [formGroupName]=\"i\"\n            style=\"margin-top: 10px;\"\n          >\n\n            <div class=\"col-xs-8\">\n              <input\n                type=\"text\"\n                class=\"form-control\"\n                formControlName=\"name\"\n              >\n            </div>\n\n            <div class=\"col-xs-2\">\n              <input\n                type=\"number\"\n                class=\"form-control\"\n                formControlName=\"amount\"\n              >\n            </div>\n\n            <div class=\"col-xs-2\">\n              <button\n                class=\"btn btn-danger\"\n                type=\"button\"\n                (click)=\"onDeleteIngredient(i)\"\n              >X</button>\n            </div>\n\n          </div>\n          <hr>\n          <div class=\"row\">\n            <div class=\"col-xs-12\">\n              <button class=\"btn btn-success\" type=\"button\" (click)=\"onAddIngredient()\">Add Ingredient</button>\n            </div>\n          </div>\n        </div>\n      </div>\n\n    </form>\n  </div>\n\n\n</div>\n"

/***/ }),

/***/ "./src/app/recipes/recipe-edit/recipe-edit.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeEditComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__recipe_service__ = __webpack_require__("./src/app/recipes/recipe.service.ts");
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





var RecipeEditComponent = /** @class */ (function () {
    function RecipeEditComponent(route, recipeService, router, http) {
        this.route = route;
        this.recipeService = recipeService;
        this.router = router;
        this.http = http;
        this.editMode = false;
    }
    RecipeEditComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.route.params
            .subscribe(function (params) {
            _this.id = params['id'];
            _this.editMode = params['id'] != null;
            _this.initForm();
        });
    };
    RecipeEditComponent.prototype.onSubmit = function () {
        if (this.editMode) {
            this.recipeService.updateRecipe(this.id, this.recipeForm.value);
            this.onCancel();
        }
        else {
            this.recipeService.addRecipe(this.recipeForm.value);
            this.onCancel();
        }
    };
    RecipeEditComponent.prototype.onAddIngredient = function () {
        this.recipeForm.get('ingredients').push(new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["c" /* FormGroup */]({
            'name': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](null, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required),
            'amount': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](null, [
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required,
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].pattern(/^[1-9]+[0-9]*$/)
            ])
        }));
    };
    RecipeEditComponent.prototype.onCancel = function () {
        this.router.navigate(['../'], { relativeTo: this.route });
    };
    RecipeEditComponent.prototype.onDeleteIngredient = function (index) {
        this.recipeForm.get('ingredients').removeAt(index);
    };
    RecipeEditComponent.prototype.initForm = function () {
        var recipeName = '';
        var recipeImagePath = '';
        var recipeDescription = '';
        var recipeIngredients = new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["a" /* FormArray */]([]);
        if (this.editMode) {
            var recipe = this.recipeService.getRecipe(this.id);
            recipeName = recipe.name;
            recipeImagePath = recipe.imagePath;
            recipeDescription = recipe.description;
            if (recipe['ingredients']) {
                for (var _i = 0, _a = recipe.ingredients; _i < _a.length; _i++) {
                    var ingredient = _a[_i];
                    recipeIngredients.push(new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["c" /* FormGroup */]({
                        'name': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](ingredient.name, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required),
                        'amount': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](ingredient.amount, [
                            __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required,
                            __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].pattern(/^[1-9]+[0-9]*$/)
                        ])
                    }));
                }
            }
        }
        this.recipeForm = new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["c" /* FormGroup */]({
            'name': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](recipeName, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required),
            'imagePath': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](recipeImagePath, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required),
            'description': new __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormControl */](recipeDescription, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["g" /* Validators */].required),
            'ingredients': recipeIngredients
        });
    };
    RecipeEditComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipe-edit',
            template: __webpack_require__("./src/app/recipes/recipe-edit/recipe-edit.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipe-edit/recipe-edit.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__angular_router__["a" /* ActivatedRoute */],
            __WEBPACK_IMPORTED_MODULE_3__recipe_service__["a" /* RecipeService */],
            __WEBPACK_IMPORTED_MODULE_1__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_4__angular_http__["a" /* Http */]])
    ], RecipeEditComponent);
    return RecipeEditComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-item/recipe-item.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-item/recipe-item.component.html":
/***/ (function(module, exports) {

module.exports = "<a\n  style=\"cursor: pointer\"\n  [routerLink]=\"[index]\"\n  class=\"list-group-item clearfix\"\n  routerLinkActive=\"active\"\n  >\n  <div class=\"pull-left\">\n    <h4 class=\"list-group-item-heading\">{{ recipe.name }}</h4>\n    <p class=\"list-group-item-text\">{{ recipe.description }}</p>\n  </div>\n  <span class=\"pull-right\">\n        <img\n          [src]=\"recipe.imagePath\"\n          alt=\"{{ recipe.name }}\"\n          class=\"img-responsive\"\n          style=\"max-height: 50px;\">\n      </span>\n</a>\n"

/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-item/recipe-item.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeItemComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__recipe_model__ = __webpack_require__("./src/app/recipes/recipe.model.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var RecipeItemComponent = /** @class */ (function () {
    function RecipeItemComponent() {
    }
    RecipeItemComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["D" /* Input */])(),
        __metadata("design:type", __WEBPACK_IMPORTED_MODULE_1__recipe_model__["a" /* Recipe */])
    ], RecipeItemComponent.prototype, "recipe", void 0);
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["D" /* Input */])(),
        __metadata("design:type", String)
    ], RecipeItemComponent.prototype, "index", void 0);
    RecipeItemComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipe-item',
            template: __webpack_require__("./src/app/recipes/recipe-list/recipe-item/recipe-item.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipe-list/recipe-item/recipe-item.component.css")]
        })
    ], RecipeItemComponent);
    return RecipeItemComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-list.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-list.component.html":
/***/ (function(module, exports) {

module.exports = "\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <button class=\"btn btn-success\" (click)=\"onNewRecipe()\">New Recipe</button>\n  </div>\n</div>\n<hr>\n<div class=\"row\">\n  <div class=\"col-xs-12\">\n\n    <app-recipe-item\n      *ngFor=\"let recipeEl of recipes; let i = index\"\n      [recipe]=\"recipeEl\"\n      [index]=\"recipeEl._id\"\n    ></app-recipe-item>\n  </div>\n</div>\n\n\n\n\n"

/***/ }),

/***/ "./src/app/recipes/recipe-list/recipe-list.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeListComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__recipe_service__ = __webpack_require__("./src/app/recipes/recipe.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_router__ = __webpack_require__("./node_modules/@angular/router/esm5/router.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var RecipeListComponent = /** @class */ (function () {
    function RecipeListComponent(recipeService, router, route) {
        this.recipeService = recipeService;
        this.router = router;
        this.route = route;
    }
    RecipeListComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.recipeService.recipesChanged.subscribe(function (recipes) {
            _this.recipes = recipes;
        });
        this.recipeService.getRecipes();
    };
    RecipeListComponent.prototype.onNewRecipe = function () {
        this.router.navigate(['new'], { relativeTo: this.route });
    };
    RecipeListComponent.prototype.ngOnDestroy = function () {
        this.subscription.unsubscribe();
    };
    RecipeListComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipe-list',
            template: __webpack_require__("./src/app/recipes/recipe-list/recipe-list.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipe-list/recipe-list.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__recipe_service__["a" /* RecipeService */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["b" /* Router */],
            __WEBPACK_IMPORTED_MODULE_2__angular_router__["a" /* ActivatedRoute */]])
    ], RecipeListComponent);
    return RecipeListComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe-start/recipe-start.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/recipes/recipe-start/recipe-start.component.html":
/***/ (function(module, exports) {

module.exports = "<h3>Please select a recipe</h3>\n"

/***/ }),

/***/ "./src/app/recipes/recipe-start/recipe-start.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeStartComponent; });
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

var RecipeStartComponent = /** @class */ (function () {
    function RecipeStartComponent() {
    }
    RecipeStartComponent.prototype.ngOnInit = function () {
    };
    RecipeStartComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipe-start',
            template: __webpack_require__("./src/app/recipes/recipe-start/recipe-start.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipe-start/recipe-start.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], RecipeStartComponent);
    return RecipeStartComponent;
}());



/***/ }),

/***/ "./src/app/recipes/recipe.model.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return Recipe; });
var Recipe = /** @class */ (function () {
    function Recipe(_id, name, desc, imagePath, ingredients) {
        this._id = _id;
        this.name = name;
        this.description = desc;
        this.imagePath = imagePath;
        this.ingredients = ingredients;
    }
    return Recipe;
}());



/***/ }),

/***/ "./src/app/recipes/recipe.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipeService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__shopping_list_shopping_list_service__ = __webpack_require__("./src/app/shopping-list/shopping-list.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_rxjs_Subject__ = __webpack_require__("./node_modules/rxjs/_esm5/Subject.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_http__ = __webpack_require__("./node_modules/@angular/http/esm5/http.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var RecipeService = /** @class */ (function () {
    function RecipeService(slService, http) {
        this.slService = slService;
        this.http = http;
        this.recipesChanged = new __WEBPACK_IMPORTED_MODULE_2_rxjs_Subject__["a" /* Subject */]();
        this.recipes = [];
    }
    RecipeService.prototype.getRecipes = function () {
        var _this = this;
        this.http.get('http://www.meiermichael.de/restangulargetallrecipes').subscribe(function (response) {
            _this.recipes = response.json().recipes;
            _this.recipesChanged.next(_this.recipes.slice());
        });
    };
    ;
    RecipeService.prototype.addIngredientsToShoppingList = function (ingredients) {
        this.slService.addIngredients(ingredients);
    };
    RecipeService.prototype.getRecipe = function (id) {
        for (var i = 0; i < this.recipes.length; i++) {
            if (this.recipes[i]._id === id) {
                return this.recipes[i];
            }
        }
    };
    RecipeService.prototype.addRecipe = function (recipe) {
        var _this = this;
        this.http.post('http://www.meiermichael.de/restangularaddnewrecipe', recipe).subscribe(function (response) {
            _this.recipes.push(response.json());
            _this.recipesChanged.next(_this.recipes.slice());
        });
    };
    RecipeService.prototype.updateRecipe = function (index, newRecipe) {
        var _this = this;
        newRecipe._id = index;
        this.http.post('http://www.meiermichael.de/restangularupdaterecipe', newRecipe).subscribe(function (response) {
            for (var i = 0; i < _this.recipes.length; i++) {
                if (_this.recipes[i]._id === index) {
                    _this.recipes[i] = response.json().recipe;
                }
                if (i === _this.recipes.length - 1) {
                    _this.recipesChanged.next(_this.recipes.slice());
                }
            }
        });
    };
    RecipeService.prototype.deleteRecipe = function (index) {
        var _this = this;
        var body = { index: index };
        for (var i = 0; i < this.recipes.length; i++) {
            if (this.recipes[i]._id === index) {
                this.recipes.splice(i, 1);
            }
        }
        this.http.post('http://www.meiermichael.de/restangulardeleterecipe', body).subscribe(function (response) {
            _this.recipesChanged.next(_this.recipes.slice());
        });
    };
    RecipeService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["A" /* Injectable */])(),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__shopping_list_shopping_list_service__["a" /* ShoppingListService */],
            __WEBPACK_IMPORTED_MODULE_3__angular_http__["a" /* Http */]])
    ], RecipeService);
    return RecipeService;
}());



/***/ }),

/***/ "./src/app/recipes/recipes.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/recipes/recipes.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"row\">\n  <div class=\"col-md-5\">\n    <app-recipe-list></app-recipe-list>\n  </div>\n  <div class=\"col-md-7\">\n    <router-outlet></router-outlet>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/recipes/recipes.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return RecipesComponent; });
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

var RecipesComponent = /** @class */ (function () {
    function RecipesComponent() {
    }
    RecipesComponent.prototype.ngOnInit = function () {
    };
    RecipesComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-recipes',
            template: __webpack_require__("./src/app/recipes/recipes.component.html"),
            styles: [__webpack_require__("./src/app/recipes/recipes.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], RecipesComponent);
    return RecipesComponent;
}());



/***/ }),

/***/ "./src/app/shared/dropdown.directive.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return DropdownDirective; });
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

var DropdownDirective = /** @class */ (function () {
    function DropdownDirective() {
        this.isOpen = false;
    }
    DropdownDirective.prototype.toggleOpen = function () {
        this.isOpen = !this.isOpen;
    };
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["x" /* HostBinding */])('class.open'),
        __metadata("design:type", Boolean)
    ], DropdownDirective.prototype, "isOpen", void 0);
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["y" /* HostListener */])('click'),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", void 0)
    ], DropdownDirective.prototype, "toggleOpen", null);
    DropdownDirective = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["s" /* Directive */])({
            selector: '[appDropdown]'
        })
    ], DropdownDirective);
    return DropdownDirective;
}());



/***/ }),

/***/ "./src/app/shared/ingredient.model.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return Ingredient; });
var Ingredient = /** @class */ (function () {
    function Ingredient(name, amount) {
        this.name = name;
        this.amount = amount;
    }
    return Ingredient;
}());



/***/ }),

/***/ "./src/app/shopping-list/shopping-edit/shopping-edit.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/shopping-list/shopping-edit/shopping-edit.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"row\">\n  <div class=\"col-xs-12\">\n    <form (ngSubmit)=\"onAddItem(f)\" #f=\"ngForm\">\n      <div class=\"row\">\n        <div class=\"col-sm-5 form-group\">\n          <label for=\"name\">Name</label>\n          <input\n            type=\"text\"\n            id=\"name\"\n            class=\"form-control\"\n            name=\"name\"\n            ngModel\n            required\n          >\n        </div>\n        <div class=\"col-sm-2 form-group\">\n          <label for=\"amount\">Amount</label>\n          <input\n            type=\"number\"\n            id=\"amount\"\n            class=\"form-control\"\n            name=\"amount\"\n            ngModel\n            required\n            pattern=\"[1-9]+[0-9]*$\"\n          >\n        </div>\n      </div>\n      <div class=\"row\">\n        <div class=\"col-xs-12\">\n          <button class=\"btn btn-success\" type=\"submit\" [disabled]=\"!f.valid\">{{ editMode ? 'Update' : 'Add'}}</button>\n          <button class=\"btn btn-danger\" type=\"button\" (click)=\"onDelete()\" *ngIf=\"editMode\">Delete</button>\n          <button class=\"btn btn-primary\" type=\"button\" (click)=\"onClear()\">Clear</button>\n        </div>\n      </div>\n    </form>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/shopping-list/shopping-edit/shopping-edit.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ShoppingEditComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__shared_ingredient_model__ = __webpack_require__("./src/app/shared/ingredient.model.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__shopping_list_service__ = __webpack_require__("./src/app/shopping-list/shopping-list.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_forms__ = __webpack_require__("./node_modules/@angular/forms/esm5/forms.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var ShoppingEditComponent = /** @class */ (function () {
    function ShoppingEditComponent(slService) {
        this.slService = slService;
        this.editMode = false;
    }
    ShoppingEditComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.subscription = this.slService.startedEditing.subscribe(function (index) {
            _this.editMode = true;
            _this.editedItemIndex = index;
            _this.editedItem = _this.slService.getIndgredient(index);
            _this.slForm.setValue({
                name: _this.editedItem.name,
                amount: _this.editedItem.amount
            });
        });
    };
    ShoppingEditComponent.prototype.onAddItem = function (form) {
        var value = form.value;
        var newIngredient = new __WEBPACK_IMPORTED_MODULE_1__shared_ingredient_model__["a" /* Ingredient */](value.name, value.amount);
        if (this.editMode) {
            this.slService.updateIngredient(this.editedItemIndex, newIngredient);
        }
        else {
            this.slService.addIngredient(newIngredient);
        }
        this.editMode = false;
        form.reset();
    };
    ShoppingEditComponent.prototype.onClear = function () {
        this.slForm.reset();
        this.editMode = false;
    };
    ShoppingEditComponent.prototype.onDelete = function () {
        this.slService.deleteIngredient(this.editedItemIndex);
        this.onClear();
    };
    ShoppingEditComponent.prototype.ngOnDestroy = function () {
        this.subscription.unsubscribe();
    };
    __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_9" /* ViewChild */])('f'),
        __metadata("design:type", __WEBPACK_IMPORTED_MODULE_3__angular_forms__["e" /* NgForm */])
    ], ShoppingEditComponent.prototype, "slForm", void 0);
    ShoppingEditComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-shopping-edit',
            template: __webpack_require__("./src/app/shopping-list/shopping-edit/shopping-edit.component.html"),
            styles: [__webpack_require__("./src/app/shopping-list/shopping-edit/shopping-edit.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_2__shopping_list_service__["a" /* ShoppingListService */]])
    ], ShoppingEditComponent);
    return ShoppingEditComponent;
}());



/***/ }),

/***/ "./src/app/shopping-list/shopping-list.component.css":
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/shopping-list/shopping-list.component.html":
/***/ (function(module, exports) {

module.exports = "<div class=\"row\">\n  <div class=\"col-xs-10\">\n    <app-shopping-edit></app-shopping-edit>\n    <hr>\n    <ul class=\"list-group\">\n      <a class=\"list-group-item\" style=\"cursor: pointer\"\n         *ngFor=\"let ingredient of ingredients; let i = index\"\n         (click)=\"onEditItem(i)\"\n      >\n        {{ ingredient.name }} - {{ ingredient.amount}}\n      </a>\n    </ul>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/shopping-list/shopping-list.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ShoppingListComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("./node_modules/@angular/core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__shopping_list_service__ = __webpack_require__("./src/app/shopping-list/shopping-list.service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var ShoppingListComponent = /** @class */ (function () {
    function ShoppingListComponent(slService) {
        this.slService = slService;
    }
    ShoppingListComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.ingredients = this.slService.getIngredients();
        this.subscription = this.slService.ingredientsChanged.subscribe(function (ingredients) {
            _this.ingredients = ingredients;
        });
    };
    ShoppingListComponent.prototype.ngOnDestroy = function () {
        this.subscription.unsubscribe();
    };
    ShoppingListComponent.prototype.onEditItem = function (index) {
        this.slService.startedEditing.next(index);
    };
    ShoppingListComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-shopping-list',
            template: __webpack_require__("./src/app/shopping-list/shopping-list.component.html"),
            styles: [__webpack_require__("./src/app/shopping-list/shopping-list.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__shopping_list_service__["a" /* ShoppingListService */]])
    ], ShoppingListComponent);
    return ShoppingListComponent;
}());



/***/ }),

/***/ "./src/app/shopping-list/shopping-list.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ShoppingListService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__shared_ingredient_model__ = __webpack_require__("./src/app/shared/ingredient.model.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_rxjs_Subject__ = __webpack_require__("./node_modules/rxjs/_esm5/Subject.js");


var ShoppingListService = /** @class */ (function () {
    function ShoppingListService() {
        this.ingredientsChanged = new __WEBPACK_IMPORTED_MODULE_1_rxjs_Subject__["a" /* Subject */]();
        this.startedEditing = new __WEBPACK_IMPORTED_MODULE_1_rxjs_Subject__["a" /* Subject */]();
        this.ingredients = [
            new __WEBPACK_IMPORTED_MODULE_0__shared_ingredient_model__["a" /* Ingredient */]('Apples', 10),
            new __WEBPACK_IMPORTED_MODULE_0__shared_ingredient_model__["a" /* Ingredient */]('Orages', 12)
        ];
    }
    ShoppingListService.prototype.getIngredients = function () {
        return this.ingredients.slice();
    };
    ShoppingListService.prototype.getIndgredient = function (index) {
        return this.ingredients[index];
    };
    ShoppingListService.prototype.addIngredient = function (ingredient) {
        this.ingredients.push(ingredient);
        this.ingredientsChanged.next(this.ingredients.slice());
    };
    ShoppingListService.prototype.addIngredients = function (ingredients) {
        (_a = this.ingredients).push.apply(_a, ingredients);
        this.ingredientsChanged.next(this.ingredients.slice());
        var _a;
    };
    ShoppingListService.prototype.updateIngredient = function (index, newIngredient) {
        this.ingredients[index] = newIngredient;
        this.ingredientsChanged.next(this.ingredients.slice());
    };
    ShoppingListService.prototype.deleteIngredient = function (index) {
        this.ingredients.splice(index, 1);
        this.ingredientsChanged.next(this.ingredients.slice());
    };
    return ShoppingListService;
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
    Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_14" /* enableProdMode */])();
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