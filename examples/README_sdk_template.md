# ***[Application Name]***Sdk
`<%=j application_definition.name %>`Sdk

## Description

***[A description of the type of SDK along with the app name.]***

This should serve as a guide for the ***[platform]*** SDK for `<%=j application_definition.name %>`

## Table of Contents

## Project Structure

General description of the files and folders you will find within this SDK project folder.

***[Below is an example from the Angular SDK README]***

* ap_sdk.js - The main SDK file, this contains all the code for this SDK except for third-party dependencies
* **custom** - Convenience folder where you can keep any additional code to add to this SDK
* **docs** - This folder contains all the documentation generated, you will find a web-based guide you can open on your browser
* Gruntfile.js - Grunt configuration and tasks, if you want to add code to this SDK you can use Grunt for development
* LICENSE.txt - The SDK license
* **node_modules** - NPM dependencies for development and testing
* package.json - The library definition manifest containing description, version and dependencies of this SDK
* README.md - This file
* **sdk** - Here you will find all the SDK code
	* **adapter** - AP.adapter module
	* **adapters** - *Generated adapters*
	* **ap** - Anypresence namespace definition
	* **application** - Application class definition
	* **auth** - Authentication module
	* **lib** - Dependencies
	* **model** - Model module
	* **models** - *Generated Models*
	* **utility** - Utility module
* **test** - SDK unit tests for generic modules and classes as well as generated Models

## Adding the SDK to your Application

***[Steps showing how to include/use the SDK in an app/project.]***

***[Below is an example from the Angular SDK README]***

In order to include this SDK within your Application simply take the file `ap_sdk.js`, found in the SDK folder at the root level. This file contains the entire SDK code in one file **without** the dependencies like JQuery. Take that file and copy it anywhere you want within you Application folder structure and just include it in your `index.html` using a <scripṭ/\> tag.

### Dependencies ***(Optional Section)***

***[Any additional information regarding dependencies that must be included in order for the SDK to work properly in your application.]***

***[Below is an example from the Angular SDK README]***

