//
//  ImageRecognizerGameViewController.swift
//  ImageRecognitionGame
//
//  Created by Kyle Peeler on 4/16/18.
//  Copyright © 2018 Kyle Peeler. All rights reserved.
//

import UIKit
import CoreML

var model: Inceptionv3!

class ImageRecognizerGameViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    @IBOutlet weak var startText: UILabel!
    @IBOutlet weak var labelToFind: UILabel!
    @IBOutlet weak var livesRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var attemptsRemainingLabel: UILabel!
    var labelsToFind = ["ballpoint, ballpoint pen, ballpen, Biro",
                        "backpack, back pack, knapsack, packsack, rucksack, haversack",
                        "coffee mug",
                        "digital watch",
                        "notebook, notebook computer",
                        "mouse, computer mouse",
                        "paper towel",
                        "pencil sharpener",
                        "rubber eraser, rubber, pencil eraser",
                        "wall clock",
                        "banana",
                        "wallet, billfold, notecase, pocketbook",
                        "umbrella",
                        "toilet seat",
                        "monitor"
    ]
    var lifeCount = 3
    var numberCorrect = 0
    var attempts = 3
    var currentLabelToFind: String = ""
    
    var startedCapture: Bool = false
    
    func decrementLife(){
        self.lifeCount = self.lifeCount - 1;
        self.livesRemainingLabel.text = "\(self.lifeCount)"
        if (self.lifeCount < 1){
            self.performSegue(withIdentifier: "lostGame", sender: nil)
        }else{
            self.setNewLabel()
        }
        
    }
    
    func decrementAttempt(){
        self.attempts = self.attempts - 1;
        if (self.attempts == 0){
            let alert = UIAlertController(title: "Out of attempts", message: "You have used all the attempts on this label and got them incorrect. You have lost a life.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                self.decrementLife()
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.attemptsRemainingLabel.text = "\(attempts)"
        }
    }
    
    func incrementScore(){
        self.numberCorrect = self.numberCorrect + 1;
        self.scoreLabel.text = "\(numberCorrect)"
        if (self.numberCorrect >= 5){
            self.performSegue(withIdentifier: "wonGame", sender: nil);
        }else{
            let alert = UIAlertController(title: "Correct!", message: "Click continue to move onto the next label", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                self.setNewLabel()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func setNewLabel(){
        if let newLabel = getRandomLabel(){
            currentLabelToFind = newLabel
        }
        self.labelToFind.text = currentLabelToFind
        //reset attempts back to 3
        attempts = 3;
        attemptsRemainingLabel.text = "\(attempts)"
        classifier.text = ""
        self.imageView.isHidden = true
        startText.text = "Capture an image that matches the description above. Click the camera in the top left to take a photo."
        startText.isHidden = false
        
    }
    
    func getRandomLabel() -> String?{
        let randomIndex = Int(arc4random_uniform(UInt32(labelsToFind.count)));
        let randomLabel = labelsToFind[safe: randomIndex];
        if randomLabel != nil{
            labelsToFind.remove(at: randomIndex);
        }
        return randomLabel;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Inceptionv3()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifeCount = 3;
        numberCorrect = 0;
        self.setNewLabel();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func skip(_ sender: Any){
        var alertMessage = "You will lose a life if you decide to skip."
        if (lifeCount == 1){
            alertMessage = "You will lose the game if you decide to skip!"
        }
        
        let alert = UIAlertController(title: "Are you sure you want to skip?", message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "I'm sure", style: .destructive, handler: {action in
                self.decrementLife();
                self.setNewLabel();
                print("lives is now \(self.lifeCount)")
       }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func camera(_ sender: Any){
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any){
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        
        startText.isHidden = true
        
        imageView.image = newImage
        imageView.isHidden = false

        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        
        classifier.text = "I thought this was a \(prediction.classLabel)."
        if (prediction.classLabel == currentLabelToFind){
            incrementScore()
        }else{
            decrementAttempt()
        }
        print("Detected image as \(prediction.classLabel)")
        
    }
}

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

