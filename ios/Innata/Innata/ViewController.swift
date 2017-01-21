//
//  ViewController.swift
//  Innata
//
//  Created by Ivan Chau on 1/20/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        
        image.draw(in: CGRect(x:0, y:0, width:scaledSize.width, height:scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(image: selectedPhoto, maxDimension: 640)
        
        
        dismiss(animated: true, completion: {
            self.performImageRecognition(image: scaledImage)
        })
    }
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng+fra"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 60.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        print(tesseract.recognizedText)
        // 8
    }

}

