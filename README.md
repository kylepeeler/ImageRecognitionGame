# Scavenger Hunt
For our CSCI 490 data science final project, we created a image recognition scavenger hunt game. The objective of this game is to find 5 objects from a predetermined list of objects. The user is given 3 lives, and 3 attempts for each item. The user may choose to skip an item at the cost of a life. If the user finds all the items, they win, else they lose. This game makes use of Apple's CoreML, and Google's inception v3 image classification model. 

# Build/Run 

# Project breakdown 
The app idea was a collaboration between Nate and Kyle. The initial design was a front and web application that communicated with a backend interfacing with Google's Vision API to do object recognition and classification. We ran into a few issues with this design, specifically trying to send high resolution images across the web. After some more research, we deemed that trying to implement a pre-trained model would help remove the issues that we were facing. 

## [Nate's](https://github.com/rupsis) Contribution
Nate's initially designed the original application structure, before a mutual decision to create a native Swift app. He wrote the game logic for the application, and finished the app by pair programing with Kyle. 

## [Kyle's](https://github.com/kylepeeler) Contribution

# Sample runs