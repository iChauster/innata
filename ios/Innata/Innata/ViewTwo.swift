//
//  ViewTwo.swift
//  Innata
//
//  Created by Ivan Chau on 1/20/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit
import AVFoundation

class ViewTwo: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cam: UIView!
    @IBOutlet var active : UIActivityIndicatorView!
    var capsesh : AVCaptureSession?
    let tesseract = G8Tesseract()
    
    @IBOutlet var imgv: UIImageView!
    
    
    var imgResult : AVCaptureStillImageOutput?
    var prelay : AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        self.active.isHidden = true;
        super.viewDidLoad()
        
        // 2
        tesseract.language = "eng"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 45.0
        //when it captures
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func  viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prelay?.frame = cam.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cam.isHidden = false;
        imgv.isHidden = true;
        capsesh = AVCaptureSession()
        capsesh?.sessionPreset = AVCaptureSessionPresetHigh
        
        
        let camcord = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let inputMeth = try AVCaptureDeviceInput(device: camcord)
            if (capsesh?.canAddInput(inputMeth))!{
                capsesh?.addInput(inputMeth)
                imgResult = AVCaptureStillImageOutput()
                imgResult?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                if (capsesh?.canAddOutput(imgResult))!{
                    capsesh?.addOutput(imgResult)
                    
                    prelay = AVCaptureVideoPreviewLayer(session: capsesh)
                    prelay?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    
                    prelay?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    
                    //camview
                    
                    cam.layer.addSublayer(prelay!)
                    capsesh?.startRunning()
                }
            }
        }catch let error as NSError{
            print(error)
        }
    }
    
    func photoShot(){
        if let videoConnection = imgResult?.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            imgResult?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                
                if sampleBuffer != nil{
                    let imgd = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dp = CGDataProvider(data : imgd as! CFData)
                    let imgref = CGImage(jpegDataProviderSource: dp!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    let img = UIImage(cgImage: imgref!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    DispatchQueue.main.async(execute: {
                        self.imgv.image = img
                        self.imgv.isHidden = false
                        self.cam.isHidden = true
                        
                    });
                    let scaledImage = self.scaleImage(image: img, maxDimension: 720)
                    print(self.recog(image: scaledImage))
                    
                    
                }})
            
        }
    }
    var fototook = Bool()
    func anothaOne(){
        if fototook == true{
            fototook = false
        }else{
            capsesh?.startRunning()
            fototook = true
            photoShot()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anothaOne()
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
    
    func recog(image:UIImage) -> String{
        print("Image going through")
        self.active.isHidden = false
        self.active.startAnimating()
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        print(getPrice(str: tesseract.recognizedText))
        let arr = tesseract.confidences(by: .word) as! [G8RecognizedBlock]
        let title = tesseract.confidences(by: .textline) as! [G8RecognizedBlock]
        print(title[0].text)
        for a : G8RecognizedBlock in arr {
            if(a.text.caseInsensitiveCompare("Total") == .orderedSame){
                print("Total found")
                print(a.confidence)
                print(a.boundingBox(atImageOf: image.size))
                tesseract.image = image.g8_blackAndWhite()
                let r = a.boundingBox(atImageOf:image.size)
                tesseract.rect = r
                tesseract.rect.size.width = image.size.width;
                tesseract.rect.offsetBy(dx: 0.0, dy: -5.0)
                tesseract.rect.size.height += 10;
                tesseract.recognize()
            }//else if(){
                
            //}
        }
        print(tesseract.recognizedText)
        let a = UIAlertController(title: "Text Received", message: tesseract.recognizedText, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.cam.isHidden = false
            self.imgv.isHidden = true
            self.fototook = false
            a.dismiss(animated: true, completion: {
                
            })
        }
        a.addAction(action)
        self.present(a, animated: true) {
            self.active.stopAnimating()
            self.active.isHidden = true
        }
        
        // 7
        return tesseract.recognizedText
    }
    func getPrice(str : String) -> Double {
        
        if(str.contains("Total")){
            
            let arr = str.components(separatedBy: "Total")
            let b = arr[1].components(separatedBy: " ")
            let notDigits = NSCharacterSet.decimalDigits.inverted
            for a in b {
                /*if(a.rangeOfCharacter(from: notDigits)?.isEmpty)!{
                 return Double(a)!
                 }*/
            }
            
        }
        return 0.0;
        
    }
    
}
