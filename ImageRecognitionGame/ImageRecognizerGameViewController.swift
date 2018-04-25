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
    var labelsToFind = ["ballpoint, ballpoint pen, ballpen, Biro",
                        "backpack, back pack, knapsack, packsack, rucksack, haversack",
                        "coffee mug",
                        "digital watch",
                        "laptop, laptop computer",
                        "mouse, computer mouse",
                        "paper towel",
                        "pencil sharpener",
                        "rubber eraser, rubber, pencil eraser",
                        "sunglasses, dark glasses, shades",
                        "wall clock",
                        "banana",
                        "wallet, billfold, notecase, pocketbook",
                        "umbrella",
                        "toilet seat"]
    var lifeCount = 3
    var numberCorrect = 0
    var attempts = 3
    var currentLabelToFind: String?
    
    var startedGame: Bool = false
    
    func subtractLife(){
        self.lifeCount = self.lifeCount - 1;
        self.livesRemainingLabel.text = "\(self.lifeCount)"
        if (lifeCount < 1){
            self.performSegue(withIdentifier: "lostGame", sender: nil)
        }
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
        attempts = 3;
        currentLabelToFind = getRandomLabel()
        self.labelToFind.text = currentLabelToFind
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
                self.subtractLife();
                self.labelToFind.text = self.getRandomLabel();
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
        
        startedGame = true
        if startedGame{
            startText.isHidden = true
        }
        
        imageView.image = newImage
        
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        
        classifier.text = "I think this is a \(prediction.classLabel)."
        print("Detected image as \(prediction.classLabel)")
    }
}

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

