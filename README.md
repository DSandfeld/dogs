# The dog breeds app

## Intro
This app lists breeds of dogs using the public API https://dog.ceo/api/ and lets you save your favorite pooches to a personal persistent collection.

## Third party libraries
This app is intended to be simplistic and does not make use of third-party libraries for either networking, image caching or storage of favorites. It uses RxSwift to demonstrate the reactive approach. Thus using the bare iOS SDK from Apple as much as possible. This provides more fine grained control and proves that the basic is understood. 

## Architectural
On the architectural side of things the app's code is divided into groups/folders for each concept of models, views and viewmodels. Right beside folders for network response structs and UI files like nibs/storyboards.

## Patterns
The main theme is MVVM. A good foundation for nice structural code. For the services and managers a single instance is used, also known as singletons.

## What's next
- Dependency injection and resolving the interfaces to tighter bindings but allowing for loosely decoupled approaches, where parts of the code can be replaced and re-wired easily.
- CollectionViews with diffable datasources
- Fullscreen image presentation on the favorite page
- Searching
- Image placeholer 
- Loading indication for images and smooth effect when images get applied

## Building issues?
If the workspace is not fully working right out of the box, then cocoapods needs to be installed. To do that run 'sudo gem install cocoapods' in Terminal. When cocoapods is installed, then navigate to the root of the project directory and run 'pod install'
