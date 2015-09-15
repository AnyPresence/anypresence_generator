# ***[Application Name]***Sdk
<%=j application_definition.name %>Sdk

## Description

***[A description of the type of SDK along with the app name.]***

This should serve as a guide for the ***[platform]*** SDK for <%=j application_definition.name %>

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

***[Code snippets showing how to setup / authenticate a user in the SDK]***

***[Below is an example from the Angular SDK README]***

Before you can authenticate with the SDK in your application  you must create an Auth Object in the Anypresence Designer and a user in your application's back end.
