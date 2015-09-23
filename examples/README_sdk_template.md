# ***[Application Name]***Sdk
`<%=j application_definition.name %>`Sdk

## Description

***[A description of the type of SDK along with the app name.]***

This should serve as a guide for the ***[platform]*** SDK for `<%=j application_definition.name %>`

## Table of Contents


- [Project Structure](#project-structure)
- [Adding the SDK to your Application](#adding-the-sdk-to-your-application)
    - [Dependencies](#dependencies)
- [Setup and Initialize the SDK](#setup-and-initialize-the-sdk)
- [Local Caching](#local-caching)
- [Authentication](#authentication)
- [Models](#models)
***[Below is a code snippet to dynamically generate the model sub-sections]***
```
<% application_definition.object_definitions.each_with_index do |object_definition, index| %>
		<% suffix = ''
		if index > 0
			suffix = "-#{index}"
		end %>
		- [<%=j object_definition.name %>](#<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			- [Create](#create-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
      - [Read](#read-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			- [Update](#update-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			- [Delete](#delete-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
      - [Direct to Source](#direct-to-source-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			- [Query Scopes](#query-scopes-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			<% unless (object_definition.belongs_to_relationship_definitions.empty? and object_definition.has_one_relationship_definitions.empty? and object_definition.has_many_relationship_definitions.empty?) %>
			- [Relationships](#relationships-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>)
			<% end %>
	<% end %>
```
- [Push Notifications](#push-notifications)
    - [Register Device](#register-device)
    - [Unregister Device](#unregister-device)
    - [Subscribe to Channel](#subscribe-to-channel)
    - [Unsubscribe from Channel](#unsubscribe-from-channel)
    - [Send Message to Channel](#send-message-to-channel)
- [Development](#development)
    - [Placeholder for sub-sections]
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Miscellaneous](#miscellaneous)

## <a name="project-structure"></a> Project Structure

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

## <a name="adding-the-sdk-to-your-application"></a> Adding the SDK to your Application

***[Steps showing how to include/use the SDK in an app/project.]***

***[Below is an example from the Angular SDK README]***

In order to include this SDK within your Application simply take the file `ap_sdk.js`, found in the SDK folder at the root level. This file contains the entire SDK code in one file **without** the dependencies like JQuery. Take that file and copy it anywhere you want within you Application folder structure and just include it in your `index.html` using a <scripṭ/\> tag.

### <a name="dependencies"></a> Dependencies ***(Optional Section)***

***[Any additional information regarding dependencies that must be included in order for the SDK to work properly in your application.]***

***[Below is an example from the Angular SDK README]***

All the SDK dependencies can be found in the path *SDK_ROOT/sdk/lib/*, where SDK_ROOT is the folder where this SDK is. You must add this dependencies for the SDK to work properly, however, note that you can download this dependencies yourself if you wish, you don't **have** to use the ones in the lib folder specifically, they are included there as a convenience.

## <a name="setup-and-initialize-the-sdk"></a> Setup and Initialize the SDK

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

## <a name="local-caching"></a> Local Caching ***(Optional Section)***

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

## <a name="authentication"></a> Authentication

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

## <a name="models"></a> Models

Available Model objects:

***[Programmatically list all of the available model objects in SDK]***
```javascript
<% application_definition.object_definitions.each do |object_definition| %>
* <%=j object_definition.name %>
<% end %>
```

***[For each model provide code snippets showing how to call all CRUD methods, available query scopes, access all relationships, and access the local cache if applicable (i.e. iOS SDK)]***

***[Iterate over all of the available models passing them into the following code block]***
```
<% application_definition.object_definitions.each do |object_definition| %>
```
***[Sub-header with model's name]***
### `<%=j object_definition.name %>`

***[Below is the anchor link to use for the model's name]***
```
<a name="<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

***[Any specific instructions for how to use the model]***

***[Below is an example from the Angular SDK README]***

To use this model you have to inject `$<%=j object_definition.name.camelize(:lower) %>`.

***[Conditional statement to determine if it's a D2S model]***

<% if object_definition.storage_interface.direct_to_source == true %>

On DirectToSource Models you can specify certain values of the request being made to use string interpolation, but you also need a way of specifying what the context is going to be during that operation.

Aside from passing an interpolation context, CRUD methods and query scopes work exactly the same way as before.

This is how you would specify the interpolation context for the different ***CRUD*** methods:

***[Code snippets per D2S model showing how to call methods and pass the appropriate context.]***

#### Create

***[Below is the anchor link to use for the model's create sub-section]***
```
<a name="create-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

To create instances of `<%=j object_definition.name %>` do:

***[Code snippet showing how to create an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// The object passed to $save() will be used as the interpolation context
instance.$save({
  foo: "bar"
});
```

#### Read

***[Below is the anchor link to use for the model's read sub-section]***
```
<a name="read-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

***[Code snippet showing how to read an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// The object passed to get() as argument will be the interpolation context
$<%=j object_definition.name.camelize(:lower) %>.get({ foo: "bar" });
```

***[If local caching is enabled on a per request basis (i.e. iOS SDK) then specify that here and include a code snippet]***

#### Update

***[Below is the anchor link to use for the model's update sub-section]***
```
<a name="update-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

To update an instance you can call `instance.$save()` at any time.

***[Code snippet showing how to update an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// The object passed to $save() will be used as the interpolation context
instance.$save({
  foo: "bar"
});
```

#### Delete

***[Below is the anchor link to use for the model's delete sub-section]***
```
<a name="delete-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

To delete an instance:

***[Code snippet showing how to read an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
// The object passed to delete() as argument will be the interpolation context
$<%=j object_definition.name.camelize(:lower) %>.delete({ foo: "bar" });
```

<% else %>

#### Create

***[Below is the anchor link to use for the model's create sub-section]***
```
<a name="create-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

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

***[Below is the anchor link to use for the model's read sub-section]***
```
<a name="read-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

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

***[Below is the anchor link to use for the model's update sub-section]***
```
<a name="update-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

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

***[Below is the anchor link to use for the model's delete sub-section]***
```
<a name="delete-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

To delete an instance:

***[Code snippet showing how to read an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.delete({ id: "1" }).then(function() {
	// The instance with id = "1" got deleted from the server
});
```

***[End of conditional statement to determine if it's a D2S model]***
```
<% end %>
```

#### Query Scopes

***[Below is the anchor link to use for the model's query scopes sub-section]***
```
<a name="query-scopes-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

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

***[If the model is associated with any relationships then list them in a relationships section]***

***[Conditional statement to check if the model has any relationships associated with it ]***
```
<% unless (object_definition.belongs_to_relationship_definitions.empty? and object_definition.has_one_relationship_definitions.empty? and object_definition.has_many_relationship_definitions.empty?) %>
```

#### Relationships

***[Below is the anchor link to use for the model's relationships sub-section]***
```
<a name="relationships-<%=j object_definition.name.downcase.gsub(/\s/,'-') %>"></a>
```

***[Description of how relationships work within the overall context of the SDK as well as individual model instances]***

***[Below is an example from the Angular SDK README]***

To access relationships within a Model there is an object within __all__ Models called `$related` that holds the defined relationships. Relationships act like query scopes, you can pass success and error callbacks to any of them and they always return an empty Array that will be filled when the request returns from the server.

***[Conditional statement to check if the model has any `belongs_to` relationships associated with it ]***
```
<% unless object_definition.belongs_to_relationship_definitions.empty? %>
```

##### Belongs To

***[Iterate over the model's `belongs_to` relationships passing them into the following code block]***

```
<% object_definition.belongs_to_relationship_definitions.each do |belongs| %>
```

***[Sub-header with relationship's name]***

###### `<%=j belongs.object_definition.name %>`

***[Code snippet showing how to access the relationship on an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.$related.<%=j belongs.object_definition.name.downcase %>(function(result) {
	// result will be an Array with the related models
	console.log("Success!!");
}, function() {
	console.log("Error :(");
});
```

***[End of iterating the model's `belongs_to` relationships]***
```
<% end %>
```

***[End of conditional statement to check if the model has any `belongs_to` relationships associated with it]***
```
<% end %>
```

***[Conditional statement to check if the model has any `has_one` relationships associated with it ]***
```
<% unless object_definition.has_one_relationship_definitions.empty? %>
```

##### Has One

***[Iterate over the model's `has_one` relationships passing them into the following code block]***

```
<% object_definition.has_one_relationship_definitions.each do |hasOne| %>
```

***[Sub-header with relationship's name]***

###### <%=j hasOne.opposite_object_definition.name %>

***[Code snippet showing how to access the relationship on an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.$related.<%=j hasOne.opposite_object_definition.name.downcase %>(function(result) {
	// result will be an Array with the related models
	console.log("Success!!");
}, function() {
	console.log("Error :(");
});
```

***[End of iterating the model's `has_one` relationships]***
```
<% end %>
```

***[End of conditional statement to check if the model has any `has_one` relationships associated with it]***
```
<% end %>
```

***[Conditional statement to check if the model has any `has_many` relationships associated with it ]***
```
<% unless object_definition.has_many_relationship_definitions.empty? %>
```

##### Has Many

***[Iterate over the model's `has_many` relationships passing them into the following code block]***

```
<% object_definition.has_many_relationship_definitions.each do |hasMany| %>
```

***[Sub-header with relationship's name]***

###### <%=j hasMany.opposite_object_definition.name %>

***[Code snippet showing how to access the relationship on an instance of the model]***

***[Below is an example from the Angular SDK README]***

```javascript
$<%=j object_definition.name.camelize(:lower) %>.$related.<%=j hasMany.opposite_object_definition.name.downcase.pluralize %>(function(result) {
	// result will be an Array with the related models
	console.log("Success!!");
}, function() {
	console.log("Error :(");
});
```

***[End of iterating the model's `has_many` relationships]***
```
<% end %>
```

***[End of conditional statement to check if the model has any `has_many` relationships associated with it]***
```
<% end %>
```

***[End of conditional statement to check if the model has any relationships associated with it ]***
```
<% end %>
```

***[End of iterating over all of the available models]***
```
<% end %>
```

## <a name="push-notifications"></a> Push Notifications (Optional Section)

***[If push notifications are not available at all (i.e. Angular SDK) then specify that here]***

***[Section describing how to use push notifications in the SDK]***

***[Include descriptions of what each subsection means (i.e. what does registering a device mean, subscribing to a channel etc.)]***

***[Below is an example from the iOS SDK README]***

The SDK support push notification, including device registration and channel subscriptions.  The following as examples illustration how to accomplish each.

### <a name="register-device"></a> Register Device
```objective-c
[APPushNotification registerDevice:@"1234567890123456789012345678901234567890"
                          callback:^(NSString *response, NSError *error) {
                              if (!error) {
                                  NSLog(@"RESPONSE: %@", response);
                              }
}];
```

### <a name="unregister-device"></a> Unregister Device
```objective-c
[APPushNotification unregisterDevice:@"1234567890123456789012345678901234567890"
                            callback:^(NSString *response, NSError *error) {
                                if (!error) {
                                    NSLog(@"RESPONSE: %@", response);
                                }
}];
```

### <a name="subscribe-to-channel"></a> Subscribe to Channel
```objective-c
[APPushNotification subscribeToChannel:@"MyChannel"
                              deviceId:@"1234567890123456789012345678901234567890"
                              callback:^(NSString *response, NSError *error) {
                                  if (!error) {
                                      NSLog(@"RESPONSE: %@", response);
                                  }
}];
```

### <a name="unsubscribe-from-channel"></a> Unsubscribe from Channel
```objective-c
[APPushNotification unsubscribeFromChannel:@"MyChannel"
                                  deviceId:@"1234567890123456789012345678901234567890"
                                  callback:^(NSString *response, NSError *error) {
                                      if (!error) {
                                          NSLog(@"RESPONSE: %@", response);
                                      }
}];
```

### <a name="send-message-to-channel"></a> Send Message to Channel
```objective-c
APPushNotificationData *data = [[APPushNotificationData alloc] init];
data.alert = @"Foobar";
data.sound = @"ding";
data.badge = @"1";
data.expiry = 1000;

[APPushNotification sendMessage:@"FOOBAR"
                    channelName:@"MyChannel"
                        iOSData:data
                    androidData:nil
                       callback:^(NSString *response, NSError *error) {
                           if (!error) {
                               NSLog(@"RESPONSE: %@", response);
                           }
}];
```

## <a name="development"></a> Development

***[what dependencies are required to be installed for the user to make their own modifications to the SDK and then re-build it]***

***[Below is an example from the Angular SDK README]***

### Developing with Grunt

Grunt is a NodeJS-based task runner.  It helps automate common tasks, such as
asset compilation, minification, and testing.  Grunt tasks are included for this
SDK in `Gruntfile.js`.

Follow the directions below to get up and running with Grunt.

#### Prerequisites

- [NodeJS](http://nodejs.org)

#### Install NodeJS Modules

From the root directory of the SDK (where `Gruntfile.js` is
located), install NodeJS modules:

`npm install`

#### Build for Production

To compile assets and create a full production build, run the
build task:

`grunt build`

#### Development

During development, a full minified SDK build is unnecessary.  To
compile assets without minifying:

`grunt compile`

#### Automatic Compilation

Since it's cumbersome to manually compile assets after every change during
development, the SDK's `Gruntfile.js` includes a `watch` task.  The
task monitors changes to the SDK's `coffee` and `sass` assets,
automatically compiling (but not minifying) them.  Run the following command
before making changes:

`grunt watch`

## <a name="testing"></a> Testing

The SDK comes with a complete test suite.  Execute tests from grunt:

`grunt test`

SDK tests are also executed by the `watch` task.  If changing the SDK
significantly, some or all tests may fail.  You may disable auto-testing by
editing the `watch` task in `Gruntfile.js`.

The test suite can also be run directly in a browser.  Open `test/index.html` and click
"Run Tests".

## <a name="troubleshooting"></a> Troubleshooting

***[Section describing how to troubleshoot issues encountered while developing with the SDK]***

## <a name="miscellaneous"></a> Miscellaneous (Optional Section)

***[Any additional items not covered above that are pertinent only to specific SDKs]***
