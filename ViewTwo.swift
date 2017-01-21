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
    var capsesh : AVCaptureSession?
    let tesseract = G8Tesseract()
    
    
    var imgResult : AVCaptureStillImageOutput?
    var prelay : AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2
        tesseract.language = "eng"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 30.0

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
                    
                    prelay?.videoGravity = AVLayerVideoGravityResizeAspect
                    
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

    @IBOutlet var imgv: UIImageView!
    func photoShot(){
        if let videoConnection = imgResult?.connection(withMediaType: AVMediaTypeVideo){
                videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            imgResult?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
            
                if sampleBuffer != nil{
                    let imgd = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dp = CGDataProvider(data : imgd as! CFData)
                    let imgref = CGImage(jpegDataProviderSource: dp!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    DispatchQueue.main.async(execute: {
                        let img = UIImage(cgImage: imgref!, scale: 1.0, orientation: UIImageOrientation.right)
                        self.imgv.image = img
                        self.imgv.isHidden = false
                        self.cam.isHidden = true
                        let scaledImage = self.scaleImage(image: img, maxDimension: 640)
                        print(self.recog(image: scaledImage))
                        
                    
                    });
                    
                    
                }})
            
        }
    }
    var fototook = Bool()
    func anothaOne(){
        if fototook == true{
            imgv.isHidden = false
            fototook = false
        }else{
            capsesh?.startRunning()
            fototook = true
            imgv.isHidden = true
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
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        let a = UIAlertController(title: "Text Received", message: tesseract.recognizedText, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            a.dismiss(animated: true, completion: {
                
            })
        }
        a.addAction(action)
        self.present(a, animated: true) { 
            
        }
        // 7
        return tesseract.recognizedText
    }
    
}
