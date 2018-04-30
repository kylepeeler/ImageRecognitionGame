# Scavenger Hunt
For our CSCI 490 data science final project, we created a image recognition scavenger hunt game. The objective of this game is to find 5 objects from a predetermined list of objects. The user is given 3 lives, and 3 attempts for each item. The user may choose to skip an item at the cost of a life. If the user finds all 5 objects, they win, else they lose. This game makes use of [Apple's CoreML](https://developer.apple.com/documentation/coreml), and Google's [Inception-v3 image classification model](https://arxiv.org/abs/1512.00567). We used a very small subset of the labels that Inception-v3 could recognize and that we thought were common objects in the classroom for the user to find.

# Build/Run
In order to build and run this project, you will need a Mac that is running at least XCode 9.3. This project makes use of [Cocoapods](https://cocoapods.org/) for dependency management. As such, you must open the project using the `ImageRecognitionGame.xcworkspace` file so that external dependencies are loaded properly. This app was designed to run on an iPhone X, but can be ran on any iPhone.

# Project breakdown 
The app idea was a collaboration between Nate and Kyle. We originally were anticipating on building a web app that would allow for multi-platform use. However after discovering the ease of use of Apple's CoreML technologies, we found it gave us an advantage to have the neural network running off the application itself. 

## [Nate's](https://github.com/rupsis) Contribution
Nate's initially designed the original application structure, before a mutual decision to create a native Swift app. He wrote the game logic for the application, and finished the app by pair programming with Kyle. 

## [Kyle's](https://github.com/kylepeeler) Contribution
Kyle's contribution was downloading the Inception-V3 model, implementing it using CoreML in our app, and creating a base proof of concept that allowed the user to capture an image and have the neural network output it's guess at what the object in the picture is. After doing this, I pair programmed the gamification logic that Nate developed into the application. We both then worked on the styling of the application to make it look pretty. We both extensively tested the application and had some of our friends give it a trial run to see if there were any user experience issues.

# Screenshots

### Start Screen
<img src="screenshots/IMG_0455.png" alt="Start Screen" style="width: 300px;"/>

### About Screen
<img src="screenshots/IMG_0456.png" alt="About Screen" style="width: 300px;"/>

### Find Label
<img src="screenshots/IMG_0457.png" alt="Guess Screen" style="width: 300px;"/>

### Found Label
<img src="screenshots/IMG_0458.png" alt="Found Label" style="width: 300px;">

# Video
### Example App Run
<img src="screenshots/ExampleRun.gif" alt="Example Run">





