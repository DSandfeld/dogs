# The dog breeds app

## Intro
This app is intended to be simplistic and does not make use of third-party libraries for either networking, image caching or storage of favorites. It uses RxSwift to demonstrate the reactive approach.

## Architectural
On the architectural side of things the app's code is divided into groups/folders for each concept of models, views and viewmodels. Right beside folders for network response structs and UI files like nibs/storyboards.

## Patterns
MVVM
Singleton

## What's next
Dependency injection


## Building issues?
If the workspace is not fully working right out of the box, then cocoapods needs to be installed. To do that run 'sudo gem install cocoapods' in Terminal. When cocoapods is installed, then navigate to the root of the project directory and run 'pod install'
