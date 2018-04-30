# Scavenger Hunt
For our CSCI 490 data science final project, we created a image recognition scavenger hunt game. The objective of this game is to find 5 objects from a predetermined list of objects. The user is given 3 lives, and 3 attempts for each item. The user may choose to skip an item at the cost of a life. If the user finds all 5 objects, they win, else they lose. This game makes use of [Apple's CoreML](https://developer.apple.com/documentation/coreml), and Google's [Inception-v3 image classification model](https://arxiv.org/abs/1512.00567). We used a very small subset of the labels that Inception-v3 could recognize and that we thought were common objects in the classroom for the user to find.

# Building and Running
In order to build and run this project, you will need a Mac that is running at least XCode 9.3. This project makes use of [Cocoapods](https://cocoapods.org/) for dependency management. As such, you must open the project using the `ImageRecognitionGame.xcworkspace` file so that external dependencies are loaded properly. Within XCode you can build and run the application as usual. This app was designed to run on an iPhone X, but can be ran on any iPhone.

# Project breakdown 
The app idea was a collaboration between Nate and Kyle. The initial design was a front end (mobile browser) application that communicated with a backend interfacing with Google's Vision API to do object recognition and classification. We ran into a few issues with this design, specifically trying to send high resolution images across the web. After some more research, we deemed that using Apple's CoreML technologies with a pre-trained model would help remove the issues that we were facing. 

## [Kyle's](https://github.com/kylepeeler) Contribution
Kyle's contribution was downloading the Inception-V3 model, implementing it using CoreML in our app, and creating a base proof of concept that allowed the user to capture an image and have the neural network output it's guess at what the object in the picture is. After doing this, I pair programmed the gamification logic that Nate developed into the application. We both then worked on the styling of the application to make it look pretty. We both extensively tested the application and had some of our friends give it a trial run to see if there were any user experience issues.

## [Nate's](https://github.com/rupsis) Contribution
Nate's Contribution was initially designing the original application structure, before a mutual decision to create a native Swift app. After which, Nate wrote the rules of the game, helped define the application style, and wrote the game logic for the application. The final part of the application development was a collaborative effort with Kyle to test and debug the application before finishing the application styling.

# Video
### Example App Run
<img src="https://github.com/kylepeeler/ImageRecognitionGame/raw/master/Screenshots/ExampleRun.gif" alt="Example Run">

# Screenshots

### Start Screen
<img src="https://github.com/kylepeeler/ImageRecognitionGame/raw/master/Screenshots/IMG_0455.png" alt="Start Screen" width="300px"/>

### About Screen
<img src="https://github.com/kylepeeler/ImageRecognitionGame/raw/master/Screenshots/IMG_0456.png" alt="About Screen" width="300px"/>

### Find Label
<img src="https://github.com/kylepeeler/ImageRecognitionGame/raw/master/Screenshots/IMG_0457.png" alt="Guess Screen" width="300px"/>

### Found Label
<img src="https://github.com/kylepeeler/ImageRecognitionGame/raw/master/Screenshots/IMG_0458.png" alt="Found Label" width="300px">

# Future Work
In the future, we plan to release this app on Apple's App Store. We also plan to remove the use of the image library, as this was included for demo purposes. We also plan to train our own neural network using TensorFlow to allow for a wider (or more specific) variety of objects to find. We think this a good use case for this application is a student orientation scavenger hunt, for example having a neural network detect landmarks on a campus. This would allow for a new student to get oriented to a campus quickly. We also might look into monitizing this app by allowing the user to earn skips by watching ads.