All the SDK dependencies can be found in the path *SDK_ROOT/sdk/lib/*, where SDK_ROOT is the folder where this SDK is. You must add this dependencies for the SDK to work properly, however, note that you can download this dependencies yourself if you wish, you don't **have** to use the ones in the lib folder specifically, they are included there as a convenience.

## Setup and Initialize the SDK

***[Code snippets showing how to initialize/setup the SDK correctly (base URL, auth URL, etc…).]***

***[Below is an example from the Angular SDK README]***

To setup the SDK within your application, first you need to declare

```javascript
angular.module("myApp", ["<%=j application_definition.name %>Sdk"]);
```

That will give you access to your Model services from Controllers, Factories, Services and so on. To use the SDK you must first provide a base URL for your backend server. You can do this by calling `$<%=j application_definition.name.camelize(:lower) %>SdkConfig.baseUrl.set()`

```javascript
angular.module("myApp")
	.controller("MyController", ["$<%=j application_definition.name.camelize(:lower) %>SdkConfig", function($<%=j application_definition.name.camelize(:lower) %>SdkConfig) {

		$<%=j application_definition.name.camelize(:lower) %>SdkConfig.baseUrl.set("https://www.foo.com");

	}]);
```
## Local Caching ***(Optional Section)***

***[If local caching is not available at all (i.e. Java SDK) then specify that here]***

***[If local caching is not enabled globally but instead on a per request basis (i.e. iOS SDK) then specify that here and include code snippet under the "read" method in the Models section]***

***[Code snippets showing how to enable local caching if local caching is enabled globally (i.e. Angular SDK)]***

***[Below is an example from the Angular SDK README]***

To enable local caching for your SDK you just need to enable it. Bear in mind that local caching only caches GET requests.

```javascript
angular.module("myApp")
	.controller("MyController", ["$<%=j application_definition.name.camelize(:lower) %>SdkConfig", function($<%=j application_definition.name.camelize(:lower) %>SdkConfig) {

		// Enable local caching
		$<%=j application_definition.name.camelize(:lower) %>SdkConfig.offlineCache.enable();
		// You can also disable it at any time
		$<%=j application_definition.name.camelize(:lower) %>SdkConfig.offlineCache.disable();

	}]);
```

## Authentication

Before you can authenticate with the SDK in your application  you must create an Auth Object in the Anypresence Designer and a user in your application's back end.

***[Code snippets showing how to setup / authenticate a user in the SDK]***

***[Below is an example from the Angular SDK README]***

```javascript
angular.module("myApp")
  .controller("MyController", ["$<%=j application_definition.name.camelize(:lower) %>SdkAuthentication", function($<%=j application_definition.name.camelize(:lower) %>SdkAuthentication) {

    // To login
    $<%=j application_definition.name.camelize(:lower) %>SdkAuthentication.login({
      username: "johndoe",
      password: "doe123"
    });

    $<%=j application_definition.name.camelize(:lower) %>SdkAuthentication.isAuthenticated();
    // true

    // To logout
    $<%=j application_definition.name.camelize(:lower) %>SdkAuthentication.logout();

    $<%=j application_definition.name.camelize(:lower) %>SdkAuthentication.isAuthenticated();
    // false

	}]);
```

## Models

Available Model objects:

***[Programmatically list all available model objects in SDK]***
```javascript
<% application_definition.object_definitions.each do |object_definition| %>
* <%=j object_definition.name %>
<% end %>
```

***[For each model provide code snippets showing how to call all CRUD methods, available query scopes, access all relationships, and access the local cache if applicable (i.e. iOS SDK)]***

***[Iterate over available models passing them into the following code block]***
```
<% application_definition.object_definitions.each do |object_definition| %>
```
***[Sub-header with model's name]***
### `<%=j object_definition.name %>`

***[Any specific instructions for how to use the model]***

***[Below is an example from the Angular SDK README]***

To use this model you have to inject `$<%=j object_definition.name.camelize(:lower) %>`.

#### Create

To create instances of `<%=j object_definition.name %>` do:

***[Code snippet showing how to create an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// The instance does not get saved to the server when created
var instance = $<%=j object_definition.name.camelize(:lower) %>.create({ name: "John" });
instance.lastName = "Doe";
instance.age = 28;
// To save the instance do
instance.$save().then(function() {
	// The instance got saved
});
```

#### Read

To read a specific instance by id you can do:

***[Code snippet showing how to read an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.get({ id: "1" }).then(function(response) {
	// The instance with id = "1" got fetched
	// instance data is in response.data
	console.log(response.data);
});
```

***[If local caching is enabled on a per request basis (i.e. iOS SDK) then specify that here and include a code snippet]***

#### Update

To update an instance you can call `instance.$save()` at any time.

***[Code snippet showing how to update an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// To update the instance pass an object containing the attributes you want to update to the $save method
instance.$save({
  age: 29
}).then(function() {
	// The instance got updated
});
```

#### Delete

To delete an instance:

***[Code snippet showing how to read an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.delete({ id: "1" }).then(function() {
	// The instance with id = "1" got deleted from the server
});
```

#### Query Scopes

The available query scopes for `<%=j object_definition.name %>` are:

***[Programmatically list all the available query scopes on the model]***
```
<% object_definition.query_scopes.each do |query_scope| %>
* <%=j query_scope.name %>
<% end %>
```

***[Iterate over the available query scopes on the model passing them into the following code block]***

```
<% object_definition.query_scopes.each do |query_scope| %>
```

***[Sub-header with query scope's name]***

##### `<%=j query_name %>`

***[Separate Object scopes from Aggregate scopes with a conditional statement]***

***[If the query scope is an Object scope]***
```
<% if query_scope.type == 'ObjectQueryScope' %>
```

***[Description of what the query scope is expected to return]***

***[Below is an example from the Angular SDK README]***

To fetch the values of a query scope you can just call the query scope from the model. Object scopes like this one return an empty Array that will get filled when the data comes back from the backend server.

***[Code snippet showing how to call the query scope on an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$scope.myScope = $<%=j object_definition.name.camelize(:lower) %>.<%=j query_name %>();
```

***[Code snippet showing how to filter the results of the query scope if applicable (optional)]***

***[Below is an example from the Angular SDK README]***

If the scope supports parameters to filter the results, then you can call them like so:

```javascript
$scope.myScope = $<%=j object_definition.name.camelize(:lower) %>.<%=j query_name %>({
	query: { // In query go the parameters for the scope
		name: "John",
		age: 40
	},
	// Pagination options
	limit: 15, // Max amount of results
	offset: 0,	// The index from which to start reading the amount of elements
}, function(collection) { // Success callback
	// Use the collection data returned
}, function(err) { // Error callback
	// There was an error while fetching the data
});
```

***[If the query scope is an Aggregate scope]***
```
<% elsif query_scope.type == 'AggregateQueryScope' %>
```

***[Description of what the query scope is expected to return]***

***[Below is an example from the Angular SDK README]***

To fetch the values of a query scope you can just call the query scope from the model. Aggregate scopes like this one return an Object with a single attribute. This attribute is always called `value` and it gets filled with the result of the query once the request comes back from the backend server.

***[Code snippet showing how to call the query scope on an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$scope.myScope = $<%=j object_definition.name.camelize(:lower) %>.<%=j query_name %>();
console.log($scope.myScope.value); // Would print a value like "3000" or undefined if the request hasn't returned yet
```

***[End of query scope conditional statement]***
```
<% end %>
```

***[End of iterating over available query scopes on the model]***
```
<% end %>
```